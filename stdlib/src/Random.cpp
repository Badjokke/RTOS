#include <Random.h>

//pseudorandom generator cisel pro nahodnodnost parametru populace
//neni uplne optimalni nebo idealni, ale pro demonstracni ucely snad ok
Random_Generator::Random_Generator(int min, int max, int a,int c, int seed):
        a(a),max(max),seed(seed), min(min), c(c)
{}

//TODO lepsi random engine
int Random_Generator::Get_Int(){
    if(previously_generated == 0)
        previously_generated = seed;
    int tmp = (a*previously_generated + c );
    int numero = tmp % max;


    previously_generated = numero;
    return numero;
}


//vrat float v intervalu <min,max>
float Random_Generator::Get_Float() {
    int rand = Get_Int();
    float rand_float = rand / 1000.0;
    return rand_float;
}