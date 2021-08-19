import 'package:atc_kw/data.dart';
import 'package:atc_kw/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'utils/constants.dart';

void main() {
  runApp(App());
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String primaryColorHex = "139A7A";
    String colorFabIcon = "f0d765";
    String colorAccent = "f0851a";
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
      navigatorObservers: [routeObserver],
      theme: ThemeData(
          primaryColor: Color(int.parse("0xff$colorPrimary")),
          scaffoldBackgroundColor: Colors.white,
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              )),
    );
  }
}
