#ifndef SEND_BUFFER_GENERATED_H_
#define SEND_BUFFER_GENERATED_H_
 
#pragma pack(1)
 
#include<stdint.h> 
 
struct BaseDataStruct 
{
	uint8_t a.a1.minV;
	uint8_t a.a1.c3s;
	uint16_t td.p;
	uint8_t a.a1.t2;
	uint8_t a.a1.maxV;
	uint8_t a.a1.AVG;
};


union BaseDataStructunion{
	struct BaseDataStruct send_buffer;
	uint8_t buffer[7];
};
#endif //SEND_BUFFER_GENERATED_H_