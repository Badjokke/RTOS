#include <drivers/uart.h>
#include <drivers/bcm_aux.h>
#include <drivers/gpio.h>
#include <interrupt_controller.h>
#include <buffers/uart_buffer.h>
#include <stdstring.h>

CUART sUART0(sAUX);

CUART::CUART(CAUX& aux)
    : mAUX(aux), mOpened(false)
{

}

//[JT] prijde preruseni -> zapis char do kruhoveho bufferu v kernelu
void CUART::Handle_IRQ(){
    // registr neni nastaveny ze ma prichozi znak, utecu
    // if(sUART0.Is_IRQ_Pending())return;
    char c = sUART0.Read();
    sUART_buffer.Add_Char(c);
    //qemu enterem posila \r, ale newline bere porad jako \n
    if(c == '\r')
        c = '\n';
    sUART0.Write(c);
}
void CUART::Set_Blocking_Read(NUART_Blocking_Read state){
    blocking_read = state == NUART_Blocking_Read::Blocking;
}
bool CUART::Is_IRQ_Pending(){
    return mAUX.Get_Register(hal::AUX_Reg::MU_LSR) & 1;
}
//otevre uart komunikaci
bool CUART::Open()
{
    // TODO: zamek, aby se neco neseslo

    if (mOpened)
        return false;

    // rezervujeme si TX a RX piny, exkluzivne pro nas (R i W, ackoliv je jeden jen vstupni a jeden jen vystupni)
    if (!sGPIO.Reserve_Pin(14, true, true))
        return false;

    if (!sGPIO.Reserve_Pin(15, true, true))
    {
        sGPIO.Free_Pin(14, true, true);
        return false;
    }

    mAUX.Enable(hal::AUX_Peripherals::MiniUART);
    //priznak reciever interrupt na registru
    /*
    //na LST nastav 1
    mAUX.Set_Register_Bit(hal::AUX_Reg::MU_IER,0);
    //povol uart IRQ
    sInterruptCtl.Enable_IRQ(hal::IRQ_Source::UART);
    //povol AUX interrupt, uart je AUX, IRQcka kaskaduji AUX --> UART, bez tohoto povoleneho nebude mozne dostavat
    //UART irq
    sInterruptCtl.Enable_IRQ(hal::IRQ_Source::AUX);
     */
    //mAUX.Set_Register_Bit(hal::AUX_Reg::MU_IER,0);
    mAUX.Set_Register(hal::AUX_Reg::MU_IIR, 0);
    mAUX.Set_Register(hal::AUX_Reg::MU_IER, 1);
    mAUX.Set_Register(hal::AUX_Reg::MU_MCR, 0);
    mAUX.Set_Register(hal::AUX_Reg::MU_CNTL, 3); // RX and TX enabled

    // nastavime GPIO 14 a 15 na jejich alt funkci 5, coz je UART kanal 1
    sGPIO.Set_GPIO_Function(14, NGPIO_Function::Alt_5);
    sGPIO.Set_GPIO_Function(15, NGPIO_Function::Alt_5);

    mOpened = true;

    // nastavime vychozi rychlost a velikost znaku
    Set_Char_Length(NUART_Char_Length::Char_8);
    Set_Baud_Rate(NUART_Baud_Rate::BR_9600);

    return true;
}

void CUART::Close()
{
    if (!mOpened)
        return;

    // zakazeme AUX periferii
    mAUX.Disable(hal::AUX_Peripherals::MiniUART);

    // piny 14 a 15 prepneme na Input (tak zerou nejmin proudu)
    sGPIO.Set_GPIO_Function(14, NGPIO_Function::Input);
    sGPIO.Set_GPIO_Function(15, NGPIO_Function::Input);

    // uvolnime piny
    sGPIO.Free_Pin(14, true, true);
    sGPIO.Free_Pin(15, true, true);

    mOpened = false;
}

bool CUART::Is_Opened() const
{
    return mOpened;
}

NUART_Char_Length CUART::Get_Char_Length()
{
    if (!mOpened)
        return NUART_Char_Length::Char_8;

    return static_cast<NUART_Char_Length>(mAUX.Get_Register(hal::AUX_Reg::MU_LCR) & 0x1);
}

void CUART::Set_Char_Length(NUART_Char_Length len)
{
    if (!mOpened)
        return;

    mAUX.Set_Register(hal::AUX_Reg::MU_LCR, (mAUX.Get_Register(hal::AUX_Reg::MU_LCR) & 0xFFFFFFFE) | static_cast<unsigned int>(len));
}

NUART_Baud_Rate CUART::Get_Baud_Rate()
{
    if (!mOpened)
        return NUART_Baud_Rate::BR_1200;

    return mBaud_Rate;
}

void CUART::Set_Baud_Rate(NUART_Baud_Rate rate)
{
    if (!mOpened)
        return;

    mBaud_Rate = rate;

    const unsigned int val = ((hal::Default_Clock_Rate / static_cast<unsigned int>(rate)) / 8) - 1;

    mAUX.Set_Register(hal::AUX_Reg::MU_CNTL, 0);

    mAUX.Set_Register(hal::AUX_Reg::MU_BAUD, val);

    mAUX.Set_Register(hal::AUX_Reg::MU_CNTL, 3);
}

char CUART::Read(){
    //if(blocking_read)
    /*while(!(mAUX.Get_Register(hal::AUX_Reg::MU_LSR) & 1))
        ;*/
    //precti hodnotu registru
    uint32_t register_value = mAUX.Get_Register(hal::AUX_Reg::MU_IO);

    //hod to do charu a navrat hodnotu
    return static_cast<char>(register_value);
}

void CUART::Write(char c)
{
    if (!mOpened)
        return;

    // dokud ma status registr priznak "vystupni fronta plna", nelze prenaset dalsi bit
    while (!(mAUX.Get_Register(hal::AUX_Reg::MU_LSR) & (1 << 5)))
        ;

    mAUX.Set_Register(hal::AUX_Reg::MU_IO, c);
}

void CUART::Write(const char* str)
{
    return;
    if (!mOpened)
        return;

    int i;

    for (i = 0; str[i] != '\0'; i++)
        Write(str[i]);
}

void CUART::Write(const char* str, unsigned int len)
{
    if (!mOpened)
        return;

    unsigned int i;

    for (i = 0; i < len; i++)
        Write(str[i]);
}

void CUART::Write(unsigned int num)
{
    if (!mOpened)
        return;

    static char buf[16];

    itoa(num, buf, 10);
    Write(buf);
}

void CUART::Write_Hex(unsigned int num)
{
    if (!mOpened)
        return;

    static char buf[16];

    itoa(num, buf, 16);
    Write(buf);
}