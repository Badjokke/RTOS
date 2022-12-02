#pragma once
#include <Random.h>
#include <memory.h>
#include <stdbuffer.h>
#include <stdstring.h>
#include <Sort.h>
//nejaky numero indikujici prazdne misto ve floatu
//asi by bylo lepsi tam dat nejake velke a divne
//ale 42 je 42
#define EMPTY -42
//pocet parametru modelu, tedy A...E
#define PARAMETER_COUNT 5
//clen populace
//ma svoje parametry a fitness ohodnoceni
struct Tribesman{
    //A,B,C,D,E
    float parameters[PARAMETER_COUNT];
    //cim vyssi, tim horsi
    float fitness;
    //hodnoty, ktere predikoval
    float* predicted_values;
};
//optimalne by tahle trida jenom pocitala
//o uart komunikaci by se starala jina trida
//tim by byl dodrzen single resposibility principle
//takze tahle trida vlastně obaluje cely ten "Single task vypocet"
class Model {

private:
    // skoky po x respektive t ose
    int t_delta;
    // predikcni skok
    int t_pred;
    //interval generovani random hodnot pro parametry
    int min_parameter_value = -5;
    int max_parameter_value = 5;
    //aproximace derivace
    static constexpr float derivative_value = 1.0/(24.0*60.0*60.0);
    //kolik dat udrzim
    int window_size;
    //pocet clenu populace
    int population_count;
    //pocitej nebo nepocitej
    bool is_fitting = false;
    //ukazovatko do dat pro zapis
    int data_pointer;
    //pocet epoch
    int epoch_count;
    //populace
    Tribesman** population = nullptr;
    //nejlepsi z generace - z nej se budou vypisovat parametry
    Tribesman* alpha = nullptr;
    //pseudorandom engine, neni moc dobrej, ale it is what it is
    Random_Generator* random = nullptr;
    //buffer pro uart komunikaci
    Buffer* bfr;

    //minimalni chyba
    float min_error = 0.2;

    //data zadany uzivatel - tedy korektni hodnoty
    float* data = nullptr;
    //priznak vejdou se jeste hodnoty do struktury
    bool Is_Data_Window_Full();
    //spocita fitness clena populace
    float Calculate_Fitness(Tribesman* tribesman);
    //alokace pameti pro struktury
    void Init();
    //inicializuj prvni generaci
    void First_Generation();
    //koukni na uart, jestli tam neni neco rozumneho
    void Checkpoint();
    //vypocitej y(t+t_pred)
    float Calculate_Prediction(float* parameters, float y);
    //vypocitej b(t)
    float Calc_B(float D, float E, float y);
    //nastav nejlepsiho z populace
    void Set_Alpha(Tribesman* t);
    //vypocti t+t_delta pro dostupne datove vzorky
    void Predict(Tribesman* tribesman);
    //krizeni, ppst krizeni 20%
    void Gene_Pool_Party(Tribesman** population);
    //nahodna mutace
    void Mutation(Tribesman** population);
    //vyzvi uzivatele ke vstupu
    void Prompt_User();
    //koukni se, co ten borec chce delat s modelem
    void Eval_String_Command(const char *str);
    //pridej hodnotu v case t
    bool Add_Data_Sample(float y);
    //vypise parametry A...E nejlepsiho z generace
    void Print_Parameters();

public:
    //konstruktor prebira parametry od uzivatele, t_delta a t_pred
    //population count a epoch count jsou hard coded mnou, da se s nimi nejak hybat
    Model(int t_delta, int t_pred, int population_count, int epoch_count, int window_size);
    //nastav modelu bufferu, aby mohl ve vypoctu implementovat checkpointing - dotazovani se, zda neco neni na vstupu
    //metoda nemusi nutne existovat, model si muze vytvorit buffer v konstruktoru
    void Set_Buffer(Buffer* bfr);
    //vrat data v case t
    float* Get_Data_Samples();
    //hlavni smycka tasku, posloucha na vstup od uzivatele, dopisuje si s nim a predikuje hodnoty v t+t_pred
    void Run();

};

