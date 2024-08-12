import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gps_module_test/helper/constant.dart';
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
  RxBool gecici = true.obs;
  late Timer _timer;

  void oku() async {
    if (!port.openReadWrite()) {
      print(SerialPort.lastError);
      exit(-1);
    }

    final reader = SerialPortReader(port);
    reader.stream.listen((data) {
      ///   *******************
      ///

      String dataStr = String.fromCharCodes(data);
      // Split data by new lines to process each line individually
      List<String> lines = dataStr.split('\n');
      for (String line in lines) {
        if (line.startsWith('\$GNRMC')) {
          gnrmcSentence.value = line;
          print('Received GNRMC UFUK : $line');
        } else if (line.startsWith('\$GNGGA')) {
          gnggaSentence.value = line;
          print('Received GNGGA UFUK : $line');
        } else if (line.startsWith('\$GNGLL')) {
          gngllSentence.value = line;
          print('Received GNGLL UFUK : $line');
        }
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
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    port.close(); // Portu kapatır.
    _timer.cancel(); // Timer'ı kapat
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(),
        body: !gecici.value
            ? Container()
            : SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    //   Center(
                    //     child: Text(gelenData.value),
                    //   ),
                    maviButton(context, text: "YENILE", onPressed: () {
                      setState(() {});
                    }),
                    heightSpace15,
                    // maviButton(context, text: "PORTU AÇ", onPressed: () {
                    //   port.close();
                    //   oku();
                    // }),
                    // yesilButton(context, text: "PORTU KAPAT", onPressed: () {
                    //   port.close();
                    // }),

                    heightSpace45,
                    GNRMCParser(),
                    heightSpace15,
                    GNGGAParser(),
                    heightSpace15,
                    GNGLLParser(),
                  ],
                ),
              ),
      ),
    );
  }
}
