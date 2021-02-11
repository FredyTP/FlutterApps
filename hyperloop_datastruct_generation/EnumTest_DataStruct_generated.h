#ifndef DATASTRUCT_GENERATED_H_
#define DATASTRUCT_GENERATED_H_
 
#pragma pack(1)
 
#include<stdint.h> 
 
struct BaseDataStruct 
{
	enum error_type tapeerror;
	int8_t nkaosdhna;
	int8_t asdada;
	int8_t asddsad;
};


union BaseDataStructunion{
	struct BaseDataStruct datastruct;
	uint8_t buffer[3];
};
#endif //DATASTRUCT_GENERATED_H_