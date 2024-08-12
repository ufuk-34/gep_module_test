import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gps_module_test/helper/app_config.dart';

import '../element/custom_text.dart';
import 'page_gngga.dart';

//  $GNMRMC,hhmmss.sss,A,latitude,N,longitude,E,speed,course,ddmmyy,,d
/*
hhmmss.sss - UTC zamanı
A - Aktivite durumu (A: Aktif, V: Geçersiz)
latitude,N - Enlem ve kuzeyde olup olmadığı (N: Kuzey, S: Güney)
longitude,E - Boylam ve doğuda olup olmadığı (E: Doğu, W: Batı)
speed - Hız (km/saat cinsinden)
course - Kurs (derece)
ddmmyy - Tarih (gün/ay/yıl)
 */

//RxString gnrmcSentence = '\$GNMRMC,123456.00,A,4824.1234,N,00135.6789,W,12.34,56.78,091223,,0000';
RxString gnrmcSentence = "".obs;

class GNRMCParser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Örnek GNRMC cümlesi

    // GNRMC cümlesini işleyin
    Map<dynamic, dynamic> parsedData = parseGNRMC(gnrmcSentence.value);

    return Center(
      child: Container(
        height: 250,
        width: App(context).appWidth(100),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomText(
                text: "GNRMC",
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  item("GNRMC Aktif", parsedData['active'].toString()),
                  item("Enlem", parsedData['latitude'].toString()),
                  item("Boylam", parsedData['longitude'].toString()),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  item("Hız", "${parsedData['speed']} km/saat"),
                  item("Zaman", "${parsedData['time']}UTC"),
                  item("Tarih", parsedData['date'].toString()),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }

  Map<dynamic, dynamic> parseGNRMC(String sentence) {
    // Cümleyi parçalara ayırın
    print("aliiiiii" + sentence);
    List<String> parts = sentence.split(',');

    if (parts[0] != '\$GNRMC') {
      return {
        'active': ' - ',
        'latitude': " - ",
        'longitude': " - ",
        'speed': " - ",
        'time': " - ",
        'date': " - ",
      };
    } else {
      // Verileri çıkarın
      String time = parseTime(parts[1]);
      bool isActive = parts[2] == 'A';
      String latitude = parseLatitudeLongitude(parts[3], parts[4]);
      String longitude = parseLatitudeLongitude(parts[5], parts[6]);
      String speed = parts[7];
      String date = parseDate(parts[9]);

      return {
        'active': isActive ? 'Evet' : 'Hayır',
        'latitude': latitude,
        'longitude': longitude,
        'speed': speed,
        'time': time,
        'date': date,
      };
    }
  }

  String parseTime(String value) {
    if (value.isEmpty) return ' - ';

    // Zamanı saat:dakika:saniye formatına çevir
    return '${value.substring(0, 2)}:${value.substring(2, 4)}:${value.substring(4, 6)}';
  }

  String parseDate(String value) {
    if (value.isEmpty) return ' - ';

    // Tarihi gün/ay/yıl formatına çevir
    String day = value.substring(0, 2);
    String month = value.substring(2, 4);
    String year = '20' + value.substring(4, 6); // 21. yüzyıl
    return '$day/$month/$year';
  }

  String parseLatitudeLongitude(String value, String direction) {
    if (value.isEmpty) return ' - ';

    double degrees = double.parse(value.substring(0, 2));
    double minutes = double.parse(value.substring(2));
    double result = degrees + (minutes / 60);

    if (direction == 'S' || direction == 'W') {
      result *= -1;
    }

    return result.toStringAsFixed(4);
  }
}
