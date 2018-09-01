enum AnalysisTypes { land, soil, climate }

AnalysisTypes parseAnalysisType(String analysisType) {
  String test = "AnalysisTypes.$analysisType";

  return AnalysisTypes.values.firstWhere(
    (a) => a.toString() == test,
    orElse: () => null,
  );
}
