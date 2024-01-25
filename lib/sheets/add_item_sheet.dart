import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spaza/firebase/database/items_database.dart';
import 'package:spaza/firebase/storage/cloud_storage.dart';
import 'package:spaza/models/item.dart';
import 'package:spaza/widgets/blob_loader.dart';

class PostItemSheet extends StatefulWidget {
  PostItemSheet(
      {super.key, required this.myController, required this.callback});
  ScrollController myController;
  VoidCallback callback;

  @override
  State<PostItemSheet> createState() => _PostItemSheet();
}

class _PostItemSheet extends State<PostItemSheet> {
  //initialize an empty list
  XFile? image = null;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16), topRight: Radius.circular(16)),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            controller: widget.myController,
            child: Column(
              children: [
                //create a row with a close button and a post button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.close,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    _buildPostButton()
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                //todo: create a container for the image
                Center(
                  child: Container(
                    height: image == null ? 100 : 200,
                    width: image == null ? 100 : 200,
                    decoration: BoxDecoration(
                      color: image == null ? Colors.grey.withOpacity(.3) : null,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: image == null
                        ? IconButton(
                            onPressed: () {
                              pickImage();
                            },
                            icon: const Icon(
                              Icons.add_a_photo,
                              color: Colors.grey,
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.file(File(image!.path),
                                fit: BoxFit.contain)),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                //todo: create name text field
                TextField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  autofocus: true,
                  controller: _nameController,
                  minLines: 1,
                  decoration: InputDecoration(
                    hintText: 'Product name',
                    hintStyle: GoogleFonts.abel(
                      color: Colors.grey,
                    ),
                    border:
                        //put a border around the text field
                        OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: Colors.grey.withOpacity(.3),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                //todo: create a price text field
                TextField(
                  textInputAction: TextInputAction.next,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  autofocus: true,
                  controller: _priceController,
                  minLines: 1,
                  decoration: InputDecoration(
                    hintText: 'Price',
                    hintStyle: GoogleFonts.abel(
                      color: Colors.grey,
                    ),
                    border:
                        //put a border around the text field
                        OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: Colors.grey.withOpacity(.3),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                //todo: create a description text field

                TextField(
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                  autofocus: true,
                  controller: _descriptionController,
                  maxLines: 5,
                  minLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Item description',
                    hintStyle: GoogleFonts.abel(
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: Colors.grey.withOpacity(.3),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildPostButton() {
    return GestureDetector(
      onTap: onSubmit,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.blue,
        ),
        child: Text(
          'post',
          style: GoogleFonts.abel(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
    );
  }

  void onSubmit() async {
    //show loading dialog

    if (_nameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        image == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog.adaptive(
          title: Text('Error', style: GoogleFonts.abel(color: Colors.red)),
          content: const Text('Please fill in all fields'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Ok'))
          ],
        ),
      );

      return;
    }

    showDialog(
        context: context,
        builder: (context) => BlobLoader(
              "Adding item...",
            ));

    String? imageUrl =
        await CloudStorage.uploadProductImage(File(image!.path), context);

    if (imageUrl == "") {
      Navigator.pop(context);
      return;
    }

    Item item = Item(
      name: _nameController.text,
      price: double.parse(_priceController.text),
      description: _descriptionController.text,
      image: imageUrl,
      datePosted: DateTime.now(),
    );

    try {
      await ItemDatabase.addItem(item);
      Navigator.pop(context);
      Navigator.pop(context);
      SnackBar snackBar = const SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          'Item added successfully',
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(seconds: 2),
      );
      widget.callback();
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (e) {
      //show error dialog
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Error'),
                content: Text(e.toString()),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Ok'))
                ],
              ));
    }
  }

  void pickImage() async {
    final _picker = ImagePicker();

    //display a dialog to choose between camera and gallery
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Choose an image'),
              content: const Text(
                  'Choose an image from the gallery or take a new one'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel')),
                TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      final pickedFile =
                          await _picker.pickImage(source: ImageSource.gallery);
                      setState(() {
                        image = pickedFile;
                      });
                    },
                    child: const Text('Gallery')),
                TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      final pickedFile =
                          await _picker.pickImage(source: ImageSource.gallery);
                      setState(() {
                        image = pickedFile;
                      });
                    },
                    child: const Text('Camera')),
              ],
            ));
  }
}
