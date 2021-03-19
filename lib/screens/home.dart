import 'package:flutter/material.dart';
import 'package:flutter_gmail_login/helper/app_state.dart';
import 'package:flutter_gmail_login/screens/homecontent.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  State createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('Demo'),
        ),
        body: ChangeNotifierProvider<AppState>(
          create: (_) => AppState(),
          child: SafeArea(
            child: Center(
              child: Container(
                height: 50,
                width: 200,
                child: TextButton(
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Show',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  style: TextButton.styleFrom(
                    primary: Colors.teal,
                    onSurface: Colors.white,
                    shadowColor: Colors.red,
                    elevation: 1,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (context) => HomeContent()),
                    );
                  },
                ),
              ),
            ),
          ),
        ));
  }
}
