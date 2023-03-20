import 'package:flutter/material.dart';

class listScreen extends StatefulWidget {
  const listScreen({super.key});

  @override
  State<listScreen> createState() => _ListState();
}

class _ListState extends State<listScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Your traps")
      ),
      body: Center(
        child: Text("Placeholder"),
      )
    );
  }
}
