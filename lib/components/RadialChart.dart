import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';

import '../api/Result.dart';

const Map<int, Color> COLOR_NLCD = {
  11: Color(0xFF5475A8),
  12: Color(0xFFFFFFFF),
  21: Color(0xFFE8D1D1),
  22: Color(0xFFE29E8C),
  23: Color(0xFFFF0000),
  24: Color(0xFFB50000),
  31: Color(0xFFD2CDC0),
  41: Color(0xFF85C77E),
  42: Color(0xFF38814E),
  43: Color(0xFFD4E7B0),
  52: Color(0xFFDCCA8F),
  71: Color(0xFFFDE9AA),
  81: Color(0xFFFBF65D),
  82: Color(0xFFCA9146),
  90: Color(0xFFC8E6F8),
  95: Color(0xFF64B3D5),
};

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

  factory RadialChart.fromLandResult(LandResult result) {
    final categories = result.categories;
    categories.sort(LandResultCategory.compare);

    return RadialChart(
      [
        CircularStackEntry(
          categories
              .map((LandResultCategory lrc) => CircularSegmentEntry(
                    lrc.areaSqm,
                    COLOR_NLCD[lrc.nlcd],
                    rankKey: lrc.code,
                  ))
              .toList(),
          rankKey: 'Land Use Distribution',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCircularChart(
      size: Size(700.0, 700.0),
      initialChartData: data,
      holeRadius: 20.0,
      chartType: CircularChartType.Radial,
    );
  }
}
