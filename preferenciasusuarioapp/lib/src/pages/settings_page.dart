import 'package:flutter/material.dart';
import 'package:preferenciasusuarioapp/src/share_prefs/preferencias_usuario.dart';
import 'package:preferenciasusuarioapp/src/widgets/menu_widget.dart';

class SettingsPage extends StatefulWidget {

  static final String routeName='settings';

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _colorSecundario;
  int _genero;
  String _nombre;
  TextEditingController _textController;

  final prefs = new PreferenciasUsuario();



  @override
  void initState() {
    super.initState();
    
    _genero = prefs.genero;
    _colorSecundario=prefs.colorSecundario;
    _nombre=prefs.nombreUsuario;
    prefs.lastPage=SettingsPage.routeName;
    _textController=new TextEditingController(text: _nombre);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Preferencias de Usuario"),
        backgroundColor: prefs.colorSecundario ? Colors.teal : Colors.blue,

      ),
      drawer: MenuWidget(),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(5.0),
            child: Text("Settings", style: TextStyle(fontSize: 45.0),)
          ),
          Divider(),
          SwitchListTile(
            value: _colorSecundario,
            title: Text('Color secundario'),
            onChanged: (value){
              prefs.colorSecundario=value;
              _colorSecundario=value;
              setState(() {});
            },
          ),
          RadioListTile(
            value: 1,
            title: Text("Masculino"),
            groupValue: _genero,
            onChanged: _setSelectedRadio,
          ),
          RadioListTile(
            value: 2,
            title: Text("Femenino"),
            groupValue: _genero,
            onChanged: _setSelectedRadio
          ),
          Divider(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: "Nombre",
                helperText: "Nombre de la persona",
              ),
              onChanged: (value){
                prefs.nombreUsuario=value;

              },
            )
          )
        ],
      )
    );
  }
  _setSelectedRadio(int valor){
    prefs.genero=valor;
    _genero=valor;
    setState(() {});
  }



}