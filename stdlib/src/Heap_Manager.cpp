#include <Heap_Manager.h>

Heap_Manager h;
//spravce pameti na halde uzivatelskeho procesu
//inkrementalni alokace a neumi free
//aby umel free nejak rozumne, nutne implementovat napriklad seznamem der/procesu nebo buddy systemem
Heap_Manager::Heap_Manager(){};
//syscall pro prideleni pameti na halde od kernelu
void Heap_Manager::Sbrk(){

    uint32_t rdnum;
    //uint32_t increment_count = Get_Increment_Count();
    asm volatile("mov r0, %0" : : "r" (increment_size));
    asm volatile("swi 6");
    asm volatile("mov %0, r0" : "=r" (rdnum));
    //pokud je to muj prvni kus haldy, vrat pointer na zacatek haldy
    //dal si tohle ukazovatko spravuje stdlib sam
    if(mem_address == 0){
        mem_address = rdnum;
        remainder = rdnum + increment_size;
        return;
    }
    remainder += increment_size;
}
//dej mi aktualni adresu, kam chces zapisovat na halde
//pouzito pro pripadny debugging
uint32_t Heap_Manager::Get_Mem_Address(){
    return mem_address;
}
//alokuj mi na halde velikost @param size
void* Heap_Manager::Alloc(uint32_t size){
    //uz se mi vic nevejde, musim syscallnout, dokud se vejdu
    while(mem_address + size > remainder)
        Sbrk();
    uint32_t address = mem_address;
    mem_address += size;
    return reinterpret_cast<void*>(address);
}

