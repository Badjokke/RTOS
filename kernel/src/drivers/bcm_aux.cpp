#include <drivers/bcm_aux.h>

CAUX sAUX(hal::AUX_Base);

CAUX::CAUX(unsigned int aux_base)
    : mAUX_Reg(reinterpret_cast<unsigned int*>(aux_base))
{
    //
}

void CAUX::Enable(hal::AUX_Peripherals aux_peripheral)
{
    Set_Register(hal::AUX_Reg::ENABLES, Get_Register(hal::AUX_Reg::ENABLES) | (1 << static_cast<uint32_t>(aux_peripheral)));
}

void CAUX::Disable(hal::AUX_Peripherals aux_peripheral)
{
    Set_Register(hal::AUX_Reg::ENABLES, Get_Register(hal::AUX_Reg::ENABLES) & ~(1 << static_cast<uint32_t>(aux_peripheral)));
}
void CAUX::Set_Register_Bit(hal::AUX_Reg reg_idx, uint32_t position){
    uint32_t registerValue = Get_Register(reg_idx);
    registerValue = registerValue | (1 << position);
    Set_Register(reg_idx,registerValue);
}

void CAUX::Clear_Register_Bit(hal::AUX_Reg reg_idx, uint32_t position){
    uint32_t registerValue = Get_Register(reg_idx);
    registerValue = registerValue && (0 << position);
    Set_Register(reg_idx,registerValue);
}
void CAUX::Set_Register(hal::AUX_Reg reg_idx, uint32_t value)
{
    mAUX_Reg[static_cast<unsigned int>(reg_idx)] = value;
}

uint32_t CAUX::Get_Register(hal::AUX_Reg reg_idx)
{
    return mAUX_Reg[static_cast<unsigned int>(reg_idx)];
}
