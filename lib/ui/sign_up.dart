import 'package:flutter/material.dart';
import 'login_signup.dart';
import 'home_page.dart';
import 'package:dotConnect/model/user_items.dart';
import 'package:dotConnect/util/database_client.dart';

class Sign_up extends StatefulWidget {
  @override
  _Sign_upState createState() => _Sign_upState();
}

class _Sign_upState extends State<Sign_up> {

  TextEditingController _username=new TextEditingController();
  TextEditingController _password=new TextEditingController();
  TextEditingController _confirmPassword=new TextEditingController();
  TextEditingController _email=new TextEditingController();

  var db=new DatabaseHelper();

  void add_user(String username,String password,String email) async
  {
    _username.clear();
    _password.clear();
    _email.clear();

//    user_item item=await db.getItem(username);
//    print(item.username);
    user_item item=new user_item(email, username, password);
    int savedItem=await db.saveItem(item);
    print("Item saved: $savedItem");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Stack(
        children: <Widget>[
          new Image.asset(
            'images/background.jpg',
            fit: BoxFit.fill,
            height: 1000.0,
            width: 450.0,
          ),
          new ListView(
            children: <Widget>[
              new Container(
                  margin: const EdgeInsets.fromLTRB(70, 140, 70, 20),
                  child: new FlatButton(
                    onPressed: (){
                      Navigator.push(
                          context,
                          new MaterialPageRoute(builder: (BuildContext context){
                            return new Home_page();
                          })
                      );
                    },
                    child: new Text(
                        "DOT CONNECT",
                        style: new TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize:30.0,
                            color: Colors.black87,
                            fontWeight: FontWeight.w600
                        )
                    ),
                  )
              ),
              new Container(
                  margin : const EdgeInsets.fromLTRB(50, 20, 50, 250),
                  child: Center(
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Image.asset(
                            'images/male-icon.png',
                            height: 50.0,
                            width: 50.0,
                          ),
                          new Padding(padding: const EdgeInsets.all(10)),
                          new TextField(
                            controller: _email,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:Colors.black87
                                    )
                                ) ,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:Colors.black87
                                    )
                                ) ,
                                hintText: "Email id",
                                hintStyle: new TextStyle(
                                    color: Colors.black54,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 17
                                )
                            ),
                          ),

                          new Padding(padding: const EdgeInsets.all(10)),
                          new TextField(
                            controller: _username,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:Colors.black87
                                  ),
                                ) ,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:Colors.black87
                                  ),
                                ) ,
                                hintText: "Username",
                                hintStyle: new TextStyle(
                                    color: Colors.black54,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 17
                                )
                            ),
                          ),

                          new Padding(padding: const EdgeInsets.all(10)),
                          new TextField(
                            controller: _password,
                            obscureText: true,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:Colors.black87
                                    )
                                ) ,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:Colors.black87
                                    )
                                ) ,
                                hintText: "Password",
                                hintStyle: new TextStyle(
                                    color: Colors.black54,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 17
                                )
                            ),
                          ),

                          new Padding(padding: const EdgeInsets.all(10)),
                          new TextField(
                            controller: _confirmPassword,
                            obscureText: true,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:Colors.black87
                                    )
                                ) ,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:Colors.black87
                                    )
                                ) ,
                                hintText: "Confirm Password",
                                hintStyle: new TextStyle(
                                    color: Colors.black54,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 17
                                )
                            ),
                          ),
                          new Padding(padding: const EdgeInsets.all(10)),
                          new Row(
                            children: <Widget>[
                              new Padding(padding: const EdgeInsets.all(45)),
                              new RaisedButton(
                                color: Colors.black54,
                                onPressed: (){
                                  if(_password.text != _confirmPassword.text){
                                    check_password();
                                  }
                                  else if(_password.text == _confirmPassword.text){
                                    //debugPrint(_username.text);
                                    check_username(_username.text);
                                  }
                                },
                                child: new Text(
                                  'Sign up',
                                  style: new TextStyle(
                                      fontStyle: FontStyle.normal,
                                      fontSize: 17,
                                      color: Colors.white70
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                  )
              )
            ],
          )
        ],
      ),
    );


  }

  void check_username(String username) async {
    var alert;
    user_item item= await db.getItem(username);
    if(item != null){
      alert=new AlertDialog(
        content:  new Container(
              child: new Text(
                "Username already exist",
                style: new TextStyle(
                  fontSize: 17,
                  fontStyle: FontStyle.normal,
                  color: Colors.black87,
                ),
              )
          ),
        actions: <Widget>[
          new FlatButton(
            onPressed: ()=> Navigator.pop(context),
            child: Text("OK"),
          )
        ],
      );
      print("${item.username}");
      showDialog(
          context: context,
          builder: (_){
            return alert;
          }
      );
    }
    else{
      add_user(_username.text,_password.text,_email.text);
      Navigator.push(
          context,
          new MaterialPageRoute(builder: (BuildContext context){
            return new Login_page();
          })
      );
    }
  }

  void check_password() async {

    var alert=new AlertDialog(
      content: new Container(
        height: 50.0,
        width: 50.0,
        child: new Center(
            child: new Text(
              "Password does not match",
              style: new TextStyle(
                fontSize: 18,
                fontStyle: FontStyle.normal,
                color: Colors.black87,
              ),
            )
        ),
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: ()=> Navigator.pop(context),
          child: Text("OK"),
        )
      ],
    );
    showDialog(

        context: context,
        builder: (_){
          return alert;
        }
    );
  }
}
