import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_isoja/global/color.dart';
import 'package:flutter_isoja/widget/widgetSetting.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';

class Setting extends StatefulWidget {
  final BluetoothDevice device;
  const Setting({super.key, required this.device});

  @override
  State<Setting> createState() => _SettingState();
}

//late
late BluetoothCharacteristic targetChar;
TextEditingController valueController = TextEditingController();
final CarouselController carouselController = CarouselController();

//string
String receive = '';
String value = '';
String jsonString = '';
String? selectedValue;

//list
List<String> receiving = [];

//! boolean
bool power = false;
bool lamp = false;
bool music = false;
bool stream = false;
bool sliderEnable = false;
bool retry = false;

//!double
double sliderValue = 0.0;
double counter = 0;
double counter2 = 0;

//time
Timer? timer;

//int
int count = 0;

final List<String> imageList = [
  "https://www.setaswall.com/wp-content/uploads/2018/08/Spiderman-Wallpaper-76-1280x720.jpg",
  "https://lh3.googleusercontent.com/proxy/yL2FmQfZA79S5eIDza9MH2NjKGIKWPOGRHxHdYwiNPcYDW26YmK6qnP01ZDLsBENZpiADc1ohkj3LzVjrwoX8Pb-crT6MYZb3Jp9gy3ZrlET_yvoFS0qtUHLq4DtVPcqIdxPiNWI_j08omBVACv-YJc",
  "https://images.hdqwalls.com/download/spiderman-peter-parker-standing-on-a-rooftop-ix-1280x720.jpg",
  "https://images.wallpapersden.com/image/download/peter-parker-spider-man-homecoming_bGhsa22UmZqaraWkpJRmZ21lrWxnZQ.jpg",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSvUgui-suS8DgaljlONNuhy4vPUsC_UKvxJQ&usqp=CAU",
];

//!Color Pallate Massbro
class _SettingState extends State<Setting> {
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
            char.value.listen((value) {
              String dat = utf8.decode(value);
              if (dat.endsWith('.mp3') ||
                  dat.endsWith('.aac') ||
                  dat.endsWith('.mpeg') ||
                  dat.endsWith('.wav')) {
                setState(() {
                  receiving.add(dat);
                  if (receiving.length > 3) {
                    receiving.removeAt(0);
                  }
                });
              }
            });
            setState(() {});
          }
        });
      }
    });
  }

  Future<void> displayInput(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Write title'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  value = jsonString.trim();
                });
              },
              controller: valueController,
              decoration: const InputDecoration(hintText: "title"),
            ),
            actions: <Widget>[
              ElevatedButton(child: const Text('OK'), onPressed: sendJsonToEsp),
            ],
          );
        });
  }

  void sendJsonToEsp() async {
    value = valueController.text;
    convertInputToJson();
    Navigator.pop(context);
    writeData('8');
    await Future.delayed(const Duration(seconds: 3));
    sendJsonString(jsonString);
    valueController.clear();
  }

  Future<void> sendJsonString(String jsonString) async {
    Uint8List json = utf8.encode(jsonString) as Uint8List;
    targetChar.write(json);
  }

  void convertInputToJson() {
    value = value.replaceAll(RegExp(r'\s'), "");
    jsonString = '{"DLT":"$value"}';
  }

  void startRead() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      receiveData();
      setState(() {
        count++;
        if (count >= 1) {
          stopingTimer();
        }
      });
    });
  }

  void stopingTimer() {
    timer?.cancel();
  }

  void openLoading(BuildContext context, [bool mounted = true]) async {
    if (stream || music) {
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
  }

  void addCounter(String pluses) {
    if (counter + 0.1 <= 1.0) {
      setState(() {
        counter += 0.1;
      });
    }
    Uint8List plus = utf8.encode(pluses) as Uint8List;
    targetChar.write(plus, withoutResponse: true);
  }

  void subtractCounter(String mineses) {
    if (counter - 0.1 >= 0.0) {
      setState(() {
        counter -= 0.1;
      });
    }
    Uint8List mines = utf8.encode(mineses) as Uint8List;
    targetChar.write(mines, withoutResponse: true);
  }

  writeData(String data) {
    try {
      List<int> bytes = utf8.encode(data);
      targetChar.write(bytes, withoutResponse: true);
      setState(() {});
    } catch (e) {
      debugPrint('$e');
    }
  }

  void lampStats() {
    if (lamp == true) {
      writeData('b');
    } else {
      writeData('a\n');
    }
    setState(() {
      lamp = !lamp;
    });
    debugPrint('$lamp');
  }

  Future<void> sendOnMessageToBluetooth(String message) async {
    writeData('8');
    await Future.delayed(const Duration(seconds: 3));
    List<int> data = utf8.encode(message);
    targetChar.write(data, withoutResponse: true);
  }

  sendOffMessage(String message) async {
    List<int> data = utf8.encode(message);
    targetChar.write(data, withoutResponse: true);
  }

  receiveData() async {
    try {
      List<int> value = await targetChar.read();
      receive = utf8.decode(value).trim();
      setState(() {});
    } catch (e) {
      debugPrint('$e');
    }
  }

  sendConvert() {
    List<int> json = utf8.encode('/${selectedValue?.trim()}');
    targetChar.write(json);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: bg,
      appBar: appbarContent(context, height, width, lampStats),
      // ignore: avoid_unnecessary_containers
      body: Container(
        margin: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                        onTap: () {
                          setState(() {
                            stream = !stream;
                            // sliderEnable = false;
                            music = false;
                          });
                          openLoading(context);
                          if (stream == true) {
                            sendOnMessageToBluetooth('o\n');
                          } else if (stream == false) {
                            writeData('8\n');
                          }
                        },
                        child: cardNoise(width)),
                    InkWell(
                        onTap: () {
                          setState(() {
                            music = !music;
                            // sliderEnable = false;
                            stream = false;
                          });
                          openLoading(context);
                          if (music == true) {
                            // sendOnMessageToBluetooth('1\n').then((_) {
                            // });
                            startRead();
                          } else if (music == false) {
                            sendOffMessage('5\n').then((_) {
                              stopingTimer();
                            });
                          }
                        },
                        child: cardPlayMusic(width)),
                  ],
                )),
            Divider(
              height: height / 45,
              color: Colors.transparent,
            ),
            Expanded(
                flex: 2,
                child: Container(
                  child: cardVolume(width),
                )),
            Divider(
              height: height / 50,
              color: Colors.transparent,
            ),
            Expanded(
                flex: 1,
                // ignore: avoid_unnecessary_containers
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      buttonRepeat(width),
                      buttonUploadd(
                        width: width,
                        device: widget.device,
                      ),
                      buttonDelete(
                        width: width,
                        device: widget.device,
                        displayInput: () {
                          displayInput(context);
                        },
                      ),
                    ],
                  ),
                )),
            const Divider(
              height: 10,
              color: Colors.transparent,
            ),
            Expanded(
                flex: 3,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Card(
                    color: disable,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 10,
                    child: SizedBox(
                      width: width,
                      child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 2,
                                child: receiving.isNotEmpty
                                    ? SizedBox(
                                        width: width,
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                16), // <-- Radius
                                          ),
                                          color: base,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                            child: CarouselSlider.builder(
                                              itemCount: receiving.length,
                                              carouselController:
                                                  carouselController,
                                              itemBuilder:
                                                  (context, index, realindex) {
                                                return Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 16.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        receiving[index],
                                                        style:
                                                            GoogleFonts.inter(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: disable),
                                                      ),
                                                      Icon(
                                                        Icons
                                                            .play_arrow_rounded,
                                                        size: width * 0.1,
                                                        color: disable,
                                                      )
                                                    ],
                                                  ),
                                                );
                                              },
                                              options: CarouselOptions(
                                                  height: 400.0,
                                                  enableInfiniteScroll: false,
                                                  enlargeCenterPage: true,
                                                  autoPlay: false,
                                                  initialPage: 1,
                                                  onPageChanged:
                                                      (index, reason) {
                                                    setState(() {
                                                      selectedValue =
                                                          receiving[index];
                                                    });
                                                  }),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Center(
                                        child: Text('tidak ada data'),
                                      ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    InkWell(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(100.0),
                                      ),
                                      child: Icon(Icons.skip_previous,
                                          size: width * 0.15, color: base),
                                      onTap: () {
                                        carouselController.previousPage(
                                            duration:
                                                Duration(milliseconds: 300),
                                            curve: Curves.linear);
                                      },
                                    ),
                                    InkWell(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(100.0),
                                      ),
                                      child: Icon(
                                          Icons.play_circle_fill_rounded,
                                          size: width * 0.18,
                                          color: base),
                                      onTap: () {
                                        sendConvert();
                                      },
                                    ),
                                    InkWell(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(100.0),
                                      ),
                                      child: Icon(Icons.skip_next,
                                          size: width * 0.15, color: base),
                                      onTap: () {
                                        carouselController.nextPage(
                                            duration:
                                                Duration(milliseconds: 300),
                                            curve: Curves.linear);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  SizedBox buttonRepeat(double width) {
    return SizedBox(
      width: width / 4,
      height: width / 5,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16), // <-- Radius
            ),
            primary: base,
          ),
          onPressed: () {
            writeData('r\n');
            setState(() {
              retry = !retry;
            });
          },
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  Icons.repeat_rounded,
                  size: 32,
                  color: retry ? powerOn : fieldBgColor,
                ),
                Text(
                  "Repeat",
                  style: GoogleFonts.inter(
                      color: bg, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
          )),
    );
  }

  Card cardVolume(double width) => Card(
        color: disable,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 10,
        child: Container(
          width: width,
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Volume",
                    style: GoogleFonts.inter(
                        color: base, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Slider(
                      min: 0,
                      max: 1.0,
                      divisions: 100,
                      activeColor: base,
                      inactiveColor: bg,
                      value: counter,
                      onChanged: (value) {
                        setState(() {
                          value = counter;
                        });
                      }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          stream || music
                              ? addCounter(counter.toStringAsFixed(1))
                              : null;
                        },
                        child: Icon(
                          Icons.add_circle,
                          size: 33.5,
                        ),
                      ),
                      VerticalDivider(),
                      InkWell(
                        onTap: () {
                          stream || music
                              ? subtractCounter(counter.toStringAsFixed(1))
                              : null;
                        },
                        child: Icon(
                          Icons.remove_circle,
                          size: 33.5,
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        ),
      );

  Card cardPlayMusic(double width) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 10,
      child: AnimatedContainer(
        decoration: BoxDecoration(
            color: music ? base : disable,
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        duration: const Duration(milliseconds: 400),
        child: SizedBox(
          width: width / 2.3,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.music_note,
                    size: width / 4.6,
                    color: music ? bg : base,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Play Music",
                        style: GoogleFonts.inter(
                            color: music ? bg : base,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      FlutterSwitch(
                        activeToggleColor: base,
                        toggleColor: disable,
                        activeColor: disable,
                        inactiveColor: bg,
                        width: width / 8,
                        height: width * 0.07,
                        value: music,
                        onToggle: (value) {
                          setState(() {
                            music = value;
                            stream = false;
                          });
                          openLoading(context);
                          if (music == true) {
                            sendOnMessageToBluetooth('1\n').then((_) {
                              startRead();
                            });
                          } else if (music == false) {
                            sendOffMessage('5\n').then((_) {
                              stopingTimer();
                            });
                          }
                        },
                      )
                    ],
                  )
                ]),
          ),
        ),
      ),
    );
  }

  Card cardNoise(double width) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 10,
      child: AnimatedContainer(
        decoration: BoxDecoration(
            color: stream ? base : disable,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        duration: const Duration(milliseconds: 400),
        child: SizedBox(
          width: width / 2.4,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.multitrack_audio_rounded,
                    size: width / 4.6,
                    color: stream ? bg : base,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Stream",
                        style: GoogleFonts.inter(
                            color: stream ? bg : base,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      FlutterSwitch(
                        activeToggleColor: base,
                        toggleColor: disable,
                        activeColor: disable,
                        inactiveColor: bg,
                        width: width / 8,
                        height: width * 0.07,
                        value: stream,
                        onToggle: (value) {
                          setState(() {
                            stream = value;
                            music = false;
                          });
                          openLoading(context);
                          if (stream == true) {
                            sendOnMessageToBluetooth('o\n');
                          } else if (stream == false) {
                            writeData('8\n');
                          }
                        },
                      )
                    ],
                  )
                ]),
          ),
        ),
      ),
    );
  }

  AppBar appbarContent(
      BuildContext context, double height, double width, void lampStats()) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      toolbarHeight: (height * 0.1),
      backgroundColor: base,
      title: Text(widget.device.name),
      actions: <Widget>[
        IconButton(
          color: power ? powerOn : disableBaseColor,
          icon: const Icon(Icons.power_settings_new),
          iconSize: (width * 0.1),
          onPressed: () {
            if (power == true) {
              sendOffMessage('off');
            } else {
              sendOnMessageToBluetooth('on');
            }
            setState(() {
              power = !power;
            });
          },
        ),
        IconButton(
            icon: const Icon(Icons.lightbulb),
            color: lamp ? lampOn : fieldBgColor,
            iconSize: (width * 0.1),
            onPressed: lampStats),
      ],
    );
  }
}
