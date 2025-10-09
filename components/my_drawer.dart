import 'package:flutter/material.dart';
import 'package:note_app/components/drawer_tile.dart';
import 'package:note_app/pages/setting_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      child: Column(
        children: [
          DrawerHeader(
            child: Padding(padding: const EdgeInsets.only(top: 50),
            child: Text("Note App",
            style: Theme.of(context).textTheme.displayLarge!.copyWith(),
            ),
            
            ),
          ),
          DrawerTile(
            title: "Notes", 
            leading: const Icon(Icons.home), 
            onTap: ()=> Navigator.pop(context)),
          DrawerTile(
            title: "Setting", 
            leading: const Icon(Icons.settings), 
            onTap: (){
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const SettingPage()));

            })
        ],
      ),
    );
  }
}