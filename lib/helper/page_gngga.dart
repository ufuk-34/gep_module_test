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
      child: Container(
        decoration:
            BoxDecoration(border: Border.all(color: Colors.indigo, width: 3)),
        height: 250, // Yüksekliği artırdık çünkü daha fazla veri gösteriyoruz
        width: App(context).appWidth(100),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomText(
                text: "GNGGA",
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 // Text(parsedData['fixQuality'].toString()),

                  item("Fix Durumu", parsedData['fixQuality'].toString()),
                  item("Enlem", parsedData['latitude'].toString()),
                  item("Boylam", parsedData['longitude'].toString()),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
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

    // Eğer cümle uygun değilse varsayılan değerler döndür
    if (parts.isEmpty || parts[0] != '\$GNGGA') {
      return {
        'fixQuality': ' - ',
        'latitude': ' - ',
        'longitude': ' - ',
        'altitude': ' - ',
        'numSats': ' - ',
        'time': ' - ',
      };
    }

    // Eksik veri kontrolü ve çıkarma
    String time = (parts.length > 1 && parts[1].isNotEmpty) ? parseTime(parts[1]) : ' - ';
    String latitude = (parts.length > 2 && parts[2].isNotEmpty) ? parseLatitudeLongitude(parts[2], parts[3]) : ' - ';
    String longitude = (parts.length > 4 && parts[4].isNotEmpty) ? parseLatitudeLongitude(parts[4], parts[5]) : ' - ';
    String altitude = (parts.length > 9 && parts[9].isNotEmpty) ? parts[9] : ' - ';
    String fixQuality = (parts.length > 6 && parts[6].isNotEmpty) ? (parts[6] == '1' ? 'AKTİF' : 'GPS Fix Yok') : ' - ';
    String numSats = (parts.length > 7 && parts[7].isNotEmpty) ? parts[7] : ' - ';

    return {
      'fixQuality': fixQuality,
      'latitude': latitude,
      'longitude': longitude,
      'altitude': altitude,
      'numSats': numSats,
      'time': time,
    };
  }

  String parseTime(String value) {
    if (value.isEmpty || value.length < 6) return ' - ';

    // Zamanı saat:dakika:saniye formatına çevir
    return '${value.substring(0, 2)}:${value.substring(2, 4)}:${value.substring(4, 6)}';
  }

  String parseLatitudeLongitude(String value, String direction) {
    if (value.isEmpty || direction.isEmpty) return ' - ';

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
        fontSize: 10,
        fontWeight: FontWeight.bold,
      ),
      CustomText(
        text: ' : ',
        fontSize: 8,
      ),
      CustomText(
        text: l,
        fontSize: 8,
      ),
    ],
  );
}
