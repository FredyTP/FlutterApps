#ifndef DATASTRUCT_GENERATED_H_
#define DATASTRUCT_GENERATED_H_
 
#pragma pack(1)
 
#include<stdint.h> 
 
struct BMSAData 
{
	uint8_t batteryVoltage[2];
	float totalVoltage;
};

struct HyperLoopData 
{
	struct BMSAData bmsa_info[2];
};


union HyperLoopDataunion{
	struct HyperLoopData datastruct;
	uint8_t buffer[12];
};