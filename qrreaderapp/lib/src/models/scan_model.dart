import 'package:latlong/latlong.dart';

class ScanModel {
    int id;
    String tipo;
    String valor;
    String name='null';

    ScanModel({
        this.id,
        this.tipo,
        this.valor,
        this.name,
    }){
      if(this.valor.contains('http'))
      {
        this.tipo='http';
      }
      else
      {
        this.tipo='geo';
      }
    }

    factory ScanModel.fromJson(Map<String, dynamic> json) => ScanModel(
        id: json["id"],
        tipo: json["tipo"],
        valor: json["valor"],
        name: json["name"],
    );
    Map<String, dynamic> toJson() => {
        "id": id,
        "tipo": tipo,
        "valor": valor,
        "name": name,
    };
    factory ScanModel.fromInputGeo(InputGeo inp)=>ScanModel(
      tipo: "geo",
      valor: "geo:"+inp.lat.toString()+','+ inp.long.toString(),
      name: inp.name
    );

    getLatLng(){
      final lalo = valor.substring(4).split(',');
      final lat = double.parse(lalo[0]);
      final lng = double.parse(lalo[1]);

      return LatLng(lat,lng);
    }
}

class InputGeo{
  String name;
  double lat;
  double long;
  clear()
  {
    name=null;
    lat=null;
    long=null;
  }
  bool isValid()
  {
    return name!=null && lat!=null && long!=null;
  }
}
