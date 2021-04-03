import 'package:flutter/material.dart';
import 'package:github_user/view/userList.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Git User',
      theme: ThemeData(
       
        primarySwatch: Colors.blue,
      ),
      home: GitUserList(),
    );
  }
}
