import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:latlong/latlong.dart';
import 'dart:async';


class MapsPage extends StatefulWidget {

  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  final MapController map = new MapController();
  LatLng actpos=LatLng(0,0);
  Position pos=Position();
  String tipoMapa ='streets';
  StreamSubscription<Position> positionStream;

  @override
  void initState() {
    var geolocator = Geolocator();
    var locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);

    positionStream = geolocator.getPositionStream(locationOptions).listen(
    (Position position) {
      pos=position;
      actpos.latitude=position.latitude;
      actpos.longitude=position.longitude;
      setState(() {});
      print(position == null ? 'Unknown' : position.latitude.toString() + ', ' + position.longitude.toString());
    });

    super.initState();
  }
  @override
  void dispose() {
    positionStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ScanModel scan=ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Coordenadas QR'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: (){
              map.move(actpos, 15);
            },
          ),
          IconButton(
            icon: Icon(Icons.location_on),
            onPressed: (){
              map.move(scan.getLatLng(), 15);
            },
          )
        ],
      ),
      body: _createFlutterMap(context,scan),
      floatingActionButton: _crearBotonFlotante(context),
      );
  }
  Widget _crearBotonCoordenadas(BuildContext context,String name,LatLng coord,Icon icon)
  {
    return PopupMenuButton<String>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))
        ),
        color: Color.fromRGBO(80, 80, 80,0.9),
        elevation: 3.0,
        icon: icon,
        onSelected: (String result) { setState(() { tipoMapa = result; }); },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
           PopupMenuItem<String>(
            value: 'streets',
            child: ListTile(
              title: new Text("$name"+"\nLat: "+coord.latitude.toString()+"º\nLon: "+coord.longitude.toString()+"º",textScaleFactor: 1.3,style: TextStyle(color: Colors.white),),
            ),
          ),
        ],
      );
  }
  Widget _crearBotonFlotante(BuildContext context)
  {
    return Container(
      decoration: new BoxDecoration(
        color: Theme.of(context).primaryColor,
        shape: BoxShape.circle,
      ),
      child: PopupMenuButton<String>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))
        ),
        color: Color.fromRGBO(160, 160, 255,0.7),
        elevation: 3.0,
        icon: Icon(Icons.repeat),
        onSelected: (String result) { setState(() { tipoMapa = result; }); },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          const PopupMenuItem<String>(
            value: 'streets',
            child: ListTile(
              title: Text('Streets',textScaleFactor: 1.4),
              leading: Icon(Icons.streetview, color: Colors.red),
            ),
          ),
          const PopupMenuItem<String>(
            value: 'dark',
            child: ListTile(
              title: Text('Dark',textScaleFactor: 1.4),
              leading: Icon(Icons.brightness_3, color: Colors.red),
            )
          ),
          const PopupMenuItem<String>(
            value: 'light',
            child: ListTile(
              title: Text('Light',textScaleFactor: 1.4),
              leading: Icon(Icons.wb_sunny, color: Colors.red),
            )
          ),
          const PopupMenuItem<String>(
            value: 'outdoors',
            child: ListTile(
              title: Text('Outdoors',textScaleFactor: 1.4),
              leading: Icon(Icons.map, color: Colors.red),
            )
          ),
          const PopupMenuItem<String>(
            value: 'satellite',
            child: ListTile(
              title: Text('Satellite',textScaleFactor: 1.4),
              leading: Icon(Icons.landscape, color: Colors.red),
            )
          ),
        ],
      ),
    );
  }

  Widget _createFlutterMap(BuildContext context,ScanModel scan)
  {
    return FlutterMap(
      mapController: map,
      options: MapOptions(
        center: scan.getLatLng(),
        zoom: 15.0,
      ),
      layers: [
        _crearMapa(),
        _crearMarcadores(context,scan),
      ],
    );
  }

  _crearMapa()
  {
    return TileLayerOptions(
      urlTemplate: 'https://api.mapbox.com/v4/'
      '{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
      additionalOptions: {
        'accessToken' : 'pk.eyJ1IjoiYWxmcmVkb3RvcnJlZXMiLCJhIjoiY2s1cGt6OWdlMDBmejNscDJ3ZWdnYnUxNCJ9.6Ydv7FY8sjtEs79Eww_J2Q',
        'id': 'mapbox.'+'$tipoMapa',
        //streets, dark, light, outdoors, satellite
      }
    );
  }

  _crearMarcadores(BuildContext context, ScanModel scan){
    //
    return MarkerLayerOptions(
      markers: <Marker>[
        Marker(
          width: 100.0,
          height: 100.0,
          point: scan.getLatLng(),
          builder: ( context ) => Container(
            child: _crearBotonCoordenadas(context,scan.name,scan.getLatLng().round(),Icon(Icons.location_on,size: 45))
          ),
          
        ),
        Marker(
          width: 100.0,
          height: 100.0,
          point: actpos,
          builder: ( context ) => Container(       
            child: _crearBotonCoordenadas(context,"Position",actpos.round(),Icon(Icons.my_location,size: 35))
          ), 
        )

      ]

    );

  }
}