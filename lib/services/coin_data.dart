import 'networking.dart';

const apiKey = '2992DB45-0914-42C7-A381-2891CF4B9FF9';
const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NGN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  // CoinData({@required this.crypto});
  // final ;
  Future<dynamic> getCryptoData(String crypto) async {
    String url =
        'https://rest.coinapi.io/v1/exchangerate/$crypto?invert=false&apikey=$apiKey';
    NetworkHelper networkHelper = NetworkHelper(url);
    var decodedCoinData = await networkHelper.getData();
    return decodedCoinData;
  }
}
