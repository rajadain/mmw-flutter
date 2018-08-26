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
  final _delegate = _SearchScreenSearchDelegate(
    api: widget.api,
  );
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Boundary _lastSelectedBoundary;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Navigation Menu',
          icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow,
            color: Colors.white,
            progress: _delegate.transitionAnimation,
          ),
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
        ),
        title: Text('Hydrological Unit Codes'),
        actions: [
          IconButton(
            tooltip: 'Search',
            icon: Icon(Icons.search),
            onPressed: () async {
              final selected = await showSearch<Boundary>(
                context: context,
                delegate: _delegate,
              );

              if (selected != null && selected != _lastSelectedBoundary) {
                setState(() {
                  _lastSelectedBoundary = selected;
                });
              }
            },
          ),
          IconButton(
            tooltip: 'More (not implemented)',
            icon: Icon(Theme.of(context).platform == TargetPlatform.iOS
                ? Icons.more_horiz
                : Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: Colors.teal,
      body: ListView(
        padding: EdgeInsets.only(left: 24.0, right: 24.0),
        children: <Widget>[
          SizedBox(height: 48.0),
        ],
      ),
    );
  }
}

class _SearchScreenSearchDelegate extends SearchDelegate<Boundary> {
  final API api;
  Future<List<Boundary>> _future;

  _SearchScreenSearchDelegate({this.api});

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _future = api.getSuggestions(query);

    return _FutureSuggestionList(
      future: _future,
      query: query,
      onSelected: (Boundary suggestion) {
        query = suggestion.name;
        showResults(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
//    final searched = _data.firstWhere((Boundary b) => b.name.contains(query));
//
//    if (searched == null || !_data.contains(searched)) {
//      return Center(
//        child: Text(
//          'No results for $query',
//          textAlign: TextAlign.center,
//        ),
//      );
//    }
//
//    return ListView(
//      children: [
//        _ResultCard(
//          boundary: searched,
//          searchDelegate: this,
//        ),
//      ],
//    );

    return Center(
      child: Text(
        'No results for $query',
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      query.isEmpty
          ? IconButton(
              tooltip: 'Voice Search',
              icon: const Icon(Icons.mic),
              onPressed: () {
                query = 'TODO: implement voice input';
              },
            )
          : IconButton(
              tooltip: 'Clear',
              icon: const Icon(Icons.clear),
              onPressed: () {
                query = '';
                showSuggestions(context);
              },
            )
    ];
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({this.boundary, this.searchDelegate});

  final Boundary boundary;
  final SearchDelegate<Boundary> searchDelegate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        searchDelegate.close(context, boundary);
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(boundary.huc.label),
              Text(
                boundary.name,
                style: theme.textTheme.headline.copyWith(fontSize: 36.0),
              ),
              Text('${boundary.x}, ${boundary.y}'),
            ],
          ),
        ),
      ),
    );
  }
}

class _FutureSuggestionList extends StatelessWidget {
  const _FutureSuggestionList({this.future, this.query, this.onSelected});

  final Future<List<Boundary>> future;
  final String query;
  final ValueChanged<Boundary> onSelected;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Boundary>>(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<List<Boundary>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return _SuggestionList(
              suggestions: snapshot.data,
              query: query,
              onSelected: onSelected,
            );
          default:
            return _SuggestionList(
              suggestions: [],
              query: query,
              onSelected: onSelected,
            );
        }
      },
    );
  }
}

class _SuggestionList extends StatelessWidget {
  const _SuggestionList({this.suggestions, this.query, this.onSelected});

  final List<Boundary> suggestions;
  final String query;
  final ValueChanged<Boundary> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int i) {
        final String name = suggestions[i].name;
        final int matchIndex = name.indexOf(query);
        final String beforeMatch = name.substring(0, matchIndex);
        final String match =
            name.substring(matchIndex, matchIndex + query.length);
        final String afterMatch = name.substring(matchIndex + query.length);

        return ListTile(
          leading: query.isEmpty ? Icon(Icons.history) : Icon(null),
          title: RichText(
            text: TextSpan(
              text: beforeMatch,
              style: theme.textTheme.subhead,
              children: <TextSpan>[
                TextSpan(
                  text: match,
                  style: theme.textTheme.subhead
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: afterMatch,
                ),
              ],
            ),
          ),
          onTap: () {
            onSelected(suggestions[i]);
          },
        );
      },
    );
  }
}
