let array = new Uint8Array(-INSERTAR_ARRAY-);
let data=new DataView(array.buffer);

let send_buffer = new Map()
send_buffer.set("a.a1.minV",data.getUint8(0))
send_buffer.set("a.a1.c3s",data.getUint8(1))
send_buffer.set("td.p",data.getUint16(2,true))
send_buffer.set("a.a1.t2",data.getUint8(4))
send_buffer.set("a.a1.maxV",data.getUint8(5))
send_buffer.set("a.a1.AVG",data.getUint8(6))
