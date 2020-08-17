import 'package:flutter/material.dart';
import 'package:testfirebase/utils/forms/email_input.dart';
import 'package:testfirebase/utils/forms/password_input.dart';

class SignInPage extends StatefulWidget {
  final Function toggleForm;
  SignInPage({this.toggleForm});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  String password;
  String email;

  bool emailValid = false;
  bool passwordValid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        _crearFondo(context),
        _loginForm(context),
      ],
    ));
  }

  Widget _crearFondo(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final fondoMorado = Container(
      height: size.height * 0.45,
      width: double.infinity,
      decoration: BoxDecoration(gradient: LinearGradient(colors: [Color.fromRGBO(63, 63, 156, 1.0), Color.fromRGBO(90, 70, 178, 1.0)])),
    );

    final circulo = Container(
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
          padding: EdgeInsets.only(top: 60.0),
          child: Column(
            children: <Widget>[
              Icon(Icons.person_pin_circle, color: Colors.white, size: 70),
              SizedBox(height: 10.0, width: double.infinity),
              Text("Alfredo Torres", style: TextStyle(color: Colors.white, fontSize: 25.0)),
            ],
          ),
        )
      ],
    );
  }

  Widget _loginForm(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
        child: Column(
      children: <Widget>[
        SafeArea(child: Container(height: 190.0)),
        Container(
          width: size.width * 0.85,
          margin: EdgeInsets.symmetric(vertical: 30.0),
          padding: EdgeInsets.symmetric(vertical: 50.0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 3.0, offset: Offset(0.0, 5.0), spreadRadius: 3.0)],
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text("Crear Cuenta"),
                SizedBox(height: 60.0),
                _crearEmail(),
                SizedBox(height: 30.0),
                PasswordInput(
                  onValueChanged: (value, valid) {
                    password = value;
                    passwordValid = valid;
                  },
                ),
                SizedBox(height: 30.0),
                RaisedButton(
                  child: Text("Sign In"),
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                  color: Color.fromRGBO(90, 70, 178, 1.0),
                  textColor: Colors.white,
                  onPressed: () {
                    if (emailValid && passwordValid) {
                      print(email);
                      print(password);
                    }
                  },
                )

                //_crearBoton(context,bloc),
              ],
            ),
          ),
        ),
        FlatButton(child: Text("¿Ya tiene cuenta? Iniciar Sesión"), onPressed: () => widget.toggleForm()),
        SizedBox(height: 100.0)
      ],
    ));
  }

  Widget _crearEmail() {
    return EmailInput(
      errorMsg: "Yee Fica un email bo, botifarra",
      onValueChanged: (email, valid) {
        this.email = email;
        emailValid = valid;
      },
    );
  }
}
