class Cryptocurrency {
  final String portfolio; // Nome do portfolio
  final String symbol; // Sigla que representa o nome da criptomoeda
  final double quantity; // Quantidade disponível da criptomoeda
  final double mediumPurchasePrice; // Preço médio de compra da criptomoeda
  final double mediumSellPrice; // Valor médio de venda da criptomoeda

  Cryptocurrency({
    required this.portfolio,
    required this.symbol,
    required this.quantity,
    required this.mediumPurchasePrice,
    required this.mediumSellPrice,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'Portfolio': portfolio, // Armazene o nome do portfolio
      'Symbol': symbol,
      'Quantity': quantity,
      'PurchasePrice': mediumPurchasePrice,
      'MediumSellPrice': mediumSellPrice,
    };
    return map;
  }

  Cryptocurrency.fromMap(Map<String, dynamic> map)
      : portfolio = map['Portfolio'],
        symbol = map['Symbol'],
        quantity = map['Quantity'],
        mediumPurchasePrice = map['PurchasePrice'],
        mediumSellPrice = map['MediumSellPrice'];
}
