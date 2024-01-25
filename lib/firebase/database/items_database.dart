import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spaza/models/item.dart';
import 'package:spaza/providers/cart_provider.dart';
import 'package:spaza/models/order.dart';

class ItemDatabase {
  static var db = FirebaseFirestore.instance;
  static Future<void> addItem(Item item) async {
    db = FirebaseFirestore.instance;
    final ref = db.collection('items').doc(item.id);
    try {
      ref.set(item.toJson());
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    }
  }

  static Future<List<Item>> getItems() async {
    db = FirebaseFirestore.instance;
    final ref = db.collection('items').orderBy('datePosted', descending: true);
    try {
      final snapshot = await ref.get();
      final items =
          snapshot.docs.map((e) => Item.fromJson(e.data())..id = e.id).toList();
      return items;
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    }
  }

  static Future<void> removeItem(String id) async {
    db = FirebaseFirestore.instance;
    final ref = db.collection('items').doc(id);
    try {
      await ref.delete();
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    }
  }

  static Future<void> placeOrder(Cart cart, String userID) async {
    db = FirebaseFirestore.instance;
    final ref = db.collection('orders');
    try {
      await ref.doc().set({
        'status': 0,
        'userId': userID,
        'dateOrdered': DateTime.now().toIso8601String(),
        'cartItemsMap': cart.toJson(),
      });
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    }
  }

  static Future<List<SimpleOrder>> getOrders(String userID) async {
    db = FirebaseFirestore.instance;
    final ref = db
        .collection('orders')
        .where('userId', isEqualTo: userID)
        .orderBy('dateOrdered', descending: true);
    try {
      final snapshot = await ref.get();

      List<SimpleOrder> orders = [];

      for (var doc in snapshot.docs) {
        try {
          print(doc.data());
          SimpleOrder order = SimpleOrder.fromJson(doc.data());
          order.id = doc.id;
          orders.add(order);
        } catch (e) {
          print(e);
        }
      }

      return orders;
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    }
  }

  static Future<List<SimpleOrder>> getAllOrders() async {
    db = FirebaseFirestore.instance;
    final ref =
        db.collection('orders').orderBy('dateOrdered', descending: true);
    try {
      final snapshot = await ref.get();

      List<SimpleOrder> orders = [];

      for (var doc in snapshot.docs) {
        try {
          print(doc.data());
          SimpleOrder order = SimpleOrder.fromJson(doc.data());
          order.id = doc.id;
          orders.add(order);
        } catch (e) {
          print(e);
        }
      }

      return orders;
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    }
  }

  static Future<void> updateOrderStatus(String orderID, int status) async {
    db = FirebaseFirestore.instance;
    final ref = db.collection('orders').doc(orderID);
    try {
      await ref.update({'status': status});
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    }
  }
}
