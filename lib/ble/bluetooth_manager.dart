// Copyright 2017, Paul DeMarco.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:convert';
import 'widgets.dart';

class BluetoothManager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.red,
      home: StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            if (state == BluetoothState.on) {
              return FindDevicesScreen();
            }
            return BluetoothOffScreen(state: state);
          }),
    );
  }
}

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key? key, this.state}) : super(key: key);

  final BluetoothState? state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.white54,
            ),
            Text(
                'Bluetooth Adapter is ${state != null ? state.toString().substring(15) : 'not available'}.'),
          ],
        ),
      ),
    );
  }
}

class FindDevicesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Devices'),
        backgroundColor: Colors.red,
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            FlutterBlue.instance.startScan(timeout: const Duration(seconds: 4)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<List<BluetoothDevice>>(
                stream: Stream.periodic(const Duration(seconds: 2))
                    .asyncMap((_) => FlutterBlue.instance.connectedDevices),
                initialData: const [],
                builder: (c, snapshot) {
                  if (snapshot.data != null){
                    return Column(
                      children: snapshot!.data!
                          .map((d) => ListTile(
                        title: Text(d.name),
                        subtitle: Text(d.id.toString()),
                        trailing: StreamBuilder<BluetoothDeviceState>(
                          stream: d.state,
                          initialData: BluetoothDeviceState.disconnected,
                          builder: (c, snapshot) {
                            if (snapshot.data ==
                                BluetoothDeviceState.connected) {
                              return ElevatedButton(
                                child: const Text('OPEN'),
                                onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DeviceScreen(device: d))),
                              );
                            }
                            return Text(snapshot.data.toString());
                          },
                        ),
                      ))
                          .toList(),
                    );
                  }
                  else{
                    return Text('Loading...');
                  }
                  },
              ),
              StreamBuilder<List<ScanResult>>(
                stream: FlutterBlue.instance.scanResults,
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data!
                      .map(
                        (r) => ScanResultTile(
                          result: r,
                          onTap: () => Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            r.device.connect();
                            return DeviceScreen(device: r.device);
                          })),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBlue.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data!) {
            return FloatingActionButton(
              child: const Icon(Icons.stop),
              onPressed: () => FlutterBlue.instance.stopScan(),
              backgroundColor: Colors.red,
            );
          } else {
            return FloatingActionButton(
                child: const Icon(Icons.search),
                backgroundColor: Colors.red,
                onPressed: () => FlutterBlue.instance
                    .startScan(timeout: const Duration(seconds: 4)));
          }
        },
      ),
    );
  }
}

class DeviceScreen extends StatelessWidget {
  const DeviceScreen({Key? key, required this.device}) : super(key: key);

  final BluetoothDevice device;

  void writeData(List<BluetoothService> services, String str) async {
    for (BluetoothService service in services) {
      var characteristics = service.characteristics;
      for (BluetoothCharacteristic c in characteristics) {
        var charData = List.empty(growable: true);
        for(int i =0;i<=str.length-1;i++)
        {
          print(str[i]);
          charData.add(str[i]);

        }
        print(charData);

        var alphaMap = {
          "0":48,
          "1":49,
          "2":50,
          "3":51,
          "4":52,
          "5":53,
          "6":54,
          "7":55,
          "8":56,
          "9":57,
          "a": 0x61,
          "b": 0x62,
          "c":0x63,
          "d":0x64,
          "e":0x65,
          "f":0x66,
          "g":0x67,
          "h":0x68,
          "i":0x69,
          "j":0x6a,
          "k":0x6b,
          "l":0x6c,
          "m":0x6d,
          "n":0x6e,
          "o":0x6f,
          "p":0x70,
          "q":0x71,
          "r":0x72,
          "s":0x73,
          "t":0x74,
          "u":0x75,
          "v":0x76,
          "w":0x77,
          "x":0x78,
          "y":0x79,
          "z":0x7a,
          ",":0x2c,
          "A":0x41,
          "B":0x42,
          "C":0x43,
          "D":0x44,
          "E":0x45,
          "F":0x46,
          "G":0x47,
          "H":0x48,
          "I":0x49,
          "J":0x4a,
          "K":0x4b,
          "L":0x4c,
          "M":0x4d,
          "N":0x4e,
          "O":0x4f,
          "P":0x50,
          "Q":0x51,
          "R":0x52,
          "S":0x53,
          "T":0x54,
          "U":0x55,
          "V":0x56,
          "W":0x57,
          "X":0x58,
          "Y":0x59,
          "Z":0x5a,
          "~":0x7e,
        };

        var data=List.empty(growable: true);

        for(String s in charData)
        {
          data.add(alphaMap[s]);
        }
        print(data);

        List<int> value = await c.read();
        print(value);

        var response = await c.write(utf8.encode(str));

        print(response);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(device.name),
        actions: <Widget>[
          StreamBuilder<BluetoothDeviceState>(
            stream: device.state,
            initialData: BluetoothDeviceState.connecting,
            builder: (c, snapshot) {
              VoidCallback? onPressed;
              String text;
              switch (snapshot.data) {
                case BluetoothDeviceState.connected:
                  onPressed = () => device.disconnect();
                  text = 'DISCONNECT';
                  break;
                case BluetoothDeviceState.disconnected:
                  onPressed = () => device.connect();
                  text = 'CONNECT';
                  break;
                default:
                  onPressed = null;
                  text = snapshot.data.toString().substring(21).toUpperCase();
                  break;
              }
              return ElevatedButton(
                  onPressed: onPressed,
                  child: Text(
                    text,
                    style: Theme.of(context)
                        .primaryTextTheme
                        .button
                        ?.copyWith(color: Colors.white),
                  ));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            StreamBuilder<BluetoothDeviceState>(
              stream: device.state,
              initialData: BluetoothDeviceState.connecting,
              builder: (c, snapshot) => ListTile(
                leading: (snapshot.data == BluetoothDeviceState.connected)
                    ? const Icon(Icons.bluetooth_connected)
                    : const Icon(Icons.bluetooth_disabled),
                title: Text(
                    'Device is ${snapshot.data.toString().split('.')[1]}.'),
                subtitle: Text('${device.id}'),
                trailing: StreamBuilder<bool>(
                  stream: device.isDiscoveringServices,
                  initialData: false,
                  builder: (c, snapshot) => IndexedStack(
                    index: snapshot.data! ? 1 : 0,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () => device.discoverServices(),
                      ),
                      const IconButton(
                        icon: SizedBox(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.grey),
                          ),
                          width: 18.0,
                          height: 18.0,
                        ),
                        onPressed: null,
                      )
                    ],
                  ),
                ),
              ),
            ),
            StreamBuilder<List<BluetoothService>>(
              stream: device.services,
              initialData: [],
              builder: (c, snapshot) {
                return ListTile(
                  title: const Text('Enable Motion Sensor'),
                  trailing: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        device.discoverServices();
                        writeData(snapshot.data!, "em");
                      }),

                );
              },
            ),
            StreamBuilder<List<BluetoothService>>(
              stream: device.services,
              initialData: [],
              builder: (c, snapshot) {
                return ListTile(
                  title: const Text('Disable Motion Sensor'),
                  trailing: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        device.discoverServices();
                        writeData(snapshot.data!, "dm");
                      }),

                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
