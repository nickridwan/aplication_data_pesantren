import 'package:flutter/material.dart';

class popUpMenu extends StatelessWidget {
  final List<PopupMenuEntry> ListMenu;
  final Widget? icon;
  const popUpMenu({Key? key, required this.ListMenu, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      color: Colors.greenAccent[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      itemBuilder: ((context) => ListMenu),
      icon: icon,
    );
  }
}
