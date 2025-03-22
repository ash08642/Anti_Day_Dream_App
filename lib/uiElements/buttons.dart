import 'package:flutter/material.dart';

enum ButtonSize { small, medium, large }
extension ButtonSizeExtension on ButtonSize {
  double get width {
    switch (this) {
      case ButtonSize.small:
        return 100;
      case ButtonSize.medium:
        return 150;
      case ButtonSize.large:
        return 200;
      default:
      return 150;
    }
  }
}
Widget uiIconButton(IconData i, VoidCallback onPressed) => 
  IconButton(
    onPressed: onPressed,
    icon: Icon(i, size: 30,)  
  );

Widget uiIconTextButton(IconData i, String t, VoidCallback onPressed, Color fg, Color bg) =>
  ElevatedButton( 
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.elliptical(40, 80)),
      ),
      foregroundColor: fg,
      backgroundColor: bg,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(i),
        const SizedBox(width: 7),
        Text(t),
      ],
    ),
  );

Widget uiTextButton(String t, VoidCallback onPressed, Color fg, Color bg) =>
  OutlinedButton(
    style: OutlinedButton.styleFrom(
      shape: const RoundedRectangleBorder(
        //side: BorderSide.none,
      
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
      foregroundColor: fg,
      backgroundColor: bg,
    ),
    onPressed: onPressed,
    child: Text(t)
  );