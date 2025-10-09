import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/components/note_setting.dart';
import 'package:popover/popover.dart';

class NoteTile extends StatelessWidget {
  final String text;
  final void Function()? onEditPreses;
  final void Function()? onDeletePreses;
  const NoteTile({
    super.key,
    required this.text,
    required this.onEditPreses,
    required this.onDeletePreses
    });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        child: ListTile(
              title: Text(text),
              trailing: Builder(
                builder: (context)=>IconButton(
                  onPressed: ()=>showPopover(
                    context: context, 
                    bodyBuilder: (context)=> NoteSetting(onEditTap: onEditPreses, onDeleteTap: onDeletePreses),
                    width: 100,
                    height: 100
                    ), 
                  icon: const Icon(Icons.more_vert)))
            ),
        );
  }
}