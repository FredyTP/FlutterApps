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

struct NaviAmbient 
{
	int8_t bmp280Temperature;
	uint32_t bmp280Pressure;
};

struct NavigationData 
{
	struct Imu2Data imu2Data;
	struct TapesData tapesData;
	float dist_run;
	float speed;
	struct NaviAmbient naviAmbient;
};

struct BMSHBattery 
{
	uint8_t temperature;
};

struct BMSHData 
{
	struct BMSHBattery bmshBattery[5];
	uint8_t extra_temperature_sensor;
	float output_current;
	float output_total_voltage;
	float min_voltage;
	float max_voltage;
};

struct BMSA_cell 
{
	uint16_t charge;
	uint16_t voltage;
};

struct BMSAData 
{
	struct BMSA_cell cell[4];
	uint8_t current;
	uint8_t temperature[2];
	uint16_t voltage_max;
	uint16_t voltage_min;
	uint8_t voltage_GBL_state;
};

struct BrakesData 
{
	float high_press1;
	float high_press2;
	float mid_press;
	float low_press;
	int8_t temp0;
	int8_t temp1;
	int8_t temp2;
	int8_t temp3;
	uint8_t pos_acts;
	uint8_t solenoid_state;
};

struct TurianStatus 
{
	uint8_t mosfet;
	uint32_t timeStamp;
};

struct MotorData 
{
	float motorC[12];
	float motorV[12];
};

struct TurianDataStruct 
{
	struct NavigationData navigationData;
	struct BMSHData bmshData[12];
	struct BMSAData bmsaData[2];
	struct BrakesData brakesData;
	struct TurianStatus turian;
	struct MotorData motorStatatus;
};


union TurianDataStructunion{
	struct TurianDataStruct turiansenddata;
	uint8_t buffer[467];
};
#endif //TURIANSENDDATA_GENERATED_H_