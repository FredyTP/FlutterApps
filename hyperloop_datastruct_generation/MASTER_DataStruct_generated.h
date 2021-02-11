#ifndef DATASTRUCT_GENERATED_H_
#define DATASTRUCT_GENERATED_H_
 
#pragma pack(1)
 
#include<stdint.h> 
 
struct BaseDataStruct 
{
	float asdasd;
};


union BaseDataStructunion{
	struct BaseDataStruct datastruct;
	uint8_t buffer[4];
};
#endif //DATASTRUCT_GENERATED_H_