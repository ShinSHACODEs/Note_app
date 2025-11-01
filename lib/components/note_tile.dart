import 'package:flutter/material.dart';
import 'package:note_app/Theme/palette.dart' as AppPalette;
import 'package:note_app/components/note_setting.dart';
import 'package:popover/popover.dart';

class NoteTile extends StatelessWidget {
  final String text;
  final void Function()? onEditPressed;
  final void Function()? onDeletePressed;
  final int index; // ✅ เพิ่ม index เพื่อเลือกสี

  const NoteTile({
    super.key,
    required this.text,
    required this.onEditPressed,
    required this.onDeletePressed,
    required this.index, // ✅ ต้องรับค่า index มาด้วย
  });

  @override
  Widget build(BuildContext context) {
    // ✅ ใช้สีจาก palette.dart โดยวนซ้ำเมื่อครบ 4 สี
    final color = AppPalette.noteColors[index % AppPalette.noteColors.length];

    return Container(
      decoration: BoxDecoration(
        color: color, // ✅ ใช้สีของ Note ตามลำดับ
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
      margin: const EdgeInsets.only(left: 25, right: 25, top: 10),
      child: ListTile(
        title: Text(
          text,
          style: TextStyle(
            color: index == 3
                ? Colors.black
                : Colors.white, // ✅ ถ้าพื้นอ่อน ให้ใช้ตัวอักษรสีดำ
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Builder(
          builder: (context) => IconButton(
            onPressed: () => showPopover(
              context: context,
              bodyBuilder: (context) => NoteSetting(
                onEditTap: onEditPressed,
                onDeleteTap: onDeletePressed,
              ),
              width: 100,
              height: 100,
            ),
            icon: Icon(
              Icons.more_vert,
              color: index == 3
                  ? Colors.black
                  : Colors.white, // ✅ ปรับสี icon ให้เห็นชัด
            ),
          ),
        ),
      ),
    );
  }
}
