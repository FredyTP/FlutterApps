let array = new Uint8Array(-INSERTAR_ARRAY-);
let data=new DataView(array.buffer);

let DataStruct = new Map()
DataStruct.set("bmsa_info",[])

let bmsa_info = new Map()
bmsa_info.set("batteryVoltage",[])
bmsa_info.get("batteryVoltage").push(getUint8(0))
bmsa_info.get("batteryVoltage").push(getUint8(1))
bmsa_info.set("totalVoltage",getFloat32(2,true))
bmsa_info.set("insidevar",0)

let insidevar = new Map()
insidevar.set("floatin",getFloat32(6,true))
bmsa_info.set("insidevar",insidevar)
DataStruct.get("bmsa_info").push(bmsa_info)

bmsa_info = new Map()
bmsa_info.set("batteryVoltage",[])
bmsa_info.get("batteryVoltage").push(getUint8(10))
bmsa_info.get("batteryVoltage").push(getUint8(11))
bmsa_info.set("totalVoltage",getFloat32(12,true))
bmsa_info.set("insidevar",0)

insidevar = new Map()
insidevar.set("floatin",getFloat32(16,true))
bmsa_info.set("insidevar",insidevar)
DataStruct.get("bmsa_info").push(bmsa_info)
