import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libserialport/libserialport.dart';
import 'dart:convert';
import 'dart:typed_data';

import '../helper/parse_gnrmc.dart';

class PageHome extends StatefulWidget {
  PageHome({super.key});

  @override
  State<PageHome> createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  RxString gelenData = "".obs;
  List<String> parts = [];
  void oku() async {
    final port = SerialPort("/dev/ttyS3");
    if (!port.openReadWrite()) {
      print(SerialPort.lastError);
      //  exit(-1);
    }

    final reader = SerialPortReader(port);
    reader.stream.listen((data) {
      print('received String: ${utf8.decode(data)}');
      gelenData.value = utf8.decode(data);



       parts=  gelenData.value.split(',');
      if (parts[0] == '\$GNRMC') {
        print("genrmc geldi"+ gelenData.value);
        gnrmcSentence.value=gelenData.value;
        throw Exception('Geçersiz GNRMC cümlesi');
      }

      if (parts[0] == '\$GNGLL') {
        print("GNGLL geldi"+ gelenData.value);
        gnrmcSentence.value=gelenData.value;
        throw Exception('Geçersiz GNRMC cümlesi');
      }
    });
  }

  Uint8List hexStringToBytes(String hex) {
    final length = hex.length;
    final bytes = Uint8List(length ~/ 2);
    for (var i = 0; i < length; i += 2) {
      bytes[i ~/ 2] = int.parse(hex.substring(i, i + 2), radix: 16);
    }
    return bytes;
  }

  @override
  void initState() {
    oku();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [Center(child: Text(gelenData.value)),

         //   GNRMCParser()

          ],
        ),
      ),
    );
  }
}
