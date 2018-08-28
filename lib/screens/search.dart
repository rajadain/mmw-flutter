import 'dart:async';

import 'package:flutter/material.dart';

import '../api/Boundary.dart';
import '../api/main.dart';

class SearchScreen extends StatefulWidget {
  final API api;

  const SearchScreen({Key key, @required this.api}) : super(key: key);

  @override
  createState() => _SearchScreen();
}

class _SearchScreen extends State<SearchScreen> {
  final searchController = TextEditingController();
  String get query => searchController.text;

  Future<List<Boundary>> boundaries;

  @override
  Widget build(BuildContext context) {
    final search = TextFormField(
      controller: searchController,
      autofocus: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: 'Search for HUC',
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        border: OutlineInputBorder(),
      ),
    );

    final button = RaisedButton(
      onPressed: () {
        setState(() {
          boundaries = widget.api.getSuggestions(query);
        });
      },
      child: Text("Search"),
    );

    final results = FutureBuilder<List<Boundary>>(
      future: boundaries,
      builder: (BuildContext context, AsyncSnapshot<List<Boundary>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }

            return Column(
              children: snapshot.data
                  .map((Boundary b) => _BoundarySuggestionTile(b))
                  .toList(),
            );
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Text("Fetching Results");
          default:
            return SizedBox(height: 8.0);
        }
      },
    );

    return Scaffold(
      backgroundColor: Colors.teal,
      body: ListView(
        padding: EdgeInsets.only(left: 24.0, right: 24.0),
        children: <Widget>[
          SizedBox(height: 48.0),
          search,
          SizedBox(height: 8.0),
          button,
          SizedBox(height: 8.0),
          results,
        ],
      ),
    );
  }
}

class _BoundarySuggestionTile extends StatelessWidget {
  final Boundary boundary;

  const _BoundarySuggestionTile(this.boundary);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(boundary.name),
    );
  }
}
