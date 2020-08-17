import 'package:flutter/material.dart';
import 'package:discoduroupv/bloc/login_bloc.dart';
import 'package:discoduroupv/bloc/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _crearFondo(context),
          _loginForm(context),
        ],
      )
    );
  }

  Widget _crearFondo(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final fondoMorado = Container(
      height: size.height*0.4,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(63, 63, 156, 1.0),
            Color.fromRGBO(90, 70, 178, 1.0)
          ]
        )
      ),
    );

    final circulo=Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Color.fromRGBO(250, 250, 250, 0.05),
      ),
    );

    return Stack(
      children: <Widget>[
        fondoMorado,
        Positioned(child: circulo, top: 90.0, left: 30.0),
        Positioned(child: circulo, top: -40.0, right: 30.0),
        Positioned(child: circulo, bottom: -50.0, right: -10.0),
        Positioned(child: circulo, bottom: 190.0, right: 50.0),
        Container(
          padding: EdgeInsets.only(top: 70.0),
          child: Column(
            children: <Widget>[
              Icon(Icons.memory,color: Colors.white, size: 75),
              SizedBox(height: 10.0,width: double.infinity),
              Text("UPV - W", style: TextStyle(color: Colors.white, fontSize: 35.0)),
              SizedBox(height: 10.0,width: double.infinity),
              Text("by Alfredo Torres", style: TextStyle(color: Colors.white, fontSize: 15.0))
            ],
          ),
        )
      ],
    );
  }

  Widget _loginForm(BuildContext context) {

    final bloc = Provider.of(context);
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SafeArea(child: Container(height: 190.0)), 
          Container(
            width: size.width*0.85,
            margin: EdgeInsets.symmetric(vertical: 30.0),
            padding: EdgeInsets.symmetric(vertical: 50.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 3.0,
                  offset: Offset(0.0,5.0),
                  spreadRadius: 3.0
                )
              ],
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Column(
              children: <Widget>[
                Text("Inicio sesión disco duro UPV"),
                SizedBox(height: 60.0),
                _crearEmail(bloc),
                SizedBox(height: 30.0),
                _crearPassword(bloc),
                SizedBox(height: 30.0),
                _crearBoton(context,bloc),
              ],
            ),
          ),
          Text('¿Olvidó la contraseña?'),
          SizedBox( height: 100.0 )
        ],
      )
    );
  }

  Widget _crearEmail(LoginBloc bloc){

    return StreamBuilder(
      stream: bloc.emailStream ,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              icon: Icon( Icons.person, color: Colors.deepPurple),
              hintText: "ex: magarmo",
              labelText: "Nombre de usuario",
              counterText: snapshot.data,
              errorText: snapshot.error,
            ),
            onChanged: ( value ) => bloc.changeEmail(value),
          )
        );
      }
    );  
  }
    Widget _crearPassword(LoginBloc bloc){
    return StreamBuilder(
      stream: bloc.passwordStream ,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            keyboardType: TextInputType.text,
            obscureText: true,
            decoration: InputDecoration(
              icon: Icon( Icons.lock_outline, color: Colors.deepPurple),
              labelText: "Contraseña",
              counterText: snapshot.data!=null ? "Contraseña Válida" : null,
              errorText: snapshot.error,
            ),
            onChanged: bloc.changePassword
          )
        );
      },
    );
    
  }

  Widget _crearBoton(BuildContext context, LoginBloc bloc)
  {
    return StreamBuilder(
      stream:  bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return RaisedButton(
          child: Container(
            child: Text('Ingresar'),
            padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0)
          ),
          color: Colors.deepPurple,
          textColor: Colors.white,
          elevation: 1.0,
          onPressed: (snapshot.hasData && _activarBoton(bloc) || true) ? (){_login(context,bloc);} : null,

        );
      },
    );
    
  }
  bool _activarBoton(LoginBloc bloc)
  {
    final email=bloc.email.length>=3;
    final pw=bloc.password.length>=3;
    return email && pw;
  }
  _login(BuildContext context, LoginBloc bloc) async {
    final credentials = "${bloc.email}:${bloc.password}";

    final url='https://alumnos.upv.es/${bloc.email[0]}/${bloc.email}';
    
    String encoded = base64.encode(utf8.encode(credentials));
  
    final resp = await http.get( url, headers:{'Authorization':'Basic $encoded'} );
    
    print(resp.headers);
    print("STATUS CODE: ");
    print(resp.statusCode);


    if(resp.statusCode==200)
    {
      Navigator.pushReplacementNamed(context, 'home',arguments: {'body': resp.body,'header': {'Authorization':'Basic $encoded'}});
    }
    
  }

}