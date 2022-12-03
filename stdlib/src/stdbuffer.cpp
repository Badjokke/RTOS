#include <stdbuffer.h>




Buffer::Buffer(uint32_t file_desc):file(file_desc){};

//jsem prazdny?
bool Buffer::Is_Empty(){
    return read_pointer == write_pointer;
}
//jsem plny?
bool Buffer::Is_Full(){
    return write_pointer == buffer_size;
}
//pridej byte do bufferu
void Buffer::Add_Byte(char c){
    out_buffer[write_pointer] = c;
    write_pointer++;
}
//vycisti buffer
void Buffer::Clear(){
    read_pointer = 0;
    write_pointer = 0;
}
//vypis na uart
//vlastne neni write line, ale write, endline znak to neposila, pokud neni obsazen v retezci
void Buffer::Write_Line(const char* str){
    write(file, str, strlen(str));
}
// bread and butter komunikace usertasku s uartem
//v podstate se dotazuje kernelu porad, jestli nema neco z uartu
//potom vsechny prectete z kernel bufferu nakopiruje do interniho bufferu
//nasledne v tomto bufferu hleda uceleny user input, tedy <neco>\r pro qemu
//pri detekci ucelenho inputu vrati tento input
//jinak vraci nullptr -> uzivatel nic nezadal
//neni blokujici
char* Buffer::Read_Uart_Line(){
    //precti user input na uartu, pokud ho mam kam ulozit
    bool out_buffer_full = Is_Full();
    //pokud neni muj output buffer plny - zeptej se jadra, jestli neni neco na uartu
    if(!out_buffer_full){
        uint32_t count = read(file,buffer,buffer_size);
        //neco jsem precetl - vloz do bufferu
        if(count > 0)
            Add_Bytes(count);
        }
    //nic nemam - utec
    if(write_pointer == 0)return nullptr;
    int i,j;
    bool line_found = false;
    for(i = 0; i < write_pointer; i++){
        if(out_buffer[i] == '\r' && i>0){
            line_found = true;
            break;
        }
    }

    //buffer je plny a zaroven jsem nenasel newline, zacni prepisovat data v bufferu
    //nemelo by nastat pri beznem pouzivani single-task vypoctu
    if(!line_found){
        if(out_buffer_full)
            Clear();
        return nullptr;
    }
    //asi trochu memory hog
    //mozna nevhodne pro RTOS, protoze nemuze garantovat cas alokace na halde / samotnou alokaci
    char* bfr = new char[20];
    // prekopiruj string a posli ho ven
    for(j = 0; j < i; j++){
        bfr[j] = out_buffer[j];
    }
    bfr[j] = '\0';
    //precetl jsem radek vstupu, "flush" buffer
    write_pointer = 0;
    return bfr;
    }
//pridej @param len byteu do bufferu
void Buffer::Add_Bytes(uint32_t len){
    for(uint32_t i = 0; i < len; i++){
        Add_Byte(buffer[i]);
    }
}
//zablokuj se nad ctenim uartu dokud nedostanes user input
char* Buffer::Read_Uart_Line_Blocking(int expected_type){
    char* line;
    while(1){
        //samotne cteni neni blokuji -> tocime se dokolecka dokola
        line = Read_Uart_Line();
        //prisel mi vstup od uzivatele
        if(line != nullptr){
            //mrkneme se, co je za datovy typ precteny radek od uzivatele
            int type = get_input_type(line);
            if(type == expected_type)
                break;
            Write_Line("Neplatny vstup. Ocekavam cele cislo.\n");
            Write_Line(">");
            line = nullptr;
        }
        //nic tam nebylo - spi, dokud neprijde IRQ, v pripade semestralky IRQ chodi pouze z UARTU
        asm volatile("wfi");
    }
    return line;
}