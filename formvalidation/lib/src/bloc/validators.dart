import 'dart:async';

class Validators {

    final validarEmail = StreamTransformer<String,String>.fromHandlers(
    handleData: (data, sink) {
      Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp = new RegExp(pattern);

      if( regExp.hasMatch(data) )
      {
        sink.add(data);
      }
      else
        sink.addError("Introduce un Email Valido");
    }

  );


  final validarPassword = StreamTransformer<String,String>.fromHandlers(
    handleData: (data, sink) {
      if(data.length>=6){
        sink.add(data);
      } else {
        sink.addError('6 caracteres o más');
      }
    },
  );





}