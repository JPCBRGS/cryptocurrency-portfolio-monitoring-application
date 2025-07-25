class Cryptocurrency {
  final String portfolio; // Nome do portfolio
  final String symbol; // Sigla que representa o nome da criptomoeda
  final double quantity; // Quantidade disponível da criptomoeda
  final double averagePurchasePrice; // Preço médio de compra da criptomoeda

  Cryptocurrency({
    required this.portfolio,
    required this.symbol,
    required this.quantity,
    required this.averagePurchasePrice,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'Portfolio': portfolio, 
      'Symbol': symbol,
      'Quantity': quantity,
      'AveragePurchasePrice': averagePurchasePrice,
    };
    return map;
  }

  Cryptocurrency.fromMap(Map<String, dynamic> map)
      : portfolio = map['Portfolio'],
        symbol = map['Symbol'],
        quantity = map['Quantity'],
        averagePurchasePrice = map['AveragePurchasePrice'];
}
