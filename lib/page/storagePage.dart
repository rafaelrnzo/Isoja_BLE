// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:dotted_border/dotted_border.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_isoja/global/color.dart';
import 'package:flutter_isoja/page/FormPage.dart';

class AudioItem {
  final String name;

  AudioItem({required this.name});
}

class StoragePage extends StatefulWidget {
  final BluetoothDevice device;
  const StoragePage({
    Key? key,
    required this.device,
  }) : super(key: key);

  @override
  State<StoragePage> createState() => _StoragePageState();
}

class _StoragePageState extends State<StoragePage> {
  late BluetoothCharacteristic targetChar;
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  String accessToken = '82ec93a05b8cd3248d7ffd5d16f53bee1ecff7ab';
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  List<AudioItem> audioList = [];

  @override
  void initState() {
    discoverTes();
    akses();
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

  Future<void> displayDelete(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Center(child: Text('Choose Method Delete')),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('lagu tidak bisa lebih dari 3'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                        ),
                        onPressed: () {
                          displayChoose(context);
                        },
                        child: const Text("choose"),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                        ),
                        onPressed: () async {
                          await deleteLatestAudio();
                          Navigator.pop(context);
                        },
                        child: const Text("auto"),
                      ),
                    ],
                  ),
                  const Text(
                    '*fitur auto akan menghapus otomatis file terlama dalam database',
                    style: TextStyle(fontSize: 10),
                    textAlign: TextAlign.center,
                  )
                ],
              ));
        });
  }

  Future<void> displayChoose(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Center(child: Text('Choose Song To Delete')),
              content: Container(
                child: ListView.builder(
                  itemCount: audioList.length,
                  itemBuilder: (context, index) {
                    AudioItem audio = audioList[index];
                    return Dismissible(
                        key: Key(audio.name),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          setState(() {
                            deleteAudio('files/${audio.name}');
                            setState(() {});
                            audioList.removeAt(index);
                            setState(() {});
                          });
                        },
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.all(20.0),
                          color: Colors.red,
                          child: const Icon(
                            Icons.delete,
                            size: 24.0,
                            color: Colors.white,
                          ),
                        ),
                        child: ListTile(
                          title: Text(audio.name),
                          onTap: () {
                            setState(() {});
                          },
                        ));
                  },
                ),
              ));
        });
  }

  Future<void> deleteAudio(String ref) async {
    await firebaseStorage.ref(ref).delete();
    setState(() {});
  }

  Future<void> deleteLatestAudio() async {
    final String latestAudioPath = await findLatestAudio();
    final Reference audioRef =
        firebaseStorage.ref().child('files/$latestAudioPath');
    print(audioRef);
    await audioRef.delete();
  }

  Future<String> findLatestAudio() async {
    final Reference audioRef = firebaseStorage.ref().child('files/');
    List<Reference> audioFiles = [];
    (await audioRef.listAll()).items.forEach((itemRef) {
      audioFiles.add(itemRef);
    });
    audioFiles.sort((a, b) => b.name.compareTo(a.name));
    print(audioFiles.first.name);
    return audioFiles.first.name;
  }

  Future uploadFile() async {
    final path = 'files/${pickedFile?.name}';
    if (pickedFile != null) {
      final file = File(pickedFile!.path!);
      final ref = firebaseStorage.ref().child(path);
      uploadTask = ref.putFile(file);
      final snapshot = await uploadTask!.whenComplete(() {});
      var urlDownload = await snapshot.ref.getDownloadURL();
      print(urlDownload);
      return urlDownload;
    }
  }

  void akses() async {
    final Reference ref = firebaseStorage.ref().child('files/');
    ref.list(const ListOptions(maxResults: 3)).then((result) {
      for (Reference reference in result.items) {
        audioList.add(AudioItem(name: reference.name));
      }
      setState(() {});
    });
  }

  Future selectFile() async {
    try {
      final result = await FilePicker.platform.pickFiles();
      if (result == null) return;
      setState(() {
        pickedFile = result.files.first;
      });
    } catch (e) {
      print('error $e');
    }
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
            title: const Text('Storage'),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: akses,
                icon: const Icon(
                  Icons.refresh,
                  size: 24.0,
                ),
              ),
            ],
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FormPage(
                            device: widget.device,
                          )),
                );
              },
              child: const Center(child: Text("Download By Your Own Url")),
            ),
          ),
          body: Container(
            child: Column(
              children: [
                Divider(
                  color: bg,
                  height: height / 18,
                ),
                Expanded(
                    flex: 5,
                    child: InkWell(
                      onTap: () async {
                        var myRef = firebaseStorage.ref();

                        var myList = await myRef.listAll();

                        myList.prefixes.forEach((element) async {
                          var myFolderList =
                              await firebaseStorage.ref(element.name).listAll();
                          if (myFolderList.items.length == 3) {
                            setState(() {
                              displayDelete(context);
                            });
                          } else {
                            selectFile();
                          }
                        });
                      },
                      child: Container(
                        width: width / 1.3,
                        decoration: BoxDecoration(
                            color: disable,
                            borderRadius: BorderRadius.circular(16.0)),
                        child: DottedBorder(
                          borderType: BorderType.Rect,
                          dashPattern: [20, 30],
                          strokeWidth: 3.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  if (pickedFile != null)
                                    Center(
                                      child: Text(pickedFile!.name),
                                    ),
                                  if (pickedFile == null)
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.cloud_download,
                                          color: base,
                                          size: width / 2.5,
                                        ),
                                        const Text('Upload Files Here'),
                                        const Text('File Must Be Formatted to mp3'),
                                      ],
                                    ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: base,
                                    ),
                                    onPressed: () async {
                                      var myRef = firebaseStorage.ref();

                                      var myList = await myRef.listAll();

                                      myList.prefixes.forEach((element) async {
                                        var myFolderList = await firebaseStorage
                                            .ref(element.name)
                                            .listAll();
                                        if (myFolderList.items.length == 3) {
                                          setState(() {
                                            displayDelete(context);
                                          });
                                        } else {
                                          selectFile();
                                        }
                                      });
                                    },
                                    child: const Text("Browse & Upload"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
                Expanded(
                    flex: 3,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(15, 20, 15, 0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Copy Link',
                                style: TextStyle(color: base),
                              ),
                            ],
                          ),
                          Divider(
                            color: bg,
                          ),
                          Card(
                            color: base,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              height: height / 13,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FutureBuilder(
                                      future: uploadFile(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return GestureDetector(
                                            onTap: () async {
                                              await Clipboard.setData(
                                                  ClipboardData(
                                                      text: snapshot.data
                                                          .toString()));
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content:
                                                          Text("url copied")));
                                              setState(() {
                                                pickedFile = null;
                                              });
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        FormPage(
                                                          device: widget.device,
                                                        )),
                                              );
                                            },
                                            child: Text(
                                              snapshot.data.toString(),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style:
                                                  const TextStyle(color: Colors.blue),
                                            ),
                                          );
                                        } else {
                                          return IconButton(
                                            color: bg,
                                            onPressed: () {},
                                            icon: const Icon(
                                              Icons.copy,
                                              size: 24.0,
                                            ),
                                          );
                                        }
                                      }),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        );
      },
    );
  }
}
