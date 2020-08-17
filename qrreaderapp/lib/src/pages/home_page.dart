

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/bloc/scans_bloc.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:qrreaderapp/src/utils/utils.dart' as utils;

import 'mapas_page.dart';

import 'package:barcode_scan/barcode_scan.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String currentPage="geo";
  final scansBloc = new ScansBloc();
  int currentIndex=0;
  InputGeo inputGeo = new InputGeo();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR Scanner"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: scansBloc.borrarScanTODOS,
          ),
          IconButton(
            icon: Icon(Icons.add_circle),
            onPressed: ()=>_addNewScan(),
          )
        ],
      ),
      body: _callPage(currentIndex),
      bottomNavigationBar: _createBotNavBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        onPressed: ()=>_scanQR(context),
        backgroundColor: Theme.of(context).primaryColor,
      ),
  
    );
  }
  _scanQR(BuildContext context) async{
    //https://fernando-herrera.com
    //geo:40.71590644448746,-73.89195814570316
    String futureString;
    
    try{
      futureString = await BarcodeScanner.scan();

    }catch(e)
    {
    }
    
    if(futureString!=null)
    {
      final scan = ScanModel(valor: futureString);
      scansBloc.agregarScan(scan);
      if(Platform.isIOS ){
        Future.delayed(Duration(milliseconds: 750),(){
          utils.openScan(context,scan);
        });
      }
      else{
        utils.openScan(context,scan);
      }
    }
  }
  Widget _createBotNavBar() {
  return BottomNavigationBar(
    currentIndex: currentIndex,
    onTap: (index){
      setState(() {
        currentIndex=index;
      });
    },
    items: [
      BottomNavigationBarItem(
        icon: Icon(Icons.map),
        title: Text('Mapas')
      ),      
        BottomNavigationBarItem(
        icon: Icon(Icons.brightness_5),
        title: Text('Direcciones')
      )
    ]
   );
  }
  Widget _callPage(int paginaActual)
  {
    switch( paginaActual)
    {
      case 0: currentPage="geo";
              return MapasPage(tipo:"geo");
      case 1: currentPage="http";
              return MapasPage(tipo:"http");

      default:
        currentPage="http";
        return MapasPage(tipo: "http");
    }
  }
  Widget _crearInput(String name) {
    return TextField(
      autofocus: true,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),

        hintText: name,
        labelText: name,
        //helperText: name,
        //suffixIcon: Icon(Icons.map),
        //icon: Icon(Icons.map),
      ),
      onChanged: (valor)
      {
        if(name=="Name")
        {
          inputGeo.name=valor;
        }
        else if(name=="Latitude")
        {
          inputGeo.lat=double.parse(valor);
        }
        else if(name=="Longitude")
        {
          inputGeo.long=double.parse(valor);
        }
        //tempName=valor;
      },
    );
  }
  _addNewScan()
  {
    if(currentPage=="geo")
    {
      inputGeo.clear();
      showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context){
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),    
          title: Text("Add Geolocation"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _crearInput("Name"),
              Divider(),
              _crearInput("Latitude"),
              Divider(),
              _crearInput("Longitude"),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancelar"),
              onPressed: ()=>Navigator.of(context).pop(),
            ),
            FlatButton(
              child: Text("Ok"),
             onPressed: ()
             {
               scansBloc.agregarScan(ScanModel.fromInputGeo(inputGeo));
               if(inputGeo.isValid())
               {
                 print("valid");
                 
               }
               else
                print("no valid");
               return Navigator.of(context).pop();
             },
            ),  
          ],

        );
      }

    );
    }
    else
    {

    }

  }

}




