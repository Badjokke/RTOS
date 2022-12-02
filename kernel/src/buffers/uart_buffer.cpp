#include <buffers/uart_buffer.h>
#include <drivers/uart.h>
//[JT] pridej prave jeden char do bufferu
void UART_Buffer::Add_Char(char c) {
    //while(spinlock_try_lock(&mLock_State) == Lock_Locked);
    buffer[write_index++] = c;
    //spinlock_unlock(&mLock_State);
    write_index %= BUFFER_SIZE;
}
//zjisti, kolik toho muzu cist
uint32_t UART_Buffer::Get_Buffer_Size(){
    //nic nemam
    if(Is_Empty()) return 0;
    //write uz obtekl kolem
    if(read_index > write_index)
        return BUFFER_SIZE - (read_index - write_index);

    return write_index - read_index;
}




//[JT] precti prave jeden char z bufferu
char UART_Buffer::Get_Char(){
    //while(spinlock_try_lock(&mLock_State) == Lock_Locked);
    char c = buffer[read_index++];
    //spinlock_unlock(&mLock_State);

    read_index %= BUFFER_SIZE;
    return c;
}
//[JT] vrati pocet prectenych znaku
uint32_t UART_Buffer::Read_String(char* buffer, uint32_t size){
    //nulovej buffer poskytnut user procesem nebo nemam co ke cteni
    if(Is_Empty() || size == 0)return 0;
    //kolik muzu cist znaku
    uint32_t bfr_size = Get_Buffer_Size();
    uint32_t end = size;

    // pokud je poskytnuty buffer vetsi nez muzu precist znaku, tak jedu jenom do poctu znaku, ktere mam
    if(size > bfr_size)
        end = bfr_size;
    int i;
    for(i = 0; i < end; i++)
        buffer[i] = Get_Char();

    return end;
}

bool UART_Buffer::Is_Empty(){
    return read_index == write_index;
}
void UART_Buffer::Clear(){
    read_index = 0;
    write_index = 0;
}

UART_Buffer::UART_Buffer(){
    spinlock_init(&mLock_State);
}
//[JT] instance uart bufferu kernel jadra
UART_Buffer sUART_buffer;