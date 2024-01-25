import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  String? id;
  String image;
  String name;
  String description;
  double price;
  DateTime datePosted;

  Item({
    this.id,
    required this.image,
    required this.name,
    required this.description,
    required this.price,
    required this.datePosted,
  });

  Item.fromJson(Map<String, dynamic> json)
      :name = json['name'],
      image = json['image'],
      description = json['description'],
      datePosted = json['datePosted'].toDate(),
      price = json['price'];

  Map<String, dynamic> toJson() => {
    'id': id ?? '',
    'name': name,
    'image': image,
    'description': description,
    'datePosted': Timestamp.fromDate(datePosted),
    'price': price,
  };
}

