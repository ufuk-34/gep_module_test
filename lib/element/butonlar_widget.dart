
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helper/app_config.dart';
import 'custom_text.dart';

Padding maviButton(BuildContext context,
    {text, onPressed, genislikYuzdesi = 80.0, heightt = 55.0}) {
  return Padding(
    padding: EdgeInsets.only(top: 0),
    child: Container(
      height: heightt + 0.0001,
      width: App(context).appWidth(genislikYuzdesi + 0.1),
      child: ElevatedButton(
        child: CustomText(
          text: text,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        onPressed: onPressed,
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              )),
          overlayColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) return Colors.green;
              return Colors.green;
            },
          ),
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed))
                return Colors.blue;
              return Colors.blue;
            },
          ),
        ),
      ),
    ),
  );
}

Padding yesilButton(BuildContext context,
    {text, onPressed, genislikYuzdesi = 80.0, heightt = 45.0}) {
  return Padding(
    padding: EdgeInsets.only(top: 0),
    child: Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      height: heightt + 0.0001,
      width: App(context).appWidth(genislikYuzdesi + 0.1),
      child: ElevatedButton(
        child: CustomText(
          text: text,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        onPressed: onPressed,
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          )),
          overlayColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed))
                return Colors.blue;
              return Colors.blue;
            },
          ),
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) return Colors.green;
              return Colors.green;
            },
          ),
        ),
      ),
    ),
  );
}
