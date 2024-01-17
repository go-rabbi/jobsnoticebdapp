import 'package:flutter/material.dart';
import 'package:jobs/models/appsettings.dart';
import 'package:jobs/utis/models.dart';

class AppSettingsPage extends StatefulWidget {
  const AppSettingsPage({super.key});

  @override
  State<AppSettingsPage> createState() => _AppSettingsPageState();
}

class _AppSettingsPageState extends State<AppSettingsPage> {
  bool dark = false;
  @override
  void initState() {
    super.initState();
    dark = settings.getAt(0)!.dark;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        titleSpacing: 0,
      ),
      body: Column(
        children: [
          SwitchListTile(
              title: Text('Dark Mode'),
              activeColor: Colors.green,
              value: dark,
              onChanged: (bool v) {
                setState(() {
                  dark = v;
                  settings.putAt(0, Appsettings(dark: dark));
                });
              })
        ],
      ),
    );
  }
}
