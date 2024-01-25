import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:spaza/pages/auth/login_page.dart';
import 'package:spaza/pages/orders_page.dart';
import 'package:spaza/providers/userProvider.dart';
import '../pages/settings_page.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Row(
              children: [
                GestureDetector(
                  // onTap:()=> Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfilePage())),
                  child: CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 35,
                      child: Text(
                        Provider.of<UserProvider>(context).user!.name[0],
                        style:
                            GoogleFonts.abel(color: Colors.white, fontSize: 30),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, ${Provider.of<UserProvider>(context).user!.name.split(' ')[0]}',
                      style: GoogleFonts.abel(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                    Row(children: [
                      Text(
                        Provider.of<UserProvider>(context).user!.email,
                        style: GoogleFonts.abel(color: Colors.blueGrey),
                      ),
                      if (Provider.of<UserProvider>(context).user!.isAdmin)
                        const Icon(
                          Icons.verified_rounded,
                          color: Colors.lightBlueAccent,
                          size: 15,
                        ),
                    ]),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('home'),
            onTap: () {
              // Update the state of the app.
              // ...
              // Then close the drawer.
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('settings'),
            onTap: () {
              // Update the state of the app.
              // ...
              // Then close the drawer.
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SettingsPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.delivery_dining_rounded),
            title: const Text('Track Orders'),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => OrdersPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('about'),
            onTap: () {
              // Update the state of the app.
              // ...
              // Then close the drawer.
              Navigator.pop(context);
              showAboutDialog(
                context: context,
                applicationName: 'spaza',
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2024 BBD',
                applicationIcon: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'lib/images/logo.png',
                    height: 50,
                  ),
                ),
                children: [
                  const Text(
                    'Project for Lucky to show off my flutter skills',
                    style: TextStyle(fontSize: 16),
                  )
                ],
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () async {
              await FirebaseAuth.instance.signOut();

              Navigator.pop(context);

              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
          ),
        ],
      ),
    );
  }
}
