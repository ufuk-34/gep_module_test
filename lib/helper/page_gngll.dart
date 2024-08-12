import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gps_module_test/helper/app_config.dart';

import '../element/custom_text.dart';
import 'page_gngga.dart';

RxString gngllSentence = "".obs;

class GNGLLParser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // GNGLL cümlesini işleyin
    Map<String, String> parsedData = parseGNGLL(gngllSentence.value);

    return Center(
      child: Container(
        height: 200, // Yüksekliği ihtiyaca göre ayarlayabilirsiniz
        width: App(context).appWidth(100),
        child: Row(
          children: [
            CustomText(
              text: "GNGLL",
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                item("Fix Durumu", parsedData['status'].toString()),
                item("Enlem", parsedData['latitude'].toString()),
                item("Boylam", parsedData['longitude'].toString()),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                item("Zaman", "${parsedData['time']}UTC"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Map<String, String> parseGNGLL(String sentence) {
    // Cümleyi parçalara ayırın
    List<String> parts = sentence.split(',');

    if (parts[0] != '\$GNGLL') {
      return {
        'status': 'Bilgi Yok',
        'latitude': 'Bilgi Yok',
        'longitude': 'Bilgi Yok',
        'time': 'Bilgi Yok',
      };
    } else {
      // Verileri çıkarın
      String latitude = parseLatitudeLongitude(parts[1], parts[2]);
      String longitude = parseLatitudeLongitude(parts[3], parts[4]);
      String time = parseTime(parts[5]);
      String status = parts[6] == 'A' ? 'Aktif' : 'Geçersiz';

      return {
        'status': status,
        'latitude': latitude,
        'longitude': longitude,
        'time': time,
      };
    }
  }

  String parseTime(String value) {
    if (value.isEmpty) return 'Bilgi Yok';

    // Zamanı saat:dakika:saniye formatına çevir
    return '${value.substring(0, 2)}:${value.substring(2, 4)}:${value.substring(4, 6)}';
  }

  String parseLatitudeLongitude(String value, String direction) {
    if (value.isEmpty) return 'Bilgi Yok';

    double degrees = double.parse(value.substring(0, 2));
    double minutes = double.parse(value.substring(2));
    double result = degrees + (minutes / 60);

    if (direction == 'S' || direction == 'W') {
      result *= -1;
    }

    return result.toStringAsFixed(4);
  }
}
