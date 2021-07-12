import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'services/coin_data.dart';
import 'dart:io' show Platform;
import 'dart:math';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  String selectedCrypto;
  String cryptoPrice;

  double roundDouble(double value, int places) {
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  Future<void> updateCryptoPrice(
      {String userSelectedCurrency, String userSelectedCrypto}) async {
    CoinData coinData = CoinData();
    var cryptoData = await coinData.getCryptoData(userSelectedCrypto);
    if (cryptoData == null) {
      cryptoPrice = 'Error';
      return;
    }
    var price = roundDouble(
        cryptoData['rates']
            .where((item) => item['asset_id_quote'] == '$selectedCurrency')
            .toList()[0]['rate'],
        2);
    setState(() {
      cryptoPrice = price.toString();
    });
  }

  DropdownButton getAndroidPicker() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropDownItems.add(newItem);
    }
    return DropdownButton(
      value: selectedCurrency,
      items: dropDownItems,
      onChanged: (value) {
        selectedCurrency = value;
        updateCryptoPrice(
            userSelectedCrypto: 'BTC', userSelectedCurrency: selectedCurrency);
      },
    );
  }

  CupertinoPicker getIosPicker() {
    List<Text> pickerItems = [];
    List<String> currencies = [];
    for (String currency in currenciesList) {
      var newItem = Text(currency);
      pickerItems.add(newItem);
      currencies.add(currency);
    }
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 60.0,
      onSelectedItemChanged: (selectedIndex) {
        selectedCurrency = currencies[selectedIndex];
        updateCryptoPrice(
            userSelectedCrypto: 'BTC', userSelectedCurrency: selectedCurrency);
      },
      children: pickerItems,
    );
  }

  @override
  void initState() {
    super.initState();
    updateCryptoPrice(
        userSelectedCrypto: 'BTC', userSelectedCurrency: selectedCurrency);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 BTC = ${cryptoPrice ?? 0} $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? getIosPicker() : getAndroidPicker(),
          ),
        ],
      ),
    );
  }
}
