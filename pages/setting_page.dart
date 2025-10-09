import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/Theme/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(12)
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 25
        ),
        margin: const EdgeInsets.only(
          left: 25,
          right: 25,
          top: 10
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Dark Mode",style: Theme.of(context).textTheme.displayMedium!.copyWith(),
            ),
            CupertinoSwitch(
                value: Provider.of<ThemeProvider>(
                  context,
                  listen: false,
                ).isDarkMode,
                onChanged: (value) => Provider.of<ThemeProvider>(
                  context,
                  listen: false,
                ).toggleTheme(),
              ),
          ],
        ),
        ),
    );
  }
}