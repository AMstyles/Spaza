import 'package:flutter/material.dart';
import 'package:spaza/models/cart_item.dart';
import 'package:spaza/models/item.dart';

class Cart {
  Map<String, CartItem> cartItemsMap = {};

  void addToCart(Item item) {
    if (cartItemsMap.containsKey(item.id)) {
      cartItemsMap[item.id!] = cartItemsMap[item.id]!..quantity += 1;
    } else {
      cartItemsMap[item.id!] = CartItem.fromItem(item, quantity: 1);
    }
  }

  void removeFromCart(Item item) {
    if (cartItemsMap.containsKey(item.id)) {
      if (cartItemsMap[item.id]!.quantity > 1) {
        cartItemsMap[item.id!] = cartItemsMap[item.id]!..quantity -= 1;
      } else {
        cartItemsMap.remove(item.id);
      }
    }
  }

  void clearCart() {
    cartItemsMap.clear();
  }

  double get total {
    double total = 0;
    cartItemsMap.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  int get totalItems {
    int total = 0;
    cartItemsMap.forEach((key, value) {
      total += value.quantity;
    });
    return total;
  }

  Cart() {
    cartItemsMap = {};
  }

  int getCartItemCount(String id) {
    return cartItemsMap[id]?.quantity ?? 0;
  }

  Cart.fromJson(Map<String, dynamic> json) {
    cartItemsMap = {};
    json.forEach((key, value) {
      cartItemsMap[key] = CartItem.fromJson(value);
    });
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    cartItemsMap.forEach((key, value) {
      json[key] = value.toJson();
    });
    return json;
  }
}

class CartProvider extends ChangeNotifier {
  //hack
  Cart cart = Cart();

  void addToCart(Item item) {
    cart.addToCart(item);
    notifyListeners();
  }

  void removeFromCart(Item item) {
    cart.removeFromCart(item);
    notifyListeners();
  }

  void clearCart() {
    cart.clearCart();
    notifyListeners();
  }

  int getCartItemCount(String id) {
    return cart.getCartItemCount(id);
  }

  int get totalItems {
    return cart.totalItems;
  }

  double get total {
    return cart.total;
  }

  Future<void> saveCartToFirestore() async {}
}
