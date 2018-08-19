import 'package:flutter/material.dart';

import 'src/login_page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'MMW Flutter',
      theme: new ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: LoginPage(),
    );
  }
}
