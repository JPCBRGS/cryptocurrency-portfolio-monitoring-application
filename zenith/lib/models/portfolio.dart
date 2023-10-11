class Portfolios {
  final int? id; // Defina o ID como opcional com valor padrão de null
  final String name;

  Portfolios({
    this.id, // O ID agora é opcional
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'Name': name,
    };
  }

  factory Portfolios.fromMap(Map<String, dynamic> map) {
    return Portfolios(
      id: map['ID'],
      name: map['Name'],
    );
  }
}
