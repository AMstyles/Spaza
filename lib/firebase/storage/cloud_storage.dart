import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:spaza/widgets/blob_loader.dart';

class CloudStorage {
  static final storage = FirebaseStorage.instance;
  static final storageRef = FirebaseStorage.instance.ref();

  static Future<String> uploadProductImage(
      File file, BuildContext context) async {
    final fileRef = await storageRef.child(
        'product_images/${FirebaseAuth.instance.currentUser!.uid}-${DateTime.now().toString()}.png');

    try {
      await fileRef.putFile(file);
      return await fileRef.getDownloadURL();
    } catch (error) {
      Navigator.pop(context);
      await showDialog(
        context: context,
        builder: ((context) => AlertDialog(
              content: Text(error.toString()),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('close'))
              ],
            )),
      );
    }
    return ' ';
  }
}
