import 'HUC.dart';

class Boundary {
  final int id;
  final HUC huc;
  final String name;
  final int rank;
  final double x;
  final double y;

  const Boundary({
    this.id,
    this.huc,
    this.name,
    this.rank,
    this.x,
    this.y,
  });

  factory Boundary.fromJson(Map<String, dynamic> json) {
    return Boundary(
      id: json['id'],
      huc: HUCS.fromCode(json['code']),
      name: json['text'],
      rank: json['rank'],
      x: json['x'],
      y: json['y'],
    );
  }

  factory Boundary.fromArgs(
      int id, HUC huc, String name, int rank, double x, double y) {
    return Boundary(
      id: id,
      huc: huc,
      name: name,
      rank: rank,
      x: x,
      y: y,
    );
  }
}
