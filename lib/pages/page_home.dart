import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gps_module_test/helper/page_gngll.dart';
import 'package:libserialport/libserialport.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';

import '../element/butonlar_widget.dart';
import '../helper/page_gngga.dart';
import '../helper/parse_gnrmc.dart';

class PageHome extends StatefulWidget {
  PageHome({super.key});

  @override
  State<PageHome> createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  RxString gelenData = "".obs;
  List<String> parts = [];
  final port = SerialPort("/dev/ttyS4");
  RxBool gecici=true.obs;
  void oku() async {
    if (!port.openReadWrite()) {
      print(SerialPort.lastError);
      exit(-1);
    }

    final reader = SerialPortReader(port);
    reader.stream.listen((data) {
      print('received String: ${utf8.decode(data)}');
      gelenData.value = utf8.decode(data);

      parts = gelenData.value.split(',');
      print('UFUK ilk String: ${utf8.decode(data)}');
      gnggaSentence.value = gelenData.value;
      if (parts[0] == 'GNRMC') {
        print("GNRMC geldi" + gelenData.value);
        gnrmcSentence.value = gelenData.value;
        throw Exception('Geçersiz GNRMC cümlesi');
      }

      if (parts[0] == '\$GNGLL') {
        print("GNGLL geldi" + gelenData.value);
        gnrmcSentence.value = gelenData.value;
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
  void dispose() {
    port.close(); // Portu kapatır.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(),
        body:!gecici.value?Container(): SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
           //   Center(
           //     child: Text(gelenData.value),
           //   ),
              maviButton(context, text: "PORTU AÇ", onPressed: () {
                port.close();
                oku();
              }),
              yesilButton(context, text: "PORTU KAPAT", onPressed: () {
                port.close();
              }),

              //  GNRMCParser(),

            GNGGAParser(),

              //    GNGLLParser(),

            ],
          ),
        ),
      ),
    );
  }
}
