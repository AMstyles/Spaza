import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:spaza/models/item.dart';
import 'package:spaza/pages/cart_page.dart';
import 'package:spaza/providers/cart_provider.dart';
import 'package:spaza/providers/userProvider.dart';

class ItemDetailsPage extends StatefulWidget {
  const ItemDetailsPage({super.key, required this.item});
  final Item item;

  @override
  _ItemDetailsPageState createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final Item item = widget.item;
    return Scaffold(
        appBar: AppBar(
          title: Text(item.name),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton:
            (!Provider.of<UserProvider>(context).user!.isAdmin)
                ? FloatingActionButton(
                    backgroundColor: Colors.lightBlue,
                    heroTag: 'fab',
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => CartPage()));
                    },
                    child: const Icon(Icons.shopping_cart, color: Colors.white),
                  )
                : null,
        body: ListView(
          children: [
            Hero(
              tag: item.image,
              child: Image.network(
                item.image,
                height: 300,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                item.name,
                style: GoogleFonts.abel(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                item.description,
                style: GoogleFonts.abel(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: Colors.blueGrey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    'R${item.price.toStringAsFixed(2)}',
                    style: GoogleFonts.abel(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey),
                  ),
                  const Spacer(),
                  //create the card increase and decrease buttons
                  if (!Provider.of<UserProvider>(context).user!.isAdmin)
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            setState(() {
                              Provider.of<CartProvider>(context, listen: false)
                                  .removeFromCart(item);
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red.withOpacity(0.5),
                            ),
                            child: const Icon(
                              Icons.remove,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "${Provider.of<CartProvider>(context, listen: false).totalItems}",
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            setState(() {
                              Provider.of<CartProvider>(context, listen: false)
                                  .addToCart(item);
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue.withOpacity(0.5),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ));
  }
}
