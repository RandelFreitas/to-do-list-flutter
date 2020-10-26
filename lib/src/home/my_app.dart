//CLASSE PRINCIPAL DO SISTEMA
import 'package:flutter/material.dart';
import 'package:hello/src/login/login_page.dart';
//import 'home_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}
