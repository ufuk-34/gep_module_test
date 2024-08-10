import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libserialport/libserialport.dart';
import 'dart:convert';
import 'dart:typed_data';

class PageHome extends StatefulWidget {
  PageHome({super.key});

  @override
  State<PageHome> createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  RxString gelenData = "".obs;

  void oku() async {
    final port = SerialPort("/dev/ttyS3");
    if (!port.openReadWrite()) {
      print(SerialPort.lastError);
      //  exit(-1);
    }

    final reader = SerialPortReader(port);
    reader.stream.listen((data) {
      print('received: $data');

// Hex string'i byte dizisine çevir
      //    Uint8List byteData = hexStringToBytes(data.toString()); // 'hello' kelimesinin hex karşılığı

      print('received: ${utf8.decode(data)}');
      gelenData.value = utf8.decode(data);
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
          children: [Center(child: Text(gelenData.value))],
        ),
      ),
    );
  }
}
