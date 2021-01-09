let array = new Uint8Array(-INSERTAR_ARRAY-);
let data=new DataView(array.buffer);

let testdata = new Map()
testdata.set("float1",[])
testdata.get("float1").push(data.getFloat32(0,true))
testdata.get("float1").push(data.getFloat32(4,true))
testdata.set("int161",data.getInt16(8,true))
testdata.set("inside",[])

let inside = new Map()
inside.set("uint81",data.getUint8(10))
inside.set("uin161",[])
inside.get("uin161").push(data.getUint16(11,true))
inside.get("uin161").push(data.getUint16(13,true))
inside.get("uin161").push(data.getUint16(15,true))
inside.get("uin161").push(data.getUint16(17,true))
inside.set("estano",0)

let estano = new Map()
estano.set("yata",data.getFloat32(19,true))
inside.set("estano",estano)
testdata.get("inside").push(inside)

inside = new Map()
inside.set("uint81",data.getUint8(23))
inside.set("uin161",[])
inside.get("uin161").push(data.getUint16(24,true))
inside.get("uin161").push(data.getUint16(26,true))
inside.get("uin161").push(data.getUint16(28,true))
inside.get("uin161").push(data.getUint16(30,true))
inside.set("estano",0)

estano = new Map()
estano.set("yata",data.getFloat32(32,true))
inside.set("estano",estano)
testdata.get("inside").push(inside)
