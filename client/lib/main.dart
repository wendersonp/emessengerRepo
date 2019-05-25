import 'package:flutter/material.dart';

import 'package:messenger_app/screens/home/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "emessenger",
      theme: ThemeData(
        brightness: Brightness.light,
        textSelectionColor: Colors.white,
        primarySwatch: Colors.teal,
        primaryColor: Colors.white,
        accentColor: Colors.teal,
        highlightColor: Colors.white,
        hintColor: Colors.black54,
        bottomAppBarColor: Colors.white,
        appBarTheme: AppBarTheme(color: Colors.white),
        fontFamily: 'Montserrat',
        textTheme: TextTheme(
          body1: TextStyle(fontSize: 20.0, fontFamily: 'Montserrat',color: Colors.black, decorationColor: Colors.teal),
          title: TextStyle(color: Colors.white)
        )
        //primarySwatch: Colors.teal,
      ),
      home: MyHomePage(title: 'Protótipo',),
    );
  }
}

class MyHomePage extends StatefulWidget {
  //MyHomePage(this.title);
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginPage(),  //JASjas
    );
  }
} 