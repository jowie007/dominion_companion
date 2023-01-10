class Expansion {
  final int id;
  final String name;
  final double version;

  Expansion(this.id, this.name, this.version);

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'version': version,
  };
}