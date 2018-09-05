import 'AnalysisTypes.dart';

abstract class Result {
  AnalysisTypes get analysisType;
}

Result parseResult(Map<String, dynamic> json) {
  final analysisType = parseAnalysisType(json['survey']['name']);

  switch (analysisType) {
    case AnalysisTypes.land:
      return LandResult.fromJson(json['survey']);
    default:
      throw Exception("Error: Unsupported result type");
  }
}

class LandResult extends Result {
  get analysisType => AnalysisTypes.land;

  final List<LandResultCategory> categories;

  LandResult({this.categories});

  factory LandResult.fromJson(Map<String, dynamic> json) {
    return LandResult(
      categories: (json['categories'] as List)
          .map((j) => LandResultCategory.fromJson(j))
          .toList(),
    );
  }
}

class LandResultCategory {
  final int nlcd;
  final double areaSqm;
  final double areaPercent;
  final String code;
  final String label;

  const LandResultCategory({
    this.nlcd,
    this.areaSqm,
    this.areaPercent,
    this.code,
    this.label,
  });

  factory LandResultCategory.fromJson(Map<String, dynamic> json) {
    return LandResultCategory(
      nlcd: json['nlcd'],
      areaSqm: json['area'],
      areaPercent: json['coverage'],
      code: json['code'],
      label: json['type'],
    );
  }

  static int compare(LandResultCategory a, LandResultCategory b) {
    if (a.areaSqm == b.areaSqm) {
      return 0;
    } else if (a.areaSqm < b.areaSqm) {
      return 1;
    } else {
      return -1;
    }
  }
}
