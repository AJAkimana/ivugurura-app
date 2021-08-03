import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget{

  @override
  SettingPageState createState() => SettingPageState();
}

class SettingPageState extends State<SettingPage>{
  late bool _dark;

  @override
  void initState() {
    super.initState();
    _dark = false;
  }

  Brightness _getBrightness() => _dark ? Brightness.dark: Brightness.light;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        brightness: _getBrightness(),
      ),
      child: Scaffold(
        backgroundColor: _dark ? null : Colors.green.shade200,
        appBar: AppBar(
          elevation: 0,
          brightness: _getBrightness(),
          iconTheme: IconThemeData(
              color: _dark? Colors.white : Colors.grey.shade200
          ),
          backgroundColor: Colors.transparent,
          title: Text('Setting',
            style: TextStyle(color: _dark? Colors.white: Colors.black),
          ),
          actions: <Widget>[
            IconButton(onPressed: (){
              setState(() {
                _dark = !_dark;
              });
            }, icon: Icon(Icons.mood)),
          ],
        ),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Card(
                    elevation: 8.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)
                    ),
                    color: Colors.purple,
                    child: ListTile(
                      onTap: (){},
                      title: Text('Ivugurura n Ubugorozi',style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500
                      ),),

                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
