import 'package:flutter/material.dart';

class PasswordInput extends StatefulWidget {
  final String errorMsg;
  final Function(String, bool) onValueChanged;
  PasswordInput({Key key, this.errorMsg, this.onValueChanged}) : super(key: key);

  @override
  _PasswordInputState createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  String _actualErrorMsg;
  String password;

  bool get isValid => (_actualErrorMsg == null && password.length > 0) ? true : false;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: TextFormField(
          keyboardType: TextInputType.text,
          obscureText: true,
          decoration: InputDecoration(
            icon: Icon(Icons.lock_outline, color: Colors.deepPurple),
            labelText: "Contraseña",
            errorText: _actualErrorMsg,
          ),
          onChanged: (value) {
            password = value;
            if (password.length > 7) {
              _actualErrorMsg = null;
            } else if (value.length == 0) {
              _actualErrorMsg = null;
            } else
              _actualErrorMsg = widget.errorMsg == null ? "La contraseña ha de tener mas de 6 caracteres" : widget.errorMsg;

            widget.onValueChanged?.call(value, this.isValid);

            setState(() {});
          },
        ));
  }
}
