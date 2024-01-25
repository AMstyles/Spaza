import 'package:flutter/material.dart';

import '../extensions/colorExtension.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({Key? key, required this.onPressed, required this.text})
      : super(key: key);

  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Container(
          padding: const EdgeInsets.all(10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(colors: [
              Colors.lightBlue,
              Colors.blueAccent,
            ]),
            //shadow
            boxShadow: [
              (MediaQuery.of(context).platformBrightness == Brightness.light)
                  ? BoxShadow(
                      color: Colors.lightBlueAccent.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    )
                  : BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
            ],
          ),
          margin: const EdgeInsets.all(10),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          )),
    );
  }
}
