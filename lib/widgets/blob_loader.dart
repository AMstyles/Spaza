import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

Widget BlobLoader(String title) => AlertDialog(
  title: Text(
    title,
    style: GoogleFonts.abel(fontSize: 20, fontWeight: FontWeight.bold),
  ),
  content: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: SizedBox(
            height: 200,
            width: 200,
            child: Lottie.asset(
              'lib/animations/loader.json',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    ),
  ),
);