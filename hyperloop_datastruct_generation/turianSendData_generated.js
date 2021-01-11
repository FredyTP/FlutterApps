let array = new Uint8Array(-INSERTAR_ARRAY-);
let data=new DataView(array.buffer);

let turianSendData = new Map()
turianSendData.set("navigationData",0)

let navigationData = new Map()
navigationData.set("imu2Data",0)

let imu2Data = new Map()
imu2Data.set("gyrX",data.getInt16(0,true))
imu2Data.set("gyrY",data.getInt16(2,true))
imu2Data.set("gyrZ",data.getInt16(4,true))
imu2Data.set("accelX",data.getInt16(6,true))
imu2Data.set("accelY",data.getInt16(8,true))
imu2Data.set("accelZ",data.getInt16(10,true))
navigationData.set("imu2Data",imu2Data)
navigationData.set("tapesData",0)

let tapesData = new Map()
tapesData.set("globalTapeCount",data.getInt16(12,true))
tapesData.set("direction",data.getInt8(14))
tapesData.set("tapeErrors",data.getUint32(15,true))
navigationData.set("tapesData",tapesData)
turianSendData.set("navigationData",navigationData)
