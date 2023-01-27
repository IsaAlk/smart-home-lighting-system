import 'package:flutter/material.dart';

import 'ble/bluetooth_manager.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Smart Home Lighting System',
          ),
          backgroundColor: Colors.red,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Align(
            //     alignment: Alignment.center,
            //     child: ElevatedButton(
            //       child: const Text("Accelerometer Data"),
            //       style: ElevatedButton.styleFrom(
            //         onPrimary: Colors.white,
            //         primary: Colors.blue,
            //         onSurface: Colors.grey,
            //         side: BorderSide(color: Colors.black, width: 1),
            //         elevation: 60,
            //         minimumSize: Size(200, 50),
            //       ),
            //       onPressed: () {
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) => AccelerometerPage()),
            //         );
            //       },
            //     )),
            // const SizedBox(
            //   height: 15,
            // ),
            // Align(
            //     alignment: Alignment.center,
            //     child: ElevatedButton(
            //       child: Text("Gyroscope Data"),
            //       style: ElevatedButton.styleFrom(
            //         onPrimary: Colors.white,
            //         primary: Colors.blue,
            //         onSurface: Colors.grey,
            //         side: BorderSide(color: Colors.black, width: 1),
            //         elevation: 60,
            //         minimumSize: Size(200, 50),
            //       ),
            //       onPressed: () {
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(builder: (context) => GyroscopePage()),
            //         );
            //       },
            //     )),

            Image.asset('assets/images/Middlesex.png', fit: BoxFit.scaleDown), //   <-- image

            const SizedBox(
              height: 450,
            ),
            Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  child: Text("Connect to Devices"),
                  style: ElevatedButton.styleFrom(
                    onPrimary: Colors.white,
                    primary: Colors.red,
                    onSurface: Colors.grey,
                    side: BorderSide(color: Colors.black, width: 1),
                    elevation: 60,
                    minimumSize: Size(200, 50),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BluetoothManager()),
                    );
                  },
                ))
          ],
        ));
  }
}
