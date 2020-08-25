import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_state.dart';
import 'bloc/user/app_user_bloc.dart';

//This page is actually working but should contain more feedback
//And also add more input form to create a user like username etc...

class SignInPage extends StatefulWidget {
  SignInPage();

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String password;
  String email;
  bool blockButton = false;

  bool _isCreateForm = false;

  void _toggleForm() {
    setState(() {
      _isCreateForm = !_isCreateForm;
    });
  }

  final TextEditingController _textEditingController = TextEditingController();

  bool _firstTimeEmail = true;
  bool _firstTimePass = true;
  bool emailValid = false;
  bool passwordValid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
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
              Container(
                child: Image.asset(
                  "assets/gimnasio.png",
                  width: MediaQuery.of(context).size.width / 3.5,
                ),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width / 4),
                ),
              ),
              SizedBox(height: 10.0, width: double.infinity),
              Text("Gym Stats", style: TextStyle(color: Colors.white, fontSize: 25.0)),
            ],
          ),
        )
      ],
    );
  }

  Widget _loginForm(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bloc = AppStateContainer.of(context).blocProvider.appUserBloc;
    return SingleChildScrollView(
        child: Column(
      children: <Widget>[
        SafeArea(child: Container(height: 190.0)),
        Container(
          width: size.width * 0.85,
          margin: EdgeInsets.symmetric(vertical: 30.0),
          padding: EdgeInsets.symmetric(vertical: 50.0),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 3.0, offset: Offset(0.0, 5.0), spreadRadius: 3.0)],
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text(
                  _isCreateForm ? "Crear Cuenta" : "Iniciar Sesión",
                  style: Theme.of(context).textTheme.headline5,
                ),
                SizedBox(height: 60.0),
                _crearEmail(),
                SizedBox(height: 30.0),
                _crearPassword(),
                SizedBox(height: 30.0),
                RaisedButton(
                  child: Text(_isCreateForm ? "Crear" : "Iniciar Sesión"),
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                  color: Color.fromRGBO(90, 70, 178, 1.0),
                  textColor: Colors.white,
                  onPressed: blockButton
                      ? null
                      : () async {
                          _firstTimeEmail = false;
                          _firstTimePass = false;
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            _submitForm(bloc);
                          }
                        },
                )

                //_crearBoton(context,bloc),
              ],
            ),
          ),
        ),
        FlatButton(child: Text(_isCreateForm ? "¿Ya tiene cuenta? Iniciar Sesión" : "¿No tiene cuenta? Crear cuenta"), onPressed: _toggleForm),
        SizedBox(height: 100.0)
      ],
    ));
  }

  Widget _crearEmail() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: TextFormField(
          controller: _textEditingController,
          keyboardType: TextInputType.emailAddress,
          autovalidate: true,
          decoration: InputDecoration(
            icon: Icon(Icons.alternate_email, color: Colors.deepPurple),
            hintText: "ejemplo@correo.com",
            labelText: "Correo electrónico",
            //counterText: snapshot.data,
          ),
          onChanged: (value) => _firstTimeEmail = value.length == 0,
          validator: (value) {
            Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
            RegExp regExp = new RegExp(pattern);
            if (_firstTimeEmail) return null;

            if (regExp.hasMatch(value)) {
              return null;
            } else
              return "Introduce un Email Válido";
          },
          onSaved: (newValue) {
            email = newValue;
          },
        ));
  }

  Widget _crearPassword() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: TextFormField(
          keyboardType: TextInputType.text,
          obscureText: true,
          autovalidate: true,
          decoration: InputDecoration(
            icon: Icon(Icons.lock_outline, color: Colors.deepPurple),
            labelText: "Contraseña",
          ),
          onChanged: (value) => _firstTimePass = value.length == 0,
          validator: (value) {
            password = value;
            if (_firstTimePass) {
              return null;
            } else if (password.length > 7) {
              return null; //Password is OK
            } else
              return "La contraseña ha de tener mas de 6 caracteres";
          },
          onSaved: (newValue) {
            password = newValue;
          },
        ));
  }

  void _resetEmail() {
    email = "";
    _firstTimeEmail = false;
    _textEditingController.clear();
  }

  Future _createUser(AppUserBloc bloc) async {
    final result = await bloc.createUserEmailPassword(email: email, password: password);
    //if (result == null) _showSnackbar();
  }

  Future _loginUser(AppUserBloc bloc) async {
    final result = await bloc.logInEmailAndPassword(email: email, password: password);
    //if (result == null) _showSnackbar();
  }

  Future _submitForm(AppUserBloc bloc) async {
    if (_isCreateForm)
      await _createUser(bloc);
    else
      await _loginUser(bloc);
  }

  SnackBar _createSnackbar() {
    return SnackBar(
      content: Text(
        "Error: El Email ya existe",
        textAlign: TextAlign.center,
      ),
    );
  }

  void _showSnackbar() {
    _scaffoldKey.currentState.showSnackBar(_createSnackbar());
  }
}
