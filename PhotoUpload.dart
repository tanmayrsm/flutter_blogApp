import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'HomePage.dart';


class UploadPhotoPage extends StatefulWidget{
  State<StatefulWidget> createState(){
    return _UploadPhotoPageState();
  }
}

class _UploadPhotoPageState extends State<UploadPhotoPage>{
  File sampleImage;

  String _myValue;

  String url;

  final formKey = new GlobalKey<FormState>();

  Future getImage() async{
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
     sampleImage = tempImage; 
    });
  }


  bool validateAndSave(){
    final form = formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }
    return false;
  }

  void uploadStatusImage() async{
    if(validateAndSave()){
      final StorageReference postImageRef = FirebaseStorage.instance.ref().child("Post Images");

      var timekey = new DateTime.now();

      final StorageUploadTask uploadtask = postImageRef.child(timekey.toString() + ".jpg").putFile(sampleImage);

      var Imageurl = await (await uploadtask.onComplete).ref.getDownloadURL();
      url = Imageurl.toString();
      print("Url of image:"+url);

      goToHomePage();
      saveToDatabase(url);

    }
  }

  void saveToDatabase(url){
    var dbTimekey = new DateTime.now();
    var formatDate = new DateFormat('MMM d, yyyy');
    var formatTime = new DateFormat('EEEE, hh:mm aaa');

    String date = formatDate.format(dbTimekey);
    print("dbdate:"+date);

    String time = formatTime.format(dbTimekey);
    print("dbtime:"+time);

    DatabaseReference ref = FirebaseDatabase.instance.reference();

    var data = {
      "image" : url,
      "description" : _myValue,
      "date" : date,
      "time" : time,
    };
    ref.child("Posts").push().set(data);
  }

  void goToHomePage(){
    Navigator.push(
      context, 
        MaterialPageRoute(builder: (context){
          return new HomePage();
        }
      )
    );
  }
  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Upload Photo"),
        centerTitle: true,
      ),
      body: new Center(
        child: sampleImage == null? Text("Select an image"): enableUpload(),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Add Image',
        child: new Icon(Icons.add_a_photo),
      ),
    );
  }
  Widget enableUpload(){
    return Container(
      child:new Form(
        key  :formKey,
              child: Column(
                children: <Widget>[
                  Image.file(sampleImage, height: 330.0,width: 660.0,),

                  SizedBox(height: 15.0,),

                  TextFormField(
                    decoration: new InputDecoration(labelText: 'Description'),
                    validator: (value){
                      return value.isEmpty ? 'Blog description is required' : null;
                    },
                    onSaved: (value){
                      return _myValue = value;
                    },
                  ),
                  SizedBox(height: 15.0,),

                  RaisedButton(
                    elevation: 10.0,
                    child: Text("Add this Post"),
                    textColor: Colors.white,
                    color: Colors.amber,

                    onPressed: uploadStatusImage,
                  )
                ],
              ),

      ),
    );
  }
}