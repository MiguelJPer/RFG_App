import 'package:firebase_auth/firebase_auth.dart';
import 'package:rfg_app/Screens/authenticate/authenticate.dart';
import 'package:rfg_app/Screens/Home/canvas.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  Wrapper({super.key});

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User?>(context);
    print(user);

    // return either the Home or Authenticate widget
    if (user == null){
      return Authenticate();
    } else {
      return canvas();
    }

  }
}