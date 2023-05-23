import 'dart:convert';

import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'api/apis.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  List<DropdownMenuItem<String>> coinList = [];

  String selectiveCurrency = 'USD';

  // List<DropdownMenuItem<String>> listGenerator() {
  //   List<DropdownMenuItem<String>> tempWidget = [];
  //   for (int i = 0; i < currenciesList.length; i++) {
  //     String currency = currenciesList[i];
  //     var listWiget = DropdownMenuItem(
  //       child: Text(currency),
  //       value: currency,
  //     );
  //     tempWidget.add(listWiget);
  //   }
  //   return tempWidget;
  // }

  List<Widget> iosList() {
    List<Text> tempWidget = [];
    for (String iosElement in currenciesList) {
      tempWidget.add(Text(iosElement));
    }
    return tempWidget;
  }

  @override
  Widget build(BuildContext context) {
    //Future<String> exchangeRate = exchangeData();
    //listGenerator();
    //coinList = listGenerator();
    //print(coinList);
    List<Widget> iosNewList = iosList();
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // coinWidget(selectiveCurrency, 'BTC'),
          // coinWidget(selectiveCurrency, "ETH"),
          // coinWidget(selectiveCurrency, 'LTC'),
          coinWidget('37.785834', '-122.406417'),
          coinWidget('57.785834', "-142.406417"),
          coinWidget('17.785834', '-102.406417'),
          coinContainer(iosNewList),
        ],
      ),
    );
  }

  Container coinContainer(List<Widget> iosNewList) {
    return Container(
      height: 150.0,
      alignment: Alignment.center,
      padding: EdgeInsets.only(bottom: 30.0),
      color: Colors.lightBlue,
      child: CupertinoPicker(
          backgroundColor: Colors.lightBlue,
          itemExtent: 32.0,
          onSelectedItemChanged: (onSelectedItemChanged) {
            //var selectiveCurrency = onSelectedItemChanged;
            setState(() {
              selectiveCurrency = currenciesList[onSelectedItemChanged];
              print(selectiveCurrency);
            });
          },
          children: iosNewList
          // Text('USD'),
          // Text('GBP'),
          // Text('EUR'),
          ),
    );
  }
}

class coinWidget extends StatelessWidget {
  coinWidget(this.selectiveCurrency, this.cryptoCurrency);
  final String cryptoCurrency;
  final String selectiveCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: FutureBuilder(
            future: exchangeData(selectiveCurrency, cryptoCurrency),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return Text('$cryptoCurrency = ${snapshot.data}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ));
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}

Future<String> exchangeData(String currencypair, String cryptopair) async {
  // final response = await http.get(Uri.parse(
  //     'https://rest.coinapi.io/v1/exchangerate/$cryptopair/$currencypair?apikey=$apikey'));
  final weatherres = await http.get(Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?lat=$currencypair&lon=$cryptopair&appid=$weatherapi'));
  print(weatherres.statusCode);
  final exchangePrice = jsonDecode(weatherres.body)['weather'][0]['main'];
  if (weatherres.statusCode == 200) {
    return exchangePrice;
  } else {
    return 'Value Errorrr';
  }
}













// DropdownButton(
//               value: selectiveCurrency,
//               items: coinList
//               // DropdownMenuItem(
//               //   child: Text('USD'),
//               //   value: 'USD',
//               // )

//               ,
//               onChanged: ((value) {
//                 setState(() {
//                   selectiveCurrency = value;
//                 });

//                 print(value);
//               }),
//             )