import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testfirebase/src/models/user.dart';
import 'package:testfirebase/src/pages/home_page.dart';
import 'package:testfirebase/src/pages/login_page.dart';

class WrapperPage extends StatelessWidget {
  const WrapperPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (user == null)
      return LoginPage();
    else {
      return HomePage();
    }
  }
}
