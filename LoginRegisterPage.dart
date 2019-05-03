import 'package:flutter/material.dart';
import 'Authentication.dart';
import 'DialogBox.dart';

class LoginRegisterPage extends StatefulWidget{
  
  LoginRegisterPage({
    this.auth,
    this.onSignedIn
  });

  final AuthImplementation auth;
  final VoidCallback onSignedIn;

  State<StatefulWidget> createState(){
    return _LoginRegisterState();
  }
  
}
enum FormType{
  login,
  register
}

class _LoginRegisterState extends State<LoginRegisterPage>{
  DialogBox dialogBox = new DialogBox();
  final formkey = new GlobalKey<FormState>();
  FormType _formType = FormType.login;
  String _email = "";
  String _password  = "";

  bool validateAndSave(){
    final form = formkey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }
    else{
      return false;
    }
  }

  void validateAndSubmit() async{
    if(validateAndSave()){
      try{
        if(_formType == FormType.login){
          String userId = await widget.auth.SignIn(_email, _password);
          //dialogBox.information(context, "Congratulations", "U r now logged in");
          print("login user id = "  +userId);
        }
        else{
          String userId = await widget.auth.SignUp(_email, _password);
          print("Register user id = "  +userId);
          //dialogBox.information(context, "Congratulations ", "Ur account has been created successfully");
        }
        widget.onSignedIn();
      }
      catch(e){
        dialogBox.information(context, "Error = ", e.toString());
      }
    }
  }

  void moveToRegister(){
    formkey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }
  void moveToLogin(){
    formkey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }


  //designs
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("BlogApp"),
      ),

      body: new Container(
        margin: EdgeInsets.all(15.0),
        child: new Form(
          key: formkey,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: createInputs() + createButtons(),
          ),
        ),
      ), 
    );
  }
  
  List<Widget> createInputs(){
    return [
      SizedBox(height: 10.0,),
      logo(),
      SizedBox(height: 20.0,),

      new TextFormField(
          decoration: new InputDecoration(labelText: 'Email'),
          validator: (value){
            return value.isEmpty ? 'Email is required' : null;
          },
          onSaved:(value){
            print("Email h:"+value);
            return _email = value;
          }
      ),

      SizedBox(height: 10.0,),

      new TextFormField(
          decoration: new InputDecoration(labelText: 'Password'),
          obscureText: true,
          validator: (value){
            return value.isEmpty ? 'Password is required' : null;
          },
          onSaved:(value){
            return _password = value;
          }
      ),


      SizedBox(height: 20.0,),


    ];
  }
  
  Widget logo(){
    return new Hero(
      tag: 'hero',
      child: new CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 60.0,
        child: Image.asset('images/logo.png'),
      ),
    );
  }

  List<Widget> createButtons(){
    if(_formType == FormType.login){
      return [
        new RaisedButton(
          textColor: Colors.white,
          child: new Text('Login' , style: new TextStyle(fontSize: 20.0)),
          //textColor: Colors.white,
          color: Colors.amber,
          onPressed: validateAndSubmit,
        ),

        new FlatButton(
          child: new Text('Not have an account ? Create Account' , style: new TextStyle(fontSize: 14.0)),
          onPressed: moveToRegister,
        ),
      ];
    }
    else{
      return [
        new RaisedButton(
          textColor: Colors.white,
          child: new Text('Create Account' , style: new TextStyle(fontSize: 20.0)),
          //textColor: Colors.white,
          color: Colors.amber,
          onPressed: validateAndSubmit,
        ),

        new FlatButton(
          child: new Text('Already have an account? Login' , style: new TextStyle(fontSize: 14.0)),
          onPressed: moveToLogin,
        ),
      ];
    }
  } 
}