#include <stdstring.h>

namespace
{
    const char CharConvArr[] = "0123456789ABCDEF";
}

void itoa(int input, char* output, unsigned int base)
{
    int i = 0;
    int j = 0;

	while (input > 0)
	{
		output[i] = CharConvArr[input % base];
		input /= base;
		i++;
	}

    if (i == 0)
    {
        output[i] = CharConvArr[0];
        i++;
    }

	output[i] = '\0';
	i--;

	for (j; j <= i/2; j++)
	{
		char c = output[i - j];
		output[i - j] = output[j];
		output[j] = c;
	}

}

int atoi(const char* input)
{
    if(strlen(input) == 1)
        return *input - '0';
	int output = 0;

	while (*input != '\0')
	{
		output *= 10;
		if (*input > '9' || *input < '0')
			break;

		output += *input - '0';

		input++;
	}

	return output;
}
//return 1 pokud int
//return 2 pokud float
//return 0 pokud neni cislo
int get_input_type(const char * input){
    //existence tecky
    bool dot = false;
    bool trailing_dot = false;
    while(*input != '\0'){
        char c = *input;
        if(c == '.' && !dot){
            dot = true;
            trailing_dot = true;
            input++;
            continue;
        }
        //nenumericky znak
        if(c < '0' || c > '9')return 0;
        //retezec obsahuje tecku a numericke znaky -> tecka je "validni", tedy neni to tecka na konci intu napriklad
        if(dot)
            trailing_dot = false;
    input++;
    }
    if(trailing_dot)return 0;
    //float pokud retezec obsahuje non-trailing tecku, 1 pokud je to int
    return dot? 2:1;

}


//string to float
float atof(const char* input){
    double output = 0.0;
    double factor = 10;
    //cast za desetinnou carkou
    double tmp = 0.0;
    int counter = 0;
    int scale = 1;
    bool afterDecPoint = false;

    while(*input != '\0'){
        if (*input == '.'){
            afterDecPoint = true;
            input++;
            continue;
        }
        else if (*input > '9' || *input < '0')break;
        double val = *input - '0';
        if(afterDecPoint){
            scale /= 10;
            output = output + val * scale;
        }
        else
            output = output * 10 + val;

        input++;
    }
    return output;
}
char* strncpy(char* dest, const char *src, int num)
{
	int i;

	for (i = 0; i < num && src[i] != '\0'; i++)
		dest[i] = src[i];
	for (; i < num; i++)
		dest[i] = '\0';

   return dest;
}

int strncmp(const char *s1, const char *s2, int num)
{
	unsigned char u1, u2;
  	while (num-- > 0)
    {
      	u1 = (unsigned char) *s1++;
     	u2 = (unsigned char) *s2++;
      	if (u1 != u2)
        	return u1 - u2;
      	if (u1 == '\0')
        	return 0;
    }

  	return 0;
}

int strlen(const char* s)
{
	int i = 0;

	while (s[i] != '\0')
		i++;

	return i;
}
//unsafe varianta
//muze nastat buffer overflow attack
char* strcat(char* dest, const char* src){
    int n = strlen(src);
    int m = strlen(dest);
    int walker = 0;
    for(int i = 0;i < n; i++)
        dest[m++] = src[i];
    dest[m] = '\0';
    return dest;

}
char* strncat(char* dest, const char* src,int size){
    int walker = 0;
    //najdi odkud muzeme kopirovat, tedy konec retezce
    int m = strlen(dest);
    //nevejdu se
    if(m >= size)return dest;

    for(int i = 0;i < size; i++){
        if(src[i] == '\0')break;
        dest[m++] = src[i];
    }
    dest[m] = '\0';
    return dest;

}


void bzero(void* memory, int length)
{
	char* mem = reinterpret_cast<char*>(memory);

	for (int i = 0; i < length; i++)
		mem[i] = 0;
}

void memcpy(const void* src, void* dst, int num)
{
	const char* memsrc = reinterpret_cast<const char*>(src);
	char* memdst = reinterpret_cast<char*>(dst);

	for (int i = 0; i < num; i++)
		memdst[i] = memsrc[i];
}



int n_tu(int number, int count)
{
    int result = 1;
    while(count-- > 0)
        result *= number;

    return result;
}

/*** Convert float to string ***/
void ftoa(float f, char r[])
{
    long long int length, length2, i, number, position, sign;
    float number2;

    sign = -1;   // -1 == positive number
    if (f < 0)
    {
        sign = '-';
        f *= -1;
    }

    number2 = f;
    number = f;
    length = 0;  // Size of decimal part
    length2 = 0; // Size of tenth

    /* Calculate length2 tenth part */
    while( (number2 - (float)number) != 0.0 && !((number2 - (float)number) < 0.0) )
    {
        number2 = f * (n_tu(10.0, length2 + 1));
        number = number2;

        length2++;
    }

    /* Calculate length decimal part */
    for (length = (f > 1) ? 0 : 1; f > 1; length++)
        f /= 10;

    position = length;
    length = length + 1 + length2;
    number = number2;
    if (sign == '-')
    {
        length++;
        position++;
    }

    for (i = length; i >= 0 ; i--)
    {
        if (i == (length))
            r[i] = '\0';
        else if(i == (position))
            r[i] = '.';
        else if(sign == '-' && i == 0)
            r[i] = '-';
        else
        {
            r[i] = (number % 10) + '0';
            number /=10;
        }
    }
}



