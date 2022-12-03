#pragma once
#include <hal/intdef.h>
#include <Heap_Manager.h>

inline void* operator new(uint32_t size){
    return h.Alloc(size);
}

inline void *operator new(uint32_t, void *p)
{
    return p;
}
inline void *operator new[](uint32_t size)
{
    return h.Alloc(size);
}

inline void* malloc(uint32_t size){
    return h.Alloc(size);
}