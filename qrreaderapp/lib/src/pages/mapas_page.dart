import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/bloc/scans_bloc.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:qrreaderapp/src/utils/utils.dart' as utils;

class MapasPage extends StatefulWidget {
  final String tipo;
  MapasPage({@required this.tipo});
  @override
  _MapasPageState createState() => _MapasPageState();
}

class _MapasPageState extends State<MapasPage> {
  final scansBloc = new ScansBloc();
  String tempName;
  @override
  Widget build(BuildContext context) {
    scansBloc.obtenerScans();
    return StreamBuilder<List<ScanModel>>(
      stream: widget.tipo=="geo"?scansBloc.scansStream:scansBloc.scansStreamHttp,
      builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot){
        if(!snapshot.hasData){
          
          return Center(child: CircularProgressIndicator());
        }
        final scans = snapshot.data;
        if(scans.length==0)
        {
            return Center(child: Text("NO DATA"));
        }
        return ListView.builder(
          itemCount: scans.length,
          itemBuilder: (context, i) => Dismissible(
            key: UniqueKey(),
            background: Container(color: Colors.red),
            onDismissed: (direction){
              scansBloc.borrarScan(scans[i].id);
            },
            child: ListTile(
              onLongPress: ()=>_dialogName(context,scans[i]),
              leading: Icon( Icons.map, color: Theme.of(context).primaryColor),
              title: Text(scans[i].name==null?scans[i].valor:scans[i].name),
              subtitle: Text('ID: ${scans[i].id}'),
              trailing: IconButton(
                onPressed: ()=>utils.openScan(context,scans[i]),
                icon: Icon(Icons.arrow_forward),
                color: Theme.of(context).primaryColor,
              ),
             
            ),
          )
        );
      },
    );
  }

  Widget _crearInput() {
    return TextField(
      autofocus: true,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),

        hintText: "Nombre",
        labelText: "Dirección",
        helperText: "Nombre de la dirección",
        //suffixIcon: Icon(Icons.map),
        icon: Icon(Icons.map),
      ),
      onChanged: (valor)
      {
        tempName=valor;
      },
    );
  }

  void _dialogName(BuildContext context,ScanModel scan)
  {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context){
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),    
          title: Text("Cambiar Nombre"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _crearInput(),
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
               if(tempName.length>0)
                scan.name=tempName;
               tempName='';
               scansBloc.modificarScan(scan);
               return Navigator.of(context).pop();
             },
            ),  
          ],

        );
      }

    );
  }
}