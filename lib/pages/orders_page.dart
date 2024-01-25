import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaza/firebase/database/items_database.dart';
import 'package:spaza/models/order.dart';
import 'package:spaza/pages/track_order_page.dart';
import 'package:spaza/providers/userProvider.dart';

class OrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: FutureBuilder(
        future: Provider.of<UserProvider>(context).user!.isAdmin
            ? ItemDatabase.getAllOrders()
            : ItemDatabase.getOrders(FirebaseAuth.instance.currentUser!.uid),
        builder: (context, AsyncSnapshot<List<SimpleOrder>> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data == null) {
            return const Center(
              child: Text('No orders yet'),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              SimpleOrder order = snapshot.data![index];
              return Card(
                child: ListTile(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          TrackOrderPage(orderId: order.id!))),
                  title: Text(order.id!),
                  subtitle:
                      Text(order.dateLocalOrdered.toString().substring(0, 16)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
