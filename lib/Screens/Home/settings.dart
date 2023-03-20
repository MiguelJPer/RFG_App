import 'package:flutter/material.dart';
import 'package:rfg_app/Services/auth.dart';

class settingScreen extends StatefulWidget {
  const settingScreen({super.key});

  @override
  State<settingScreen> createState() => _ListState();
}

class _ListState extends State<settingScreen> {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Settings")
      ),
        body: Center(
          child:
          TextButton.icon(
            icon: Icon(Icons.person),
            label: Text('logout'),
            onPressed: () async {
              await _auth.signOut();
            },
          ),
        )
    );
  }
}
