import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:spaza/firebase/database/items_database.dart';
import 'package:spaza/models/item.dart';
import 'package:spaza/pages/details_page.dart';
import 'package:spaza/providers/cart_provider.dart';
import 'package:spaza/providers/userProvider.dart';

class ItemWidget extends StatefulWidget {
  ItemWidget({Key? key, required this.item, required this.onRemove}) : super(key: key);
  final Item item;
  final VoidCallback onRemove;

  @override
  State<ItemWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  @override
  Widget build(BuildContext context) {
    Item item = widget.item;
    return Slidable(
      endActionPane: Provider.of<UserProvider>(context).user!.isAdmin
          ? ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  // An action can be bigger than the others.
                  borderRadius: BorderRadius.circular(10),
                  flex: 2,
                  onPressed: (_) async{
                    await ItemDatabase.removeItem(item.id!);
                    widget.onRemove();
                  },
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete_rounded,
                  label: 'Delete',
                ),
              ],
            )
          : null,
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ItemDetailsPage(item: item))),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          height: 200,
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
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Flexible(
              flex: 2,
              child: Material(
                type: MaterialType.transparency,
                elevation: 500,
                child: Hero(
                  tag: item.image,
                  child: Image.network(
                    item.image,
                    height: 160,
                    width: 160,
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'R${item.price.toStringAsFixed(2)}',
                    style: GoogleFonts.abel(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                  Text(
                    item.name,
                    style: GoogleFonts.abel(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                  Text(
                    item.description,
                    style: GoogleFonts.abel(
                        fontSize: 10,
                        fontWeight: FontWeight.normal,
                        color: Colors.blueGrey),
                  ),
                ],
              ),
            ),

            //create an add to cart button
            if (!Provider.of<UserProvider>(context).user!.isAdmin)
              Flexible(
                flex: 1,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                      Text(
                        "${Provider.of<CartProvider>(context).getCartItemCount(item.id!)}",
                        style: GoogleFonts.abel(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
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
                    ],
                  ),
                ),
              ),
          ]),
        ),
      ),
    );
    ;
  }
}
