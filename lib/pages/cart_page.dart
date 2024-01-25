import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slide_to_act_reborn/slide_to_act_reborn.dart';
import 'package:spaza/firebase/database/items_database.dart';
import 'package:spaza/providers/cart_provider.dart';
import 'package:spaza/widgets/item_widget_small.dart';

class CartPage extends StatefulWidget {
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  //create a scarfold key
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
            title: const Text('Your Cart'),
            centerTitle: true,
            bottom: isLoading
                ? const PreferredSize(
                    preferredSize: Size.fromHeight(10),
                    child: LinearProgressIndicator(
                      color: Colors.green,
                    ),
                  )
                : null),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                //todo: summary of cart items
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Flexible(
                        flex: 1,
                        child: Text(
                            '${Provider.of<CartProvider>(context).totalItems} items')),
                    Flexible(
                        flex: 1,
                        child: Text(
                            'Total ${Provider.of<CartProvider>(context).total.toStringAsFixed(2)}.'))
                  ],
                ),
                const Divider(),
                //todo: some dart jujitsu comming up:)
                ...Provider.of<CartProvider>(context)
                    .cart
                    .cartItemsMap
                    .map((key, value) => MapEntry(key, value))
                    .values
                    .map((e) => SmallItemWidget(item: e))
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    onPressed: () {
                      Provider.of<CartProvider>(context, listen: false)
                          .clearCart();
                    },
                    child: const Text(
                      'Clear Cart',
                      style: TextStyle(color: Colors.red),
                    )),
                TextButton(
                  onPressed: onCheckout,
                  child: const Text('Checkout'),
                ),
              ],
            ),
          ),
        ));
  }

  void onCheckout() {
    _scaffoldKey.currentState?.showBottomSheet(
      elevation: 10,
      (context) => Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[700],
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        height: MediaQuery.of(context).size.height * 0.3,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text('Checkout',
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
            SlideAction(
              elevation: 0,
              sliderButtonIcon: const Icon(
                Icons.arrow_forward_ios_rounded,
              ),
              text: "Slide to Lucky-Pay",
              onSubmit: onSubmit,
            ),
          ],
        )),
      ),
    );
  }

  Future<void> onSubmit() async {
    Navigator.pop(context);
    setState(() {
      isLoading = true;
    });

    try {
      await ItemDatabase.placeOrder(
          Provider.of<CartProvider>(context, listen: false).cart,
          FirebaseAuth.instance.currentUser!.uid);
      Provider.of<CartProvider>(context, listen: false).clearCart();
      SnackBar snackBar = SnackBar(
        backgroundColor: Colors.green,
        content: const Text(
          'Order Placed',
          style: TextStyle(color: Colors.white),
        ),
        duration: const Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }
}
