


let array = new Uint8Array([1,2,0,0,64,64,3,4,0,0,224,64]);

let data=new DataView(array.buffer);


/////-----------------/////
let dataStruct = new Map();
dataStruct.set("bmsa_info",[]);

let bmsa_info= new Map();
bmsa_info.set("batteryVoltage",[]);
bmsa_info.get("batteryVoltage").push(data.getUint8(0));
bmsa_info.get("batteryVoltage").push(data.getUint8(1));
bmsa_info.set("totalVoltage",data.getFloat32(2,true));

dataStruct.get("bmsa_info").push(bmsa_info);

bmsa_info = new Map();
bmsa_info.set("batteryVoltage",[]);
bmsa_info.get("batteryVoltage").push(data.getUint8(6));
bmsa_info.get("batteryVoltage").push(data.getUint8(7));
bmsa_info.set("totalVoltage",data.getFloat32(8,true));

dataStruct.get("bmsa_info").push(bmsa_info);

console.log(dataStruct.get("bmsa_info")[1].get("totalVoltage"));