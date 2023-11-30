class Alert {
  final String symbol; // Nome do portfolio
  final double targetPrice; // Sigla que representa o nome da criptomoeda
  bool Status; // Quantidade disponível da criptomoeda

  Alert({
    required this.symbol,
    required this.targetPrice,
    this.Status = false,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'Symbol': symbol,
      'TargetPrice': targetPrice,
      'Status': Status == 1,
    };
    return map;
  }

  Alert.fromMap(Map<String, dynamic> map)
    : symbol = map['Symbol'],
      targetPrice = map['TargetPrice'],
      Status = map['Status'] == 1; // Converte para um valor booleano
}
