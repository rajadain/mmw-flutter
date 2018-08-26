import 'package:flutter/material.dart';

import '../api/main.dart';

class SearchScreen extends StatefulWidget {
  final API api;

  const SearchScreen({Key key, @required this.api}) : super(key: key);

  @override
  createState() => _SearchScreen();
}

class _SearchScreen extends State<SearchScreen> {
  final _delegate = _SearchScreenSearchDelegate();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  int _lastIntegerSelected;

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
              final selected = await showSearch<int>(
                context: context,
                delegate: _delegate,
              );

              if (selected != null && selected != _lastIntegerSelected) {
                setState(() {
                  _lastIntegerSelected = selected;
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

class _SearchScreenSearchDelegate extends SearchDelegate<int> {
  final List<int> _history = <int>[42607, 85604, 66734, 44, 174];
  final List<int> _data =
      List<int>.generate(10001, (int i) => i).reversed.toList();

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
    final Iterable<int> suggestions = query.isEmpty
        ? _history
        : _data.where((int i) => '$i'.startsWith(query));

    return _SuggestionList(
      query: query,
      suggestions: suggestions.map((int i) => '$i').toList(),
      onSelected: (String suggestion) {
        query = suggestion;
        showResults(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final searched = int.tryParse(query);

    if (searched == null || !_data.contains(searched)) {
      return Center(
        child: Text(
          'Invalid query: $query',
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView(
      children: [
        _ResultCard(
          title: 'this integer',
          integer: searched,
          searchDelegate: this,
        ),
        _ResultCard(
          title: 'next integer',
          integer: searched + 1,
          searchDelegate: this,
        ),
        _ResultCard(
          title: 'previous integer',
          integer: searched - 1,
          searchDelegate: this,
        ),
      ],
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
  const _ResultCard({this.integer, this.title, this.searchDelegate});

  final int integer;
  final String title;
  final SearchDelegate<int> searchDelegate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        searchDelegate.close(context, integer);
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(title),
              Text(
                '$integer',
                style: theme.textTheme.headline.copyWith(fontSize: 72.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SuggestionList extends StatelessWidget {
  const _SuggestionList({this.suggestions, this.query, this.onSelected});

  final List<String> suggestions;
  final String query;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int i) {
        final String suggestion = suggestions[i];

        return ListTile(
          leading: query.isEmpty ? Icon(Icons.history) : Icon(null),
          title: RichText(
            text: TextSpan(
              text: suggestion.substring(0, query.length),
              style:
                  theme.textTheme.subhead.copyWith(fontWeight: FontWeight.bold),
              children: <TextSpan>[
                TextSpan(
                  text: suggestion.substring(query.length),
                  style: theme.textTheme.subhead,
                ),
              ],
            ),
          ),
          onTap: () {
            onSelected(suggestion);
          },
        );
      },
    );
  }
}
