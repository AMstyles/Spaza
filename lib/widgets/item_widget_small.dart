import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:spaza/models/cart_item.dart';
import 'package:spaza/pages/details_page.dart';
import 'package:spaza/providers/cart_provider.dart';

class SmallItemWidget extends StatefulWidget {
  const SmallItemWidget({Key? key, required this.item}) : super(key: key);
  final CartItem item;

  @override
  State<SmallItemWidget> createState() => _SmallItemWidgetState();
}

class _SmallItemWidgetState extends State<SmallItemWidget> {
  @override
  Widget build(BuildContext context) {
    CartItem item = widget.item;
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ItemDetailsPage(item: item))),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Flexible(
            flex: 1,
            child: Material(
              type: MaterialType.transparency,
              elevation: 500,
              child: Hero(
                tag: item.image,
                child: Image.network(
                  item.image,
                  height: 100,
                  width: 100,
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.name,
                  style: GoogleFonts.abel(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
                Text(
                  'R${item.price.toStringAsFixed(2)} x ${item.quantity}',
                  style: GoogleFonts.abel(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.blueGrey),
                ),
              ],
            ),
          ),
          //create an add to cart button
          Flexible(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    Provider.of<CartProvider>(context, listen: false)
                        .removeFromCart(item);
                  },
                  icon: const Icon(
                    Icons.remove_circle_outline_rounded,
                    color: Colors.redAccent,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Provider.of<CartProvider>(context, listen: false)
                        .addToCart(item);
                  },
                  icon: const Icon(
                    Icons.add_circle_outline_rounded,
                    color: Colors.lightBlueAccent,
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
