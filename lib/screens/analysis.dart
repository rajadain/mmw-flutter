import 'dart:async';

import 'package:flutter/material.dart';

import '../api/Boundary.dart';
import '../api/JobStatus.dart';

class AnalysisScreen extends StatefulWidget {
  final Future<JobStatus> landJob;
  final Boundary boundary;

  const AnalysisScreen({
    Key key,
    @required this.boundary,
    @required this.landJob,
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
              child: JobWidget(job: widget.landJob),
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

class JobWidget extends StatelessWidget {
  final Future<JobStatus> job;

  const JobWidget({Key key, @required this.job}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<JobStatus>(
        future: job,
        builder: (BuildContext context, AsyncSnapshot<JobStatus> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final icon =
                  snapshot.hasError ? Icons.error_outline : Icons.check_circle;
              return Icon(
                icon,
                color: Theme.of(context).primaryColor,
              );
            default:
              return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
