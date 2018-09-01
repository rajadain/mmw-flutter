abstract class Result {
  get analysisType;
}

class LandResult extends Result {
  get analysisType => "land";

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
      nlcd: int.parse(json['nlcd']),
      areaSqm: double.parse(json['area']),
      areaPercent: double.parse(json['coverage']),
      code: json['code'],
      label: json['type'],
    );
  }
}
