import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_isoja/page/settingPage.dart';
import 'package:flutter_isoja/widget.dart';
import 'package:google_fonts/google_fonts.dart';

class ConnectView extends StatefulWidget {
  ConnectView({super.key});

  @override
  State<ConnectView> createState() => _ConnectViewState();
}

class _ConnectViewState extends State<ConnectView> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  BluetoothDevice? connectedDevice;
  List<BluetoothDevice> devicesList = [];
  List<BluetoothService> services = [];

  //! COLOR
  @override
  final Color _baseColor = Color.fromRGBO(42, 50, 75, 1);
  final Color baseColor12 = Color.fromRGBO(42, 50, 75, 0.13);
  final Color textColor = Color.fromRGBO(42, 50, 75, 0.8);
  final Color bgColor = Color.fromRGBO(252, 252, 252, 1);
  final Color powerOn = Color.fromRGBO(36, 169, 108, 1);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final height = constraints.maxHeight;
      final width = constraints.maxWidth;
      return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          toolbarHeight: (constraints.maxHeight * 0.1),
          backgroundColor: _baseColor,
          title: Text(
            "ISOJA",
            style: GoogleFonts.michroma(
                textStyle: TextStyle(fontSize: 32),
                fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.bluetooth),
              iconSize: (width * 0.1),
              tooltip: "Save Todo and Retrun to List",
              onPressed: () {
                try {
                  flutterBlue.startScan(timeout: Duration(seconds: 4));
                } catch (e) {
                  debugPrint('$e');
                }
              },
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () => FlutterBlue.instance
              .startScan(timeout: const Duration(seconds: 4)),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                StreamBuilder<List<BluetoothDevice>>(
                  stream: Stream.periodic(const Duration(seconds: 2))
                      .asyncMap((_) => FlutterBlue.instance.connectedDevices),
                  initialData: const [],
                  builder: (c, snapshot) => Column(
                    children: snapshot.data!
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
                                      style: ElevatedButton.styleFrom(
                                        primary: powerOn,
                                      ),
                                      child: const Text('OPEN'),
                                      onPressed: () => Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  Setting(device: d))),
                                    );
                                  }
                                  return Text(snapshot.data.toString());
                                },
                              ),
                            ))
                        .toList(),
                  ),
                ),
                StreamBuilder<List<ScanResult>>(
                  stream: FlutterBlue.instance.scanResults,
                  initialData: const [],
                  builder: (c, snapshot) => Column(
                    children: snapshot.data!
                        .map(
                          (r) => ScanResultTile(
                              result: r,
                              onTap: () async {
                                await r.device.connect();
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return Setting(device: r.device);
                                }));
                              }),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
