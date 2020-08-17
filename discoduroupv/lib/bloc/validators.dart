import 'dart:async';

class Validators {

    final validarEmail = StreamTransformer<String,String>.fromHandlers(
    handleData: (data, sink) {
      if(data.length>=3){
        sink.add(data);
      } else {
        sink.addError('3 caracteres o más');
      }
    }

  );


  final validarPassword = StreamTransformer<String,String>.fromHandlers(
    handleData: (data, sink) {
      if(data.length>=3){
        sink.add(data);
      } else {
        sink.addError('3 caracteres o más');
      }
    },
  );





}