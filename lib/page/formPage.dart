// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables, prefer_const_constructors, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_isoja/global/color.dart';
import 'package:flutter_isoja/page/settingPage.dart';
import 'package:google_fonts/google_fonts.dart';

class FormPage extends StatefulWidget {
  final BluetoothDevice device;

  const FormPage({
    Key? key,
    required this.device,
  }) : super(key: key);
  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  late BluetoothCharacteristic targetChar;
  String jsonString = '';
  String ssid = '';
  String pass = '';
  String link = '';
  final ssidController = TextEditingController();
  final passController = TextEditingController();
  final linkController = TextEditingController();

  @override
  void initState() {
    discoverTes();
    super.initState();
  }

  discoverTes() async {
    List<BluetoothService> services = await widget.device.discoverServices();
    services.forEach((service) {
      if (service.uuid.toString() == service.uuid.toString()) {
        service.characteristics.forEach((char) async {
          if (char.uuid.toString() == char.uuid.toString()) {
            targetChar = char;
            setState(() {});
          }
        });
      }
    });
  }

  void openLoading(BuildContext context, [bool mounted = true]) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return Dialog(
            // The background color
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  // The loading indicator
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 15,
                  ),
                  // Some text
                  Text('Loading...')
                ],
              ),
            ),
          );
        });
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  void convertWifi() {
    ssid = ssid.replaceAll(RegExp(r'\s'), "");
    pass = pass.replaceAll(RegExp(r'\s'), "");
    link = link.replaceAll(RegExp(r'\s'), "");
    jsonString = '{"S":"$ssid"},{"PW":"$pass"},{"f":"$link"}';
  }

  void sendWifi() async {
    ssid = ssidController.text;
    pass = passController.text;
    link = linkController.text;
    convertWifi();
    targetChar.write(utf8.encode('8'), withoutResponse: true);
    await Future.delayed(Duration(seconds: 3));
    targetChar.write(utf8.encode(jsonString));
    ssidController.clear();
    passController.clear();
    linkController.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Setting(device: widget.device)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        return Scaffold(
          backgroundColor: bg,
          appBar: AppBar(
            toolbarHeight: (height * 0.1),
            backgroundColor: base,
            title: const Text("Submit Sound"),
            centerTitle: true,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Container(
            height: 50,
            margin: const EdgeInsets.all(10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: base,
              ),
              onPressed: sendWifi,
              child: Center(child:  Text("Submit",style: GoogleFonts.inter(fontSize: 20,fontWeight: FontWeight.bold,color: bg),)),
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  Container(
                    decoration: BoxDecoration(
                        color: fieldBgColor,
                        borderRadius: BorderRadius.all(Radius.circular(13))),
                    child: TextFormField(
                      onChanged: (value) {
                        setState(() {
                          value = jsonString.trim();
                        });
                      },
                      controller: ssidController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Container(
                              width: width * 0.13,
                              margin: const EdgeInsets.only(
                                right: 10.0,
                              ),
                              decoration: BoxDecoration(
                                  color: base,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(13))),
                              child: Icon(Icons.wifi,
                                  color: Color.fromARGB(255, 199, 199, 199))),
                          hintText: "Enter Your Wifi Name"),
                    ),
                  ),
                  Divider(
                    color: Colors.transparent,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: fieldBgColor,
                        borderRadius: BorderRadius.all(Radius.circular(13))),
                    child: TextFormField(
                      onChanged: (value) {
                        setState(() {
                          value = jsonString.trim();
                        });
                      },
                      controller: passController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Container(
                              width: width * 0.13,
                              margin: const EdgeInsets.only(
                                right: 10.0,
                              ),
                              decoration: BoxDecoration(
                                  color: base,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(13))),
                              child: Icon(Icons.lock,
                                  color: Color.fromARGB(255, 199, 199, 199))),
                          hintText: "Enter Your Wifi Password"),
                    ),
                  ),
                  Divider(
                    color: Colors.transparent,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: fieldBgColor,
                        borderRadius: BorderRadius.all(Radius.circular(13))),
                    child: TextFormField(
                      onChanged: (value) {
                        setState(() {
                          value = jsonString.trim();
                        });
                      },
                      controller: linkController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Container(
                              width: width * 0.13,
                              margin: const EdgeInsets.only(
                                right: 10.0,
                              ),
                              decoration: BoxDecoration(
                                  color: base,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(13))),
                              child: Icon(Icons.link,
                                  color: Color.fromARGB(255, 199, 199, 199))),
                          hintText: "Enter Your Link"),
                    ),
                  ),
                  Divider(
                    color: Colors.transparent,
                  ),
                  Text(
                    'Enter Your Link/Previous Link',
                    style: TextStyle(color: base),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
