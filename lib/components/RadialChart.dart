import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';

class RadialChart extends StatelessWidget {
  final List<CircularStackEntry> data;

  RadialChart(this.data);

  factory RadialChart.withSampleData() {
    return RadialChart(
      <CircularStackEntry>[
        CircularStackEntry(
          <CircularSegmentEntry>[
            CircularSegmentEntry(500.0, Colors.red[200], rankKey: 'Q1'),
            CircularSegmentEntry(1000.0, Colors.green[200], rankKey: 'Q2'),
            CircularSegmentEntry(2000.0, Colors.blue[200], rankKey: 'Q3'),
            CircularSegmentEntry(1000.0, Colors.yellow[200], rankKey: 'Q4'),
          ],
          rankKey: 'Quarterly Profits',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCircularChart(
      size: Size(400.0, 400.0),
      initialChartData: data,
      chartType: CircularChartType.Radial,
    );
  }
}
