#pragma once
#include <hal/intdef.h>
#include <stdfile.h>
#include <stdstring.h>
#include <memory.h>
//userspace buffer, ktery umozni cteni radku od uzivatele
class Buffer{
private:
    static const uint32_t buffer_size = 128;

    uint32_t read_pointer = 0;
    uint32_t write_pointer = 0;

    //do tohoto bufferu se zapisuji jednotlive chary z kernel bufferu
    char buffer[buffer_size];
    uint32_t file;
    //do tohoto bufferu se zapisuji veci dotazene z kernel bufferu a hleda se v nem user input zakonceny \r
    char out_buffer[buffer_size];
    void Add_Byte(char c);
    void Add_Bytes(uint32_t len);
    bool Is_Empty();
    bool Is_Full();
public:
    Buffer(uint32_t file_desc);
    char* Read_Uart_Line();
    char* Read_Uart_Line_Blocking(int expected_type);
    void Clear();
    void Write_Line(const char* str);
};