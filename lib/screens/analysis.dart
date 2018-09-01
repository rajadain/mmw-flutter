import 'package:flutter/material.dart';

import '../api/Boundary.dart';
import '../api/main.dart';

class AnalysisScreen extends StatefulWidget {
  final API api;
  final Boundary boundary;

  const AnalysisScreen({
    Key key,
    @required this.boundary,
    @required this.api,
  }) : super(key: key);

  @override
  createState() => _AnalysisScreen();
}

class _AnalysisScreen extends State<AnalysisScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Padding(
                padding: EdgeInsets.all(12.0),
                child: Text("Land"),
              ),
              Padding(
                padding: EdgeInsets.all(12.0),
                child: Text("Soil"),
              ),
              Padding(
                padding: EdgeInsets.all(12.0),
                child: Text("Climate"),
              ),
            ],
          ),
          title: Text(widget.boundary.name),
        ),
        body: TabBarView(
          children: [
            Center(
              child: CircularProgressIndicator(),
            ),
            Center(
              child: CircularProgressIndicator(),
            ),
            Center(
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
