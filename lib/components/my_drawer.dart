import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            DrawerHeader(
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Text(
                  "Note App",
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home), // ไอคอน “บ้าน”
              title: const Text('Notes'),
              onTap: () {
                Navigator.pop(context); // ปิด drawer
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings), // ไอคอน “ฟันเฟือง”
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context); // ปิด drawer
                Navigator.pushNamed(context, '/settings');
              },
            ),
            // Weather
            ListTile(
              leading: const Icon(Icons.wb_sunny_outlined),
              title: const Text('Weather'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/weather'); // << ไป Weather
              },
            ),
          ],
        ),
      ),
    );
  }
}
