#include <Sort.h>


int split(Tribesman** tribesman,  int left,  int right){
    Tribesman* pivot = tribesman[right];
    while(1){
        //dokud je left pointer mensi jak right a prvky jsou mensi jak pivot, tak se hybej
        while((left < right) && (tribesman[left]->fitness < pivot->fitness))
                left++;
        //nasel jsem misto na swap, hod left na right
        if(left<right){
            tribesman[right] = tribesman[left];
            right--;
        }else //v teto casti pole uz nemuzu nic vymenit
            break;
        //logika stejna, jenom hybu right pointerem, ne left pointerem
        while((left < right) && (tribesman[right]->fitness > pivot->fitness))
            right--;
        if(left<right){
            tribesman[left] = tribesman[right];
            left++;
        }else break;
    }
    //na left bude dira pro pivotni prvek
    tribesman[left] = pivot;
    //vrat split index
    return left;

}

//serad borce podle jejich fitness
void sort(Tribesman** tribesman,  int start,  int end){
    if(start >= end)return;
    //misto, kde se nam pole rozpadne na dve "podpole", ktere se budou radit
    int index = split(tribesman,start,end);
    //vime, ze pivotni prvek uz je na spravnem miste, tedy vsechny prvky index-1 jsou mensi a index+1 jsou vetsi
    //nebudu jej proto uz kontrolovat
    sort(tribesman,start,index - 1);
    sort(tribesman,index+1,end);
}

//jakysi qsort pro serazeni
//prepis do nerekurzivni verze vhodny pro RTOS
void Sort_Tribesman(Tribesman** tribesman,  int len){
    sort(tribesman,0,len-1);
}