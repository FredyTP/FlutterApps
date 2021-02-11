#ifndef DATASTRUCT_GENERATED_H_
#define DATASTRUCT_GENERATED_H_
 
#pragma pack(1)
 
#include<stdint.h> 
 
struct wdasd 
{
};

struct asd 
{
	struct wdasd 21eqw;
};

struct tes1 
{
	struct asd asdadw;
};

struct BaseDataStruct 
{
	float sda;
	struct tes1 dasda;
};


union BaseDataStructunion{
	struct BaseDataStruct datastruct;
	uint8_t buffer[4];
};
#endif //DATASTRUCT_GENERATED_H_