import 'dart:async';

import 'package:flutter/material.dart';

import 'api/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  Future<API> _api;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final email = TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: 'Email',
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        border: OutlineInputBorder(),
      ),
    );

    final password = TextFormField(
      controller: passwordController,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: 'Password',
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        border: OutlineInputBorder(),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(4.0),
        shadowColor: Colors.teal.shade500,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: () {
            setState(() {
              _api = API.fromCredentials(
                  emailController.value.text, passwordController.value.text);
            });
          },
          color: Colors.teal.shade300,
          child: Text(
            'Log In',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );

    final tokenOutput = FutureBuilder<API>(
      future: _api,
      builder: (BuildContext context, AsyncSnapshot<API> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return SizedBox(height: 5.0);
          case ConnectionState.waiting:
            return LinearProgressIndicator();
          default:
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else {
              final token = snapshot.data.token;
              final tokenText = "Token: ${token.obscuredToken()}";
              final dateText = "Created At ${token.createdAt}";
              return Text("$tokenText\n$dateText");
            }
        }
      },
    );

    return Scaffold(
      backgroundColor: Colors.teal,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            SizedBox(height: 48.0),
            email,
            SizedBox(height: 8.0),
            password,
            SizedBox(height: 24.0),
            loginButton,
            tokenOutput,
          ],
        ),
      ),
    );
  }
}
