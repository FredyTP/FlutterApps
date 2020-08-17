import 'package:discoduroupv/bloc/server_bloc.dart';
import 'package:flutter/material.dart';

import 'login_bloc.dart';


class Provider extends InheritedWidget {

  final loginBloc = LoginBloc();
  final serverBloc = ServerBloc();
  static Provider _instancia;
  
  factory Provider({Key key, Widget child}){
    if(_instancia== null)
    {
      _instancia=new Provider._internal(key: key, child: child);
    }
    return _instancia;
  }
  Provider._internal({Key key, Widget child})
    : super(key: key, child : child); 


  @override
  bool updateShouldNotify( Provider oldWidget) {
    return true;
  }

  static LoginBloc of ( BuildContext context ){
    return context.dependOnInheritedWidgetOfExactType<Provider>().loginBloc;
  }
  static ServerBloc ofServer ( BuildContext context ){
    return context.dependOnInheritedWidgetOfExactType<Provider>().serverBloc;
  } 

}