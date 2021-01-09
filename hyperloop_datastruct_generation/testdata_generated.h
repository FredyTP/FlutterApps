#ifndef TESTDATA_GENERATED_H_
#define TESTDATA_GENERATED_H_
 
#pragma pack(1)
 
#include<stdint.h> 
 
struct jeje 
{
	float yata;
};

struct inside 
{
	uint8_t uint81;
	uint16_t uin161[4];
	struct jeje estano;
};

struct TestHL 
{
	float float1[2];
	int16_t int161;
	struct inside inside[2];
};


union TestHLunion{
	struct TestHL testdata;
	uint8_t buffer[36];
};