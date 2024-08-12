import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gps_module_test/element/custom_text.dart';
import 'package:gps_module_test/helper/app_config.dart';

RxString gnggaSentence = "".obs;

class GNGGAParser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // GNGGA cümlesini işleyin
    Map<String, String> parsedData = parseGNGGA(gnggaSentence.value);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration:
              BoxDecoration(border: Border.all(color: Colors.indigo, width: 3)),
          height: 300, // Yüksekliği artırdık çünkü daha fazla veri gösteriyoruz
          width: App(context).appWidth(100),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomText(
                text: "GNGGA",
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  item("Fix Durumu", parsedData['fixQuality'].toString()),
                  item("Enlem", parsedData['latitude'].toString()),
                  item("Boylam", parsedData['longitude'].toString()),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  item("Uydu Sayısı", parsedData['numSats'].toString()),
                  item("Zaman", '${parsedData['time']} UTC'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, String> parseGNGGA(String sentence) {
    // Cümleyi parçalara ayırın
    List<String> parts = sentence.split(',');

    if (parts[0] != '\$GNGGA') {
      return {
        'fixQuality': 'Bilgi Yok',
        'latitude': 'Bilgi Yok',
        'longitude': 'Bilgi Yok',
        'altitude': 'Bilgi Yok',
        'numSats': 'Bilgi Yok',
        'time': 'Bilgi Yok',
      };
    } else {
      // Verileri çıkarın
      String time = parseTime(parts[1]);
      String latitude = parseLatitudeLongitude(parts[2], parts[3]);
      String longitude = parseLatitudeLongitude(parts[4], parts[5]);
      String altitude = parts[9]; // Yükseklik
      String fixQuality = parts[6] == '1' ? 'GPS Fix Mevcut' : 'GPS Fix Yok';
      String numSats = parts[7]; // Uydu sayısı

      return {
        'fixQuality': fixQuality,
        'latitude': latitude,
        'longitude': longitude,
        'altitude': altitude,
        'numSats': numSats,
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

Widget item(String t, String l) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      CustomText(
        text: t,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
      CustomText(
        text: ' : ',
        fontSize: 10,
      ),
      CustomText(
        text: l,
        fontSize: 10,
      ),
    ],
  );
}
