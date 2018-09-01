import 'dart:async';

import 'package:flutter/material.dart';

import '../api/Boundary.dart';
import '../api/main.dart';
import 'analysis.dart';

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
                  .map((Boundary b) => _BoundarySuggestionTile(
                        api: widget.api,
                        query: query,
                        boundary: b,
                      ))
                  .toList(),
            );
          case ConnectionState.active:
          case ConnectionState.waiting:
            return LinearProgressIndicator();
          default:
            return SizedBox(height: 8.0);
        }
      },
    );

    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        title: Text("Search for HUC"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: <Widget>[
            search,
            SizedBox(height: 8.0),
            Row(
              children: <Widget>[
                Expanded(child: button),
              ],
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: ListView(
                children: [results],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BoundarySuggestionTile extends StatelessWidget {
  final Boundary boundary;
  final String query;
  final API api;

  const _BoundarySuggestionTile({
    Key key,
    @required this.boundary,
    @required this.query,
    @required this.api,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String name = boundary.name;
    final int matchIndex = name.toLowerCase().indexOf(query.toLowerCase());
    final String beforeMatch = name.substring(0, matchIndex);
    final String match = name.substring(matchIndex, matchIndex + query.length);
    final String afterMatch = name.substring(matchIndex + query.length);
    final TextStyle style = Theme.of(context).textTheme.subhead;

    return Card(
      color: Colors.white,
      child: ListTile(
        title: RichText(
          text: TextSpan(
            text: beforeMatch,
            style: style,
            children: [
              TextSpan(
                text: match,
                style: style.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: afterMatch,
              ),
            ],
          ),
        ),
        subtitle: Text(boundary.huc.label),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AnalysisScreen(
                    boundary: boundary,
                    landJob: api.postLand(boundary),
                  ),
            ),
          );
        },
      ),
    );
  }
}
