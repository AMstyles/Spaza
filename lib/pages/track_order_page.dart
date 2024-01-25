import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaza/providers/userProvider.dart';
import 'package:spaza/widgets/my_timeline_tile.dart';

class TrackOrderPage extends StatefulWidget {
  TrackOrderPage({super.key, required this.orderId});
  String orderId;

  @override
  _TrackOrderPageState createState() => _TrackOrderPageState();
}

class _TrackOrderPageState extends State<TrackOrderPage> {
  bool isLoaded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Order'),
        centerTitle: true,
        bottom: isLoaded
            ? const PreferredSize(
                preferredSize: Size.fromHeight(4),
                child: LinearProgressIndicator())
            : null,
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('orders')
              .doc(widget.orderId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Something went wrong'),
              );
            }

            int status = snapshot.data!['status'];

            return ListView(
              padding: const EdgeInsets.all(8),
              children: [
                MyTimelineTile(
                  isFirst: true,
                  isLast: false,
                  isDone: status >= 0,
                  title: 'Order Placed'.toUpperCase(),
                  subtitle: "Your order has been placed",
                ),
                MyTimelineTile(
                  isFirst: false,
                  isLast: false,
                  isDone: status >= 1,
                  title: "Order Accepted".toUpperCase(),
                  subtitle: "Your order has been accepted",
                ),
                MyTimelineTile(
                  isFirst: false,
                  isLast: false,
                  isDone: status >= 2,
                  title: "Order Packed".toUpperCase(),
                  subtitle: "Your order has been packed",
                ),
                MyTimelineTile(
                  isFirst: false,
                  isLast: true,
                  isDone: status >= 3,
                  title: "Order Delivered".toUpperCase(),
                  subtitle: "Your order has been delivered",
                ),
                Provider.of<UserProvider>(context).user!.isAdmin
                    ? Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (status == 3) {
                              return;
                            }
                            setState(() {
                              isLoaded = true;
                            });
                            await FirebaseFirestore.instance
                                .collection('orders')
                                .doc(widget.orderId)
                                .update({'status': status + 1});

                            setState(() {
                              isLoaded = false;
                            });
                          },
                          child: const Text("Complete step"),
                        ),
                      )
                    : Container(),
              ],
            );
          }),
    );
  }
}
