import 'package:flutter/material.dart';
import 'package:remark_app/components/appbar/appbar.dart';
import 'package:remark_app/components/drawer/application_drawer.dart';

class Template extends StatefulWidget {
  final Widget body;
  const Template({Key key, this.body}) : super(key: key);

  @override
  _TemplateState createState() => _TemplateState();
}

class _TemplateState extends State<Template> {

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      endDrawerEnableOpenDragGesture: false,
        appBar: AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      actions: [
      ],
    ),
      drawer: Drawer(
        child: ApplicationDrawer(),
      ),
      body: widget.body,
    );
  }
}
