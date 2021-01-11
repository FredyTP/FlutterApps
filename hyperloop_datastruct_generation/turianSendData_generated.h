#ifndef TURIANSENDDATA_GENERATED_H_
#define TURIANSENDDATA_GENERATED_H_
 
#pragma pack(1)
 
#include<stdint.h> 
 
struct Imu2Data 
{
	int16_t gyrX;
	int16_t gyrY;
	int16_t gyrZ;
	int16_t accelX;
	int16_t accelY;
	int16_t accelZ;
};

struct TapesData 
{
	int16_t globalTapeCount;
	int8_t direction;
	uint32_t tapeErrors;
};

struct NavigationData 
{
	struct Imu2Data imu2Data;
	struct TapesData tapesData;
};

struct TurianDataStruct 
{
	struct NavigationData navigationData;
};


union TurianDataStructunion{
	struct TurianDataStruct turiansenddata;
	uint8_t buffer[19];
};
#endif //TURIANSENDDATA_GENERATED_H_