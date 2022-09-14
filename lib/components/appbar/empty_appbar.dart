import 'package:flutter/material.dart';

class EmptyAppBar extends StatefulWidget implements PreferredSizeWidget {
  const EmptyAppBar({Key key}) : super(key: key);

  @override
  State<EmptyAppBar> createState() => _EmptyAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(60);
}

class _EmptyAppBarState extends State<EmptyAppBar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox();
  }
}
