#pragma once
#define STRING_INPUT 0
#define INT_INPUT 1
#define FLOAT_INPUT 2


void itoa(int input, char* output, unsigned int base);
int atoi(const char* input);
char* strncpy(char* dest, const char *src, int num);
int strncmp(const char *s1, const char *s2, int num);
int strlen(const char* s);
void bzero(void* memory, int length);
void memcpy(const void* src, void* dst, int num);
char* strcat(char* dest, const char* src);
char* strncat(char* dest, const char* src,int size);
void ftoa(float f, char r[]);
float atof(const char* input);
int get_input_type(const char* input);