#pragma once
//linearni kongr pro generovani intu a uniformni rozdeleni pro generovani floatu
class Random_Generator{
private:
    int a;
    int c;
    int min;
    int max;
    int seed;

    int generated_count;
    int previously_generated = 0;
public:
    //min max interval pro generovani
    // a c m parametry pro linearni kongruentni generator
    Random_Generator(int min, int max, int a,int c, int seed);
    int Get_Int();
    //vygeneruj int a vydel ho maxem
    float Get_Float();



};