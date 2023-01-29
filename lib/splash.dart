import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_home_lighting_system/home.dart';

import 'ble/services/bluetooth.dart';
import 'ble/services/shared_pref.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration(seconds: 1),(){
      Navigator.pop(context);
      Navigator.push(context,MaterialPageRoute(builder: (context)=>MultiProvider(
          providers: [
            Provider(
              create: (_) => BluetoothService(),
            ),
            Provider(
              create: (_) => SharedPrefService(),
            )
          ],
          child: HomePage()
      )));
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.bluetooth,color: Colors.white,size: 200,),
          LinearProgressIndicator()
        ],
      ),
    );
  }
}
