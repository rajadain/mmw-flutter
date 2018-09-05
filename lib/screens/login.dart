import 'dart:async';

import 'package:flutter/material.dart';

import '../api/main.dart';
import 'search.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
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

    final loginButton = MaterialButton(
      minWidth: 200.0,
      height: 42.0,
      color: Colors.teal.shade300,
      onPressed: () {
        final username = emailController.value.text;
        final password = passwordController.value.text;
        final onLoggedIn = (API api) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchScreen(api: api),
            ),
          );

          return api;
        };

        setState(() {
          _api = API.fromCredentials(username, password).then(onLoggedIn);
        });
      },
      child: Text(
        'Log In',
        style: TextStyle(color: Colors.white),
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
              return SizedBox(height: 5.0);
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
