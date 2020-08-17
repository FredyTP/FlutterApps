import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/models/producto_model.dart';

class HomePage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final server = Provider.ofServer(context);
    server.getProducts();
    return Scaffold(
      appBar: AppBar(
        title: Center(child :Text("Home Page"))
      ),
      body: _crearListadoStream(context),
      floatingActionButton: _crearBoton(context),
    );
  }

  _crearBoton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: ()=>Navigator.pushNamed(context, 'producto'),
    );

  }


  Widget _crearListadoStream(BuildContext context){
    final server = Provider.ofServer(context);
    return StreamBuilder(
      stream: server.stream ,
      builder: (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot)
      {
        if(snapshot.hasData)
        {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context , i){
              return _crearItem(context,snapshot.data[i]);
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );

  }
  /*Widget _crearListado() {
    return FutureBuilder(
      future: productProvider.cargarProductos(),
      builder: (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot)
      {
        if(snapshot.hasData)
        {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context , i){
              return _crearItem(context,snapshot.data[i]);
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }*/

  Widget _crearItem(BuildContext context, ProductoModel producto) {
    final server = Provider.ofServer(context);
    return Dismissible(
      key: UniqueKey(),
      background: Container(color: Colors.red),
      onDismissed: (direccion){
        server.removeProduct(producto.id);
        //productProvider.borrarProducto(producto.id);
      },
      child: Card(
        child: Column( 
          children: <Widget>[
            (producto.fotoUrl==null)
            ? Image(image: AssetImage('assets/no-image.png'))
            : FadeInImage(
              image: NetworkImage( producto.fotoUrl),
              placeholder: AssetImage('assets/jar-loading.gif'),
              height: 300,
              width: double.infinity,
            ),
            ListTile(
              title: Text("${producto.titulo} - ${producto.valor}"),
              subtitle: Text("${producto.id}"),
              onTap: () => Navigator.pushNamed(context, 'producto', arguments: producto),
            )
          ],
        ),
      )
    );
  }
}