import 'package:spaza/models/item.dart';

class CartItem extends Item {
  int quantity;

  CartItem({
    required this.quantity,
    required String image,
    required String name,
    required String description,
    required double price,
    required DateTime datePosted,
  }) : super(
          image: image,
          name: name,
          description: description,
          price: price,
          datePosted: datePosted,
        );

  CartItem.fromJson(Map<String, dynamic> json)
      : quantity = json['quantity'],
        super.fromJson(json);

  @override
  Map<String, dynamic> toJson() => {
        'quantity': quantity,
        ...super.toJson(),
      };

  CartItem.fromItem(Item item, {required this.quantity})
      : super(
          id: item.id,
          image: item.image,
          name: item.name,
          description: item.description,
          price: item.price,
          datePosted: item.datePosted,
        );
}
