let array = new Uint8Array(-INSERTAR_ARRAY-);
let data=new DataView(array.buffer);

let DataStruct = new Map()
DataStruct.set("tapeerror",data.getUint8(0))
DataStruct.set("nkaosdhna",data.getInt8(0))
DataStruct.set("asdada",data.getInt8(1))
DataStruct.set("asddsad",data.getInt8(2))
