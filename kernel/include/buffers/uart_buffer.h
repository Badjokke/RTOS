#pragma once
#include <board/rpi0/hal/intdef.h>
#include <process/spinlock.h>
//[JT] kruhovy buffer pro uart
//trida je vlastne genericky cyklicky buffer, nemusi byt nutne UARTovy
// v ramci semestralky to ale nehrotim a ostitkuju jej tak
//kazdopadne jich muze existovat vice a muzou slouzit
class UART_Buffer{
private:
    static const uint32_t BUFFER_SIZE = 128;
    char buffer[BUFFER_SIZE];
    uint32_t write_index = 0;
    uint32_t read_index = 0;
    spinlock_t mLock_State = Lock_Unlocked;
    virtual char Get_Char();
    //kolik toho muzu precist
    uint32_t Get_Buffer_Size();
public:
    UART_Buffer();
    void Add_Char(char c);
    bool Is_Empty();
    uint32_t Read_String(char* buffer, uint32_t size);
    void Clear();

};
extern UART_Buffer sUART_buffer;