#pragma once

#include <drivers/uart.h>
#include <fs/drivers/uart_fs.h>
#include <hal/peripherals.h>
#include <memory/kernel_heap.h>
#include <fs/filesystem.h>
#include <stdstring.h>
#include <buffers/uart_buffer.h>

// virtualni UART soubor
class CUART_File final : public IFile
{
    private:
        // UART kanal
        int mChannel;
        /*
        static const int buffer_size = 128;
        char uart_buffer[buffer_size];
        int buffer_pointer_w = 0;
        int buffer_pointer_r = 0;
        */
    public:
        CUART_File(int channel)
            : IFile(NFile_Type_Major::Character), mChannel(channel)
        {
        }

        ~CUART_File()
        {
            Close();
        }
        //syscall, pokud je kanal 0, pak precti uarti buffer
        virtual uint32_t Read(char* buffer, uint32_t num) override
        {
            uint32_t count = 0;
            if (num > 0 && buffer != nullptr)
            {
                if (mChannel == 0)
                {
                    count = sUART_buffer.Read_String(buffer,num);


                }
            }

            return count;
        }

        virtual uint32_t Write(const char* buffer, uint32_t num) override
        {
            if (num > 0 && buffer != nullptr)
            {
                if (mChannel == 0)
                {
                    sUART0.Write(buffer,num);
                }
            }

            return 0;
        }

        virtual bool Close() override
        {
            if (mChannel < 0)
                return false;

            if (mChannel == 0)
                sUART0.Close();
            mChannel = -1;

            return IFile::Close();
        }

        virtual bool IOCtl(NIOCtl_Operation dir, void* ctlptr) override
        {
            // proces chce ziskat parametry - naformatujeme mu je do jim dodane struktury (v jeho adr. prostoru)
            if (dir == NIOCtl_Operation::Get_Params)
            {
                TUART_IOCtl_Params* params = reinterpret_cast<TUART_IOCtl_Params*>(ctlptr);
                if (mChannel == 0)
                {
                    params->baud_rate = sUART0.Get_Baud_Rate();
                    params->char_length = sUART0.Get_Char_Length();
                    return true;
                }
            }
            // proces chce nastavit parametry
            else if (dir == NIOCtl_Operation::Set_Params)
            {
                TUART_IOCtl_Params* params = reinterpret_cast<TUART_IOCtl_Params*>(ctlptr);
                if (mChannel == 0)
                {
                    sUART0.Set_Baud_Rate(params->baud_rate);
                    sUART0.Set_Char_Length(params->char_length);
                    sUART0.Set_Blocking_Read(params->blocking);
                    return true;
                }
            }
            return false;
        }
};

class CUART_FS_Driver : public IFilesystem_Driver
{
	public:
		virtual void On_Register() override
        {
            //
        }

        virtual IFile* Open_File(const char* path, NFile_Open_Mode mode) override
        {
            // jedina slozka path - kanal UARTu

            int channel = atoi(path);
            if (channel != 0) // mame jen jeden kanal
                return nullptr;

            if (!sUART0.Open())
                return nullptr;

            CUART_File* f = new CUART_File(channel);

            return f;
        }
};
CUART_FS_Driver fsUART_FS_Driver;
