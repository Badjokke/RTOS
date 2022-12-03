#pragma once
#include <hal/intdef.h>
class Heap_Manager{
private:
    //pointer na volnou pamet
    uint32_t mem_address = 0;
    //kolik zbyva pameti pro alokaci, nez budu syscallovat pro vic
    uint32_t remainder = 0;
    //kolik pozaduju po kernelu pameti
    //interni hromadka, kterou alokat ujida, pokud dojde, zavola kernel
    uint32_t increment_size = 0x1000;
public:
    Heap_Manager();
    void Sbrk();
    void* Alloc(uint32_t size);
    uint32_t Get_Mem_Address();
};
extern Heap_Manager h;
