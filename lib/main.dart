import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wakelock/wakelock.dart';

import 'pages/page_home.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp0());
}

class MyApp0 extends StatefulWidget {
  @override
  State createState() => _MyApp0State();
}

class _MyApp0State extends State<MyApp0> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: "KK Multimedya",
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),

        debugShowCheckedModeBanner: false,
        home: PageHome());

  }


}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    print("Bismillahirrahmanirrahim");
    Wakelock.enable();
    ///  Cihazın eğer uyku modu varsa devre dışı bırakılıyor...
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageHome();
  }
}
