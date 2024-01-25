import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Dark Mode'),
            trailing: Switch.adaptive(
              value: false,
              onChanged: (value) {},
            ),
          ),
          ListTile(
            title: const Text('Notifications'),
            trailing: Switch.adaptive(
              value: false,
              onChanged: (value) {},
            ),
          ),
          const ListTile(
            title: Text('Language'),
            trailing: Text('English'),
          ),
          const ListTile(
            title: Text('About'),
            trailing: Icon(Icons.arrow_forward_ios),
          ),

        ],
      ),
    );
  }
}