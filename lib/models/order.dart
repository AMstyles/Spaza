import 'package:spaza/providers/cart_provider.dart';

class LocalOrder extends Cart {
  String? id;
  int status;
  String userId;
  DateTime dateLocalOrdered;

  LocalOrder({
    required this.status,
    required this.userId,
    required this.dateLocalOrdered,
  }) : super();

  @override
  LocalOrder.fromJson(Map<String, dynamic> json)
      : status = json['status'],
        userId = json['userId'],
        dateLocalOrdered = DateTime.parse(json['dateLocalOrdered']),
        super.fromJson(json);

  @override
  Map<String, dynamic> toJson() => {
        'status': status,
        'userId': userId,
        'dateLocalOrdered': dateLocalOrdered.toIso8601String(),
        ...super.toJson(),
      };

  LocalOrder.fromCart(Cart cart, {required this.status, required this.userId})
      : dateLocalOrdered = DateTime.now(),
        super() {
    cartItemsMap = cart.cartItemsMap;
  }

  LocalOrder.fromJSON(Map<String, dynamic> json)
      : status = json['status'],
        userId = json['userId'],
        dateLocalOrdered = DateTime.parse(json['dateLocalOrdered']),
        super.fromJson(json);
}

class SimpleOrder {
  String? id;
  int status;
  String userId;
  DateTime dateLocalOrdered;

  SimpleOrder({
    required this.status,
    required this.userId,
    required this.dateLocalOrdered,
  });

  SimpleOrder.fromJson(Map<String, dynamic> json)
      : status = json['status'],
        userId = json['userId'],
        dateLocalOrdered = DateTime.parse(json['dateOrdered']);

  Map<String, dynamic> toJson() => {
        'status': status,
        'userId': userId,
        'dateLocalOrdered': dateLocalOrdered.toIso8601String(),
      };
}
