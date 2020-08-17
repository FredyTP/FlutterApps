import 'package:flutter/material.dart';

class EmailInput extends StatefulWidget {
  final String errorMsg;
  final Function(String, bool) onValueChanged;
  EmailInput({Key key, this.errorMsg, this.onValueChanged}) : super(key: key);

  @override
  _EmailInputState createState() => _EmailInputState();
}

class _EmailInputState extends State<EmailInput> {
  String _actualErrorMsg;
  String email;

  bool get isValid => (_actualErrorMsg == null && email.length > 0) ? true : false;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            icon: Icon(Icons.alternate_email, color: Colors.deepPurple),
            hintText: "ejemplo@correo.com",
            labelText: "Correo electrónico",
            //counterText: snapshot.data,
            errorText: _actualErrorMsg,
          ),
          onChanged: (value) {
            Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
            RegExp regExp = new RegExp(pattern);
            email = value;
            if (regExp.hasMatch(value)) {
              _actualErrorMsg = null;
            } else if (value.length == 0) {
              _actualErrorMsg = null;
            } else
              _actualErrorMsg = widget.errorMsg == null ? "Introduce un Email Válido" : widget.errorMsg;

            widget.onValueChanged?.call(value, this.isValid);

            setState(() {});
          },
        ));
  }
}
