import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_isoja/global/color.dart';
import 'package:flutter_isoja/widget/widgetSetting.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

//! boolean
bool switchStatus = false;
bool switchStatusPlay = false;

//!double
double sliderValue = 0.0;

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
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: bg,
      appBar: appbarContent(context, height, width),
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
                            switchStatus = !switchStatus;
                            switchStatusPlay = false;
                          });
                        },
                        child: cardNoise(width)),
                    InkWell(
                        onTap: () {
                          setState(() {
                            switchStatusPlay = !switchStatusPlay;
                            switchStatus = false;
                          });
                        },
                        child: cardPlayMusic(width)),
                  ],
                )),
            const Divider(
              height: 16,
              color: Colors.transparent,
            ),
            Expanded(
                flex: 2,
                child: Container(
                  child: cardVolume(width),
                )),
            const Divider(
              height: 30,
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
                      buttonUploadd(width: width),
                      buttonDelete(width: width),
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
                                child: SizedBox(
                                  width: width,
                                  height: width / 5,
                                  child: CarouselSlider(
                                    options: CarouselOptions(
                                      enlargeCenterPage: true,
                                      enableInfiniteScroll: false,
                                      autoPlay: false,
                                    ),
                                    items: <Widget>[
                                      songList(width: width),
                                      songList(width: width),
                                      songList(width: width),
                                      
                                    ],
                                  ),
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
                                      onTap: () {},
                                    ),
                                    InkWell(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(100.0),
                                      ),
                                      child: Icon(
                                          Icons.play_circle_fill_rounded,
                                          size: width * 0.18,
                                          color: base),
                                      onTap: () {},
                                    ),
                                    InkWell(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(100.0),
                                      ),
                                      child: Icon(Icons.skip_next,
                                          size: width * 0.15, color: base),
                                      onTap: () {},
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
          onPressed: (() {}),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(
                  Icons.repeat_rounded,
                  size: 32,
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
                      value: sliderValue,
                      onChanged: (value) {
                        setState(() {
                          value = sliderValue;
                        });
                      }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.add_circle_rounded,
                            size: 40,
                            color: base,
                          )),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.remove_circle_rounded,
                            size: 40,
                            color: base,
                          ))
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
            color: switchStatusPlay ? base : disable,
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
                    color: switchStatusPlay ? bg : base,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Play Music",
                        style: GoogleFonts.inter(
                            color: switchStatusPlay ? bg : base,
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
                        value: switchStatusPlay,
                        onToggle: (value) {
                          setState(() {
                            switchStatusPlay = value;
                            switchStatus = false;
                          });
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
            color: switchStatus ? base : disable,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        duration: const Duration(milliseconds: 400),
        child: SizedBox(
          width: width / 2.3,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.multitrack_audio_rounded,
                    size: width / 4.6,
                    color: switchStatus ? bg : base,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Noise",
                        style: GoogleFonts.inter(
                            color: switchStatus ? bg : base,
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
                        value: switchStatus,
                        onToggle: (value) {
                          setState(() {
                            switchStatus = value;
                            switchStatusPlay = false;
                          });
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

  AppBar appbarContent(BuildContext context, double height, double width) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      toolbarHeight: (height * 0.1),
      backgroundColor: base,
      title: const Text('Esp_device_1'),
      actions: <Widget>[
        IconButton(
          color: bg,
          icon: const Icon(Icons.power_settings_new),
          iconSize: (width * 0.1),
          tooltip: "On/Off",
          onPressed: () {
            // setState(() {
            //   power = !power;
            // });
          },
        ),
        IconButton(
            icon: Icon(Icons.lightbulb),
            color: bg,
            iconSize: (width * 0.1),
            tooltip: "Save Todo and Retrun to List",
            onPressed: () {
              //lampStats
            }),
      ],
    );
  }
}

class songList extends StatelessWidget {
  const songList({
    Key? key,
    required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print("dadc");
      },
      child: SizedBox(
        width: width,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
                    16), // <-- Radius
          ),
          color: base,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(
                    horizontal: 16.0),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,
              children: [
                Text(
                  "Song 1",
                  style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.bold,
                      color: disable),
                ),
                Icon(
                  Icons.play_arrow_rounded,
                  size: width * 0.1,
                  color: disable ,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
