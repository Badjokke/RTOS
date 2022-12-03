//
// Created by trefil on 15.11.2022.
//
#include <stdstring.h>
#include <stdbuffer.h>
#include <drivers/bridges/uart_defs.h>
#include <memory.h>
#include <Model.h>
#include <stdbuffer.h>
//konstantni parametry modelu
const int POPULATION_COUNT = 1000;
const int EPOCH_COUNT = 50;
const int DATA_WINDOW_SIZE = 20;

//vytvor sample data pro model
void dummy_data(float* data){
    //sample data
    data[0] = 3.487;
    data[1] = 4.486;
    data[2] = 5.876;
    data[3] = 6.4876;

    data[4] = 7.486;
    data[5] = 8.4876;
    data[6] = 9.476;
    data[7] = 11.76;
    data[8] = 13.76;
    data[9] = 16.4876;
    data[10] = 16.4876;
    data[11] = 16.876;
    data[12] = 16.9876;
    data[13] = 17.4876;
    data[14] = 17.9876;
    data[15] = 18.4876;
    data[16] = 18.9876;
    data[17] = 19.4576;
    data[18] = 19.4576;
    data[19] = 19.9876;


}
//vypis na uart uvodni srandicky
void hello_uart_world(Buffer* bfr){
    bfr->Write_Line("CalcOS v1.1\n");
    bfr->Write_Line("Autor: Jiri Trefil (A22N0060P)\n");
    bfr->Write_Line("Zadejte nejprve casovy rozestup a predikcni okenko v minutach\n");
    bfr->Write_Line("Dale podporovany prikazy: stop, parameters\n");
    bfr->Write_Line("stop - zastavi fitting modelu\n");
    bfr->Write_Line("parameters - vypise parametry modelu\n");
}


int main(){
    //otevri uart na read/write
    uint32_t uart_file = open("DEV:uart/0", NFile_Open_Mode::Read_Write);
    //Model pro predikci hladiny glukozy v krvi
    Model* m;
    //Buffer pro komunikaci s uartem
    Buffer* bfr;
    //"okenko" dat - sem strkame data od uzivatele a predavame je modelu
    //float* data;
    /*uint32_t address = reinterpret_cast<uint32_t>(malloc(4));
    char baff[20];
    itoa(address,baff,16);*/
    char* x = new char[4];//reinterpret_cast<char*>(address);

    //pomocne stringy pro strcat funkci, abych nejak rozumne odpovdel uzivateli, neni to uplne hezke
    char tmp1[] = "OK, predpoved ";
    char tmp2[] = "OK, krokovani ";
    char tmp3[] = " minut\n";

    //buffer pro vyhazovani outputu uzivateli
    char tmp_str[128] = {0};


    bfr = new Buffer(uart_file);

    bfr->Write_Line(x);

    bfr->Write_Line("\n");
    //vypis uzivateli uvodni povidani
    hello_uart_world(bfr);
    //zablokuj se dokud neprectes int
    bfr->Write_Line(">");
    char* t_delta = bfr->Read_Uart_Line_Blocking(INT_INPUT);
    strncat(tmp_str,tmp1,128);
    strncat(tmp_str,t_delta,128);
    strncat(tmp_str,tmp3,128);
    bfr->Write_Line(tmp_str);
    tmp_str[0] = '\0';

    //zablokuj se dokud neprectes int
    bfr->Write_Line(">");
    char* t_pred = bfr->Read_Uart_Line_Blocking(INT_INPUT);

    strncat(tmp_str, tmp2,128);
    strncat(tmp_str,t_pred,128);
    strncat(tmp_str, tmp3,128);
    bfr->Write_Line(tmp_str);
    tmp_str[0] = '\0';


    //vyparsuj hodnoty od uzivatele na inty
    const int T_PRED_NUM = atoi(t_delta);
    const int T_DELTA_NUM = atoi(t_pred);

    //trida ktera v podstate obaluje hlavni vypocet a interakci s uzivatelem
    m = new Model(T_PRED_NUM,T_DELTA_NUM,POPULATION_COUNT,EPOCH_COUNT,DATA_WINDOW_SIZE,bfr);

    m->Set_Buffer(bfr);
    /**
    Random_Generator* random = new Random_Generator(-5 * 1000, 5 * 1000, 4, 1, 42);
    for(int i = 0; i < 100; i++){
        float f = random->Get_Float();
        ftoa(f,tmp_str);
        bfr->Write_Line(tmp_str);
        bfr->Write_Line("\n");
    }
        */
//hlavni smycka programu
    m->Run();

    //sem bych nikdy nemel spadnout
    bfr->Write_Line("Single task konec, cauky mnauky\n");
    close(uart_file);

    /**
     * todo free pameti neumim
     */
    return 0;

}
