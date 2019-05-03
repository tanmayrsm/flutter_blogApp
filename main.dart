import 'package:flutter/material.dart';
import 'Mapping.dart';
import 'Authentication.dart';

void main(){
  runApp(new BlogApp());
}
class BlogApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
      title: "BlogApp",
      theme: new ThemeData(
        primarySwatch: Colors.amber,
      ),

      home: MappingPage(auth: Auth(),),
    );
  }
}