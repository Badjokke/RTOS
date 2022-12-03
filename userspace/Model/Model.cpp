#include <Model.h>

Model::Model(int t_delta, int t_pred,int population_count, int epoch_count, int window_size,Buffer* bfr):
t_delta(t_delta),
t_pred(t_pred),
population_count(population_count),
epoch_count(epoch_count),
window_size(window_size),
bfr(bfr)
{
    //alokuj pamet na halde po struktury, ktere potrebuji
    Init();
    data_pointer = 0;
};

float Model::Calc_B(float D, float E, float y){
    return ((D / E) * derivative_value) + ((1.0/E) * y);
}


//parameters - parametry clena populace, y - hodnota v case t
//vysledek je hodnota v case t+t_pred
float Model::Calculate_Prediction(float* parameters, float y){
    float A = parameters[0];
    float B = parameters[1];
    float C = parameters[2];
    float D = parameters[3];
    float E = parameters[4];

    float b_t = Calc_B(D,E,y);
    float y_predicted = (A * b_t) + ((B * b_t) * (b_t - y)) + C;
    return y_predicted;
}


//predikce od borce
void Model::Predict(Tribesman* tribesman){
    //pro vsechna data, ktera mam udelej predikci
    //tedy pro vsechna y(t) vypocti y(t+t_pred)
    for(int i = 0; i < data_pointer; i++){
        float prediction = Calculate_Prediction(tribesman->parameters,this->data[i]);
        tribesman->predicted_values[i] = prediction;
    }
}
//vypocitnej fitness clena populace
//cim vyssi fitness, tim hur na tom
//fitness funkce je prumerna vzdalenost predikce od spravne hodnoty
float Model::Calculate_Fitness(Tribesman* tribesman){
    //predikovana hodnota na indexu i ve skutecnych datech lezi na indexu i + time_shift
    int time_shift = t_pred / t_delta;
    float fitness = 0;
    float diff = 0;
    int i;

    for(i = 0; i < window_size; i++){
        float y_predicted = tribesman->predicted_values[i];
        int index = i + time_shift;
        //data od tohoto bodu jeste nemame k dispozici -> nemuzeme je pouzit pro fitness funkci
        //nebo nemame nic napocitano
        if(index >= data_pointer)break;
        float y = this->data[index];
        //pricti rozdil ctvercu
        //diff += y_predicted - y;
        diff += (y_predicted*y_predicted) - 2 * (y_predicted*y) + (y*y);
    }
    //zajima nas absolutni chyba
    if(diff < 0)
        diff = -diff;
    //aritmeticky prumer
    //pokud jej mame z ceho vypocitat
    //pokud nemame, vrat empty -> nemam dost dat na to, abych vyhodnotil spravnost clena populace
    if(i == 0 ) return EMPTY;
    //aritmeticky prumer sumy rozdilu actual_y - predicted_y
    fitness = (float)diff / i;
    return fitness;
}


//inicializace hodnot tribesmanu
//tedy randomizace parametru A,B,C,D,E
void Model::First_Generation(){
    for(int i = 0; i < population_count; i++){
        Tribesman* tribesman = this->population[i];
        //randomizuj parametry
        for(int j = 0; j < PARAMETER_COUNT; j++){
            tribesman->parameters[j] = this->random->Get_Float();

        }
        //nic jeste neni predikovano
        for(int j = 0; j < window_size; j++)
            tribesman->predicted_values[j] = EMPTY;
    }
}
//prekopiruj @param t do @param this->alpha
//na konci epochy ulozime nejlepsiho z generace
void Model::Set_Alpha(Tribesman* t){
    for(int i = 0; i < PARAMETER_COUNT; i++)
        this->alpha->parameters[i] = t->parameters[i];
    for(int i = 0; i < window_size; i++)
        this->alpha->predicted_values[i] = t->predicted_values[i];
    this->alpha->fitness = t->fitness;
}
//vypise parametry nejlepsiho
//tedy @attribute Alpha clena populace
void Model::Print_Parameters(){
    //nejaky dostatecny velky buffer pro nase potreby
    char temp_buffer[128] = {0};
    char params[PARAMETER_COUNT][PARAMETER_COUNT] = {"A = ","B = ","C = ","D = ", "E = "};
    char temp_float_buffer[10] = {0};
    Tribesman* tmp = this->alpha;

    for(int i = 0; i < PARAMETER_COUNT; i++){
        float f = tmp->parameters[i];
        ftoa(f,temp_float_buffer);
        strncat(temp_buffer,params[i],128);
        strncat(temp_buffer,temp_float_buffer,128);
        if(i != PARAMETER_COUNT - 1)
            strcat(temp_buffer,", ");
    }
    this->bfr->Write_Line(temp_buffer);
    this->bfr->Write_Line("\n");


}
// inicializuj populaci
void Model::Init() {

    this->population = reinterpret_cast<Tribesman**>(malloc(sizeof(Tribesman*) * population_count));

    for(int i = 0; i < population_count;i++){
        this->population[i] = new Tribesman;//reinterpret_cast<Tribesman*>(malloc(sizeof(Tribesman)));
        //struktura pro predikovane hodnoty
        this->population[i]->predicted_values = new float[window_size];
        //vynuluj hodnoty - aby tam nebyl pripadne nejaky bordylek
        //bss sekce je vynulovana, takze by tam nemel byt nejaky svinec
        //ale pro pripad, ze tam svinec je, tak nechceme, aby umrel task na neco hloupeho
        for(int j = 0; j < window_size; j++)
            this->population[i]->predicted_values[j] =  0;

    }

    this->data = new float[window_size];
    //*1000 abych to mohl rozumne prevadet na floaty

    this->random = new Random_Generator(min_parameter_value * 1000, max_parameter_value * 1000, 4, 1, 42);

    //init nejlepsiho z generace
    this->alpha = new Tribesman;
    this->alpha->predicted_values = new float[window_size];
    for(int j = 0; j < window_size; j++)
        this->alpha->predicted_values[j] = 0;

    First_Generation();

}
bool Model::Is_Data_Window_Full(){
    return data_pointer == window_size;
}

bool Model::Add_Data_Sample(float y){
    if(Is_Data_Window_Full()){
        return false;
    }
    this->data[data_pointer++] = y;
    return true;
}

void Model::Set_Buffer(Buffer* bfr){
    this->bfr = bfr;
}

float* Model::Get_Data_Samples(){
    return this->data;
}
//20% smetanky populace prezije, zbytek je nahrazen krizenim, tedy ppst krizeni = 0.2
void Model::Gene_Pool_Party(Tribesman** population){
    // stanovime hranici krizeni
    int cross_boundary = this->random->Get_Int() % PARAMETER_COUNT;
    //dedime z leveho rodice nebo praveho
    bool left_parent = this->random->Get_Int() % 2 == 0;
    //odtud zacinam nahrazovat
    //tedy <start> clenu populace zustane
    //z nich vznikne start / 2 novych clenu krizenim
    int start = this->population_count * 0.2;
    //tolik potrebujeme vytvorit novych clenu populace
    int new_pop_count = population_count - start;
    //vytvor deti z top 20 % clenu populace
    int pointer = 0;

    //od start po party_stop se budou vznikat potomci krizenim
    int party_stop = start + start / 2;
    //cleny populace do indexu start ponecham
    for(start; start < party_stop ;start++){
        Tribesman* l_parent = population[pointer];
        Tribesman* r_parent = population[pointer + 1];

        for(int i = 0; i < cross_boundary; i++)
            population[start]->parameters[i] = left_parent? l_parent->parameters[i] : r_parent->parameters[i];
        for(int j = cross_boundary; j < PARAMETER_COUNT; j++)
            population[start]->parameters[j] = this->random->Get_Float();
        pointer += 2;
    }
    //vytvor random nove cleny populace
    for(start; start < new_pop_count; start++){
        Tribesman* new_tribesman = population[start];
        //vytvor "nove" cleny populace
        for(int i = 0; i < PARAMETER_COUNT; i++)
            new_tribesman->parameters[i] = random->Get_Float();

    }


}
void Model::Eval_String_Command(const char *str){
    if(!strncmp("parameters",str,strlen("parameters"))){
        Print_Parameters();
        Prompt_User();
        return;
    }
    else if(!strncmp("stop",str,strlen("stop"))){
        this->bfr->Write_Line("Zastavuji vypocet\n");
        is_fitting = false;
        return;
    }
    else
        this->bfr->Write_Line("Neznamy prikaz\n");
    Prompt_User();


}
void Model::Print_Alpha_Predictions(){
    Tribesman* t = alpha;
    char bfr2[20];
    for(int i = 0; i < data_pointer; i++){
        float f = t->predicted_values[i];
        ftoa(f,bfr2);
        this->bfr->Write_Line(bfr2);
        this->bfr->Write_Line("\n");

    }
};

void Model::Checkpoint(){
    char* line = this->bfr->Read_Uart_Line();
    //nic jsem neprecetl
    if(line == nullptr)return;
    //kouknu se, co jsem precetl
    int type = get_input_type(line);
    float f;
    int i;
    switch (type) {
        //nejaky prikaz od uzivatele
        case STRING_INPUT:
            Eval_String_Command(line);
            break;
        //data na vstupu
        case FLOAT_INPUT:
            f = atof(line);
            if(Add_Data_Sample(f))
               is_fitting = true;
            return;
        case INT_INPUT:
            i  = atoi(line);
            if(Add_Data_Sample(static_cast<float>(i)))
                is_fitting = true;
            return;
        default:
            bfr->Write_Line("Ocekavam kladne cislo \n");
            Prompt_User();
            break;
    }
}

void Model::Mutation(Tribesman** population){
    int parameter_to_mutate = random->Get_Int() % PARAMETER_COUNT;
    for(int i = 0; i < population_count; i++)
        population[i]->parameters[parameter_to_mutate] = random->Get_Float();

}
//vizualni pobidnuti uzivatele k zadani vstupu
void Model::Prompt_User(){
    this->bfr->Write_Line(">");
}

//main loop of the task
void Model::Run(){
    char float_buffer[20];
    //main loop of the program
    while(1){
        Prompt_User();
        //pokud nefitim, tak spim a dotazuju se, jestli neco neni na uartu
        while(!is_fitting){
            asm volatile("wfi");
            Checkpoint();
        }
        bool not_enough_data = false;
        bfr->Write_Line("Pocitam...\n");
        //let pres vsechny epochy
        for(int i = 0; i < epoch_count; i++){
            //kontroluji, jestli neprisel stop prikaz, pokud jo, zastavuji vypocet
            if(!is_fitting)break;
            for(int i = 0; i < population_count; i++){
                //predikuj
                Predict(population[i]);
                //ohodnot spravnost reseni
                float f = Calculate_Fitness(population[i]);
                if(f == EMPTY){
                    //jeste nemam dost dat pro ohodnoceni, utecu
                    bfr->Write_Line("NaN\n");
                    //nastavim priznak, ze nemam dost dat -> nema smysl cokoliv jineho delat
                    not_enough_data = true;
                    is_fitting = false;
                    break;
                }
                population[i]->fitness = f;
                Checkpoint();
            }
            if(not_enough_data)break;

        //serad od nejlepsich po nejhorsi
            Sort_Tribesman(population,population_count);
            //nejlepsiho aktualni populace nastav jako alpha samce

        Set_Alpha(population[0]);
            //minimalni chyba -- perfektne si to sedne
            //nebo je to dostatecne dobra aproximace
            //if(this->alpha->fitness == 0 || this->alpha->fitness < min_error)
              //  break;
            Checkpoint();
            //prekrizi nejsilnejsi

        Gene_Pool_Party(population);
            //mutace
        Mutation(population);
        Checkpoint();
        //spal nejake CPU cykly -> umyslne zpomaleni vypoctu pro test responzivity uart kanalu
        for(int i = 0; i < 0x88888 * 10;i++)
            ;
        }
        //pokud nemam data, neni co vypsat
        //pokud uzivatel zastavil vypocet, taky utec
        if(not_enough_data || !is_fitting)continue;
        //posledni predicted hodnota je odpoved na vstup od uzivatele
        //Print_Alpha_Predictions();
        float predicted_value = this->alpha->predicted_values[data_pointer - 1];
        ftoa(predicted_value,float_buffer);
        this->bfr->Write_Line(float_buffer);
        this->bfr->Write_Line("\n");
        float_buffer[0] = '\0';
        //dopocital jsem, nastavim vlajecku
        is_fitting = false;
    }

}