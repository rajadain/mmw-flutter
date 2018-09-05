import 'AnalysisTypes.dart';

abstract class Result {
  AnalysisTypes get analysisType;
}

Result parseResult(Map<String, dynamic> json) {
  final analysisType = parseAnalysisType(json['survey']['name']);

  switch (analysisType) {
    case AnalysisTypes.land:
      return LandResult.fromJson(json['survey']);
    case AnalysisTypes.soil:
      return SoilResult.fromJson(json['survey']);
    default:
      throw Exception("Error: Unsupported result type");
  }
}

class SoilResult extends Result {
  get analysisType => AnalysisTypes.soil;

  final List<SoilResultCategory> categories;

  SoilResult({this.categories});

  factory SoilResult.fromJson(Map<String, dynamic> json) {
    return SoilResult(
      categories: (json['categories'] as List)
          .map((j) => SoilResultCategory.fromJson(j))
          .toList(),
    );
  }
}

class SoilResultCategory {
  final double areaSqm;
  final double areaPercent;
  final String code;
  final String label;

  const SoilResultCategory({
    this.areaSqm,
    this.areaPercent,
    this.code,
    this.label,
  });

  factory SoilResultCategory.fromJson(Map<String, dynamic> json) {
    return SoilResultCategory(
      areaSqm: json['area'],
      areaPercent: json['coverage'],
      code: json['code'],
      label: json['type'],
    );
  }

  static int compare(SoilResultCategory a, SoilResultCategory b) {
    if (a.areaSqm == b.areaSqm) {
      return 0;
    } else if (a.areaSqm < b.areaSqm) {
      return 1;
    } else {
      return -1;
    }
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

class LandResultCategory extends SoilResultCategory {
  final int nlcd;

  const LandResultCategory({
    this.nlcd,
    areaSqm,
    areaPercent,
    code,
    label,
  }) : super(
          areaSqm: areaSqm,
          areaPercent: areaPercent,
          code: code,
          label: label,
        );

  factory LandResultCategory.fromJson(Map<String, dynamic> json) {
    return LandResultCategory(
      nlcd: json['nlcd'],
      areaSqm: json['area'],
      areaPercent: json['coverage'],
      code: json['code'],
      label: json['type'],
    );
  }
}
