import 'dart:io';

import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/models/producto_model.dart';
import 'package:formvalidation/src/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';


class ProductoPage extends StatefulWidget {

  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  ProductoModel product = new ProductoModel();
  bool subiendo=false;
  File foto;


  @override
  Widget build(BuildContext context) {
    final ProductoModel prodData = ModalRoute.of(context).settings.arguments;
    if(prodData!=null){
      product=prodData;
    }
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Producto'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo),
            onPressed: ()=> _procesarFoto(ImageSource.gallery),
          ),
          IconButton(
           icon: Icon(Icons.camera_alt),
           onPressed: ()=> _procesarFoto(ImageSource.camera),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _mostrarFoto(),
                _crearNombre(),
                _crearPrecio(),
                _crearDisponible(),
                _crearBoton(context),
              ],
            ),
          ),

        ),
      ),
    );
  }

  Widget _crearNombre() {
    return TextFormField(
      initialValue: product.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Producto'
      ),
      onSaved: (value)=> product.titulo=value,
      validator: (value){
        //si hay error retorna string, si no null
        if( value.length<3){
          return 'Ingrese el nombre del producto';
        }
        return null;
      },
    );
  }

  _crearPrecio() {
    return TextFormField(
      initialValue: product.valor.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal:true),
      decoration: InputDecoration(
        labelText: 'Precio'
      ),
      onSaved: (value) => product.valor=double.parse(value),
      validator: (value){
        if(utils.validarPrecio(value))
        {    
          return null;
        }
        else return "Ingrese un precio válido";
      },
    );
  }

  Widget _crearBoton(BuildContext context){
    return RaisedButton.icon(
      label: Text('Guardar'),
      icon: Icon(Icons.save),
      textColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      color: Colors.deepPurple,
      onPressed: subiendo ? null : ()=>_submit(context),

    );
  }

  void _submit(BuildContext context) async {
    subiendo=true;
    mostrarSnackbar(ListTile(
      leading: CircularProgressIndicator(),
      title: Text("Loading..."),
    ));
    setState(() {
      
    });
    final server = Provider.ofServer(context);
    
    if(!formKey.currentState.validate()) return;
    formKey.currentState.save();
    print("TODO OK");

    print(product.titulo);
    print(product.valor);
    print(product.disponible);
 

    if(foto!=null)
    {
      product.fotoUrl = await server.uploadImg(foto);
      //product.fotoUrl = await productoProvider.subirImagen(foto);
    }

    if(product.id==null)
    {
      server.addProduct(product);
      //productoProvider.crearProducto(product);
    }
    else {
      server.updateProduct(product);
      //productoProvider.editarProducto(product);
    }

    //mostrarSnackbar("Registro guardado");
    Navigator.pop(context);
  }

  Widget _crearDisponible() {
    return SwitchListTile(
      value: product.disponible,
      title: Text("Disponible"),
      onChanged: (value) => setState((){
        product.disponible=value;
      }),
      activeColor: Colors.deepPurple,
    );

  }

  void mostrarSnackbar(Widget content)
  {
    final snackbar = SnackBar(
      content: content,
      duration: Duration(days: 1),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  _mostrarFoto() {
 
    if (product.fotoUrl != null) {
 
      return FadeInImage(
        image: NetworkImage( product.fotoUrl),
        placeholder: AssetImage('assets/jar-loading.gif'),
        height: 300,
        fit: BoxFit.contain,
      );
 
    } else {
 
      if( foto != null ){
        return Image.file(
          foto,
          fit: BoxFit.cover,
          height: 300.0,
        );
      }
      return Image.asset('assets/no-image.png');
    }
  }

  _procesarFoto(ImageSource origen) async {
    subiendo=true;
    setState(() {
      
    });
    foto = await ImagePicker.pickImage(
      source: origen,
    );

    if( foto != null )
    {
      product.fotoUrl=null;
    }
    subiendo=false;
    setState(() {
      
    });
    

  }
}