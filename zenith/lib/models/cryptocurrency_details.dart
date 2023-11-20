class CryptocurrencyDetails {
  final String id;
  final String symbol;
  final String name;
  final String image;
  final double currentPrice;
  final int marketCap;
  final int marketCapRank;
  final int fullyDilutedValuation;
  final double totalVolume;
  final double high24h;
  final double low24h;
  final double priceChange24h;
  final double priceChangePercentage24h;
  final int marketCapChange24h;
  final double marketCapChangePercentage24h;
  final double circulatingSupply;
  final double totalSupply;
  final double maxSupply;
  final double ath;
  final double athChangePercentage;
  final String athDate;
  final double atl;
  final double atlChangePercentage;
  final String atlDate;
  final double? roi;
  final String lastUpdated;

  CryptocurrencyDetails({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.currentPrice,
    required this.marketCap,
    required this.marketCapRank,
    required this.fullyDilutedValuation,
    required this.totalVolume,
    required this.high24h,
    required this.low24h,
    required this.priceChange24h,
    required this.priceChangePercentage24h,
    required this.marketCapChange24h,
    required this.marketCapChangePercentage24h,
    required this.circulatingSupply,
    required this.totalSupply,
    required this.maxSupply,
    required this.ath,
    required this.athChangePercentage,
    required this.athDate,
    required this.atl,
    required this.atlChangePercentage,
    required this.atlDate,
    required this.roi,
    required this.lastUpdated,
  });

  factory CryptocurrencyDetails.fromJson(Map<String, dynamic> json) {
    return CryptocurrencyDetails(
      id: json['id'],
      symbol: json['symbol'],
      name: json['name'],
      image: json['image'],
      currentPrice: json['current_price'].toDouble(),
      marketCap: json['market_cap'],
      marketCapRank: json['market_cap_rank'],
      fullyDilutedValuation: json['fully_diluted_valuation'],
      totalVolume: json['total_volume'].toDouble(),
      high24h: json['high_24h'].toDouble(),
      low24h: json['low_24h'].toDouble(),
      priceChange24h: json['price_change_24h'].toDouble(),
      priceChangePercentage24h: json['price_change_percentage_24h'].toDouble(),
      marketCapChange24h: json['market_cap_change_24h'],
      marketCapChangePercentage24h: json['market_cap_change_percentage_24h'].toDouble(),
      circulatingSupply: json['circulating_supply'].toDouble(),
      totalSupply: json['total_supply'].toDouble(),
      maxSupply: json['max_supply'].toDouble(),
      ath: json['ath'].toDouble(),
      athChangePercentage: json['ath_change_percentage'].toDouble(),
      athDate: json['ath_date'],
      atl: json['atl'].toDouble(),
      atlChangePercentage: json['atl_change_percentage'].toDouble(),
      atlDate: json['atl_date'],
      roi: json['roi']?.toDouble(),
      lastUpdated: json['last_updated'],
    );
  }
}
