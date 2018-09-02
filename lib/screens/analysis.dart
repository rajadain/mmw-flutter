import 'dart:async';

import 'package:flutter/material.dart';

import '../api/Boundary.dart';
import '../api/JobStatus.dart';
import '../components/RadialChart.dart';

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
              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.error,
                        color: Colors.redAccent,
                      ),
                      Text(snapshot.error.toString()),
                    ],
                  ),
                );
              }

              return RadialChart.withSampleData();
            default:
              return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
