import 'package:flutter/material.dart';
import 'Authentication.dart';
import 'package:joker/PhotoUpload.dart';
import 'Posts.dart';
import 'package:firebase_database/firebase_database.dart';
class HomePage extends StatefulWidget{
  //auth se json bhja h
  HomePage({
    this.auth,
    this.onSignedOut,
  });
  final AuthImplementation auth;
  final VoidCallback onSignedOut;

  @override
  State<StatefulWidget> createState() {

    return _HomePageState();
  }
}
class _HomePageState extends State<HomePage>{
  List<Posts> postslist = [];

  @override
  void initState() {
    super.initState();
    DatabaseReference postsRef = FirebaseDatabase.instance.reference().child("Posts");
    postsRef.once().then((DataSnapshot snap){
      var keys = snap.value.keys;
      var data = snap.value;
      postslist.clear();

      for(var individualKeys in keys){
        Posts posts = new Posts(
          data[individualKeys]['image'],
          data[individualKeys]['description'],
          data[individualKeys]['date'],
          data[individualKeys]['time'],
        );
        postslist.add(posts);
      }
      setState(() {
        print('Length : $postslist.length'); 
      });
    });
  }

  void _logoutUser() async{
    try{
      await widget.auth.signOut();
      widget.onSignedOut();
    }
    catch(e){
      print("Error:"+e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Home'),
      ),
      body: new Container(
          child: postslist.length == 0 ? new Text("No blog posts available") : new ListView.builder(
            itemCount: postslist.length,
            itemBuilder: ( _, index){
              return PostsUI(postslist[index].image,postslist[index].description,postslist[index].date,
                              postslist[index].time);
            }
          ),
      ),

      bottomNavigationBar: new BottomAppBar(
        color: Colors.amber,
        child: new Container(
          margin: const EdgeInsets.only(left: 60.0 , right: 60.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,

            children: <Widget>[
              new IconButton(
                icon: new Icon(Icons.local_car_wash),
                iconSize: 30,
                color: Colors.white,
                onPressed: _logoutUser,
              ),

              new IconButton(
                icon: new Icon(Icons.add_a_photo),
                iconSize: 30,
                color: Colors.white,
                onPressed: (){
                  Navigator.push
                  (
                    context, 
                    MaterialPageRoute(builder: (context){
                      return new UploadPhotoPage();
                    })
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget PostsUI(String image , String description , String date , String time){
    return new Card(
      elevation: 10.0,
      margin: EdgeInsets.all(15.0),
      child: new Container(
        padding: new EdgeInsets.all(14.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
               
                new Text(
                  date,
                  style:Theme.of(context).textTheme.subtitle,
                  textAlign: TextAlign.center,
                 ),


                new Text(
                  time,
                  style:Theme.of(context).textTheme.subtitle,
                  textAlign: TextAlign.center,
                ),

              ],
            ),

            SizedBox(height: 10.0,),

            new Image.network(image , fit :BoxFit.cover),

            SizedBox(height: 10.0,),

            new Text(
                  description,
                  style:Theme.of(context).textTheme.subhead,
                  textAlign: TextAlign.center,
                ),

          ],
        ),
      ),
    );
  }
}