class Alerts {
  final String symbol; // Nome do portfolio
  final String targetPrice; // Sigla que representa o nome da criptomoeda
  bool Status; // Quantidade disponível da criptomoeda

  Alerts({
    required this.symbol,
    required this.targetPrice,
    this.Status = false,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'Symbol': symbol,
      'TargetPrice': targetPrice,
      'Status': Status,
    };
    return map;
  }

  Alerts.fromMap(Map<String, dynamic> map)
      : symbol = map['Symbol'],
        targetPrice = map['TargetPrice'],
        Status = map['Status'];
}
