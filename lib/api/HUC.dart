class HUC {
  final String code;
  final String label;

  const HUC({this.code, this.label});
}

class HUCS {
  static const huc8 = HUC(code: 'huc8', label: 'HUC-8 Subbasin');
  static const huc10 = HUC(code: 'huc10', label: 'HUC-10 Subbasin');
  static const huc12 = HUC(code: 'huc12', label: 'HUC-12 Subbasin');

  static HUC fromCode(String code) {
    switch (code) {
      case 'huc8':
        return huc8;
      case 'huc10':
        return huc10;
      case 'huc12':
        return huc12;
      default:
        return HUC(code: code, label: 'Unknown HUC');
    }
  }
}
