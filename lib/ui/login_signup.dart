import 'package:flutter/material.dart';
import 'sign_up.dart';
import 'home_page.dart';
import 'package:dotConnect/util/database_client.dart';
import 'package:dotConnect/model/user_items.dart';
import 'user_page.dart';

class Login_page extends StatefulWidget {



  @override
  _Login_pageState createState() => _Login_pageState();
}

class _Login_pageState extends State<Login_page> {

  var db=new DatabaseHelper();

  TextEditingController _username=new TextEditingController();
  TextEditingController _password=new TextEditingController();

  Future<int> allow_user(String username,String password) async{
    //_username.clear();
    _password.clear();

    user_item item=await db.allowItem(username, password);
    if(item==null)
      {
        return 0;
      }
    return 1;
//    user_item item=await db.getItem(username);
//    print(item.username);

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
                                ),
                            ),
                          ),

                          new Padding(padding: const EdgeInsets.all(10)),
                          new Row(
                            children: <Widget>[
                              new Padding(padding: const EdgeInsets.all(15)),
                              new RaisedButton(
                                  color: Colors.black87,
                                  onPressed:  () { check_user(_username.text); },
                                  child: new Text(
                                    'Login',
                                    style: new TextStyle(
                                      fontStyle: FontStyle.normal,
                                      fontSize: 17,
                                      color: Colors.white
                                    ),
                                  ),
                              ),

                              new Padding(padding: const EdgeInsets.all(15)),
                              new RaisedButton(
                                color: Colors.black87,
                                onPressed: (){
                                  Navigator.push(
                                      context,
                                      new MaterialPageRoute(builder: (BuildContext context){
                                        return new Sign_up();
                                      })
                                  );
                                },
                                child: new Text(
                                  'Signup',
                                  style: new TextStyle(
                                      fontStyle: FontStyle.normal,
                                      fontSize: 17,
                                      color: Colors.white
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

  void check_user(String username) async {
    var alert;
    user_item item= await db.getItem(username);
    if(item == null){
      alert=new AlertDialog(
        content:  new Container(
            child: new Text(
              "User doesnot exist",
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
    }
    else{
      int flag =await allow_user(_username.text,_password.text);
      if(flag==0)
        {
          alert=new AlertDialog(
            content:  new Container(
                  child: new Text(
                    "Incorrect details",
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
        }
      else
        {
          debugPrint("user allowed");
          Navigator.push(
              context,
              new MaterialPageRoute(builder: (BuildContext context){
                return new user_page(username: _username.text,);
              })
          );
          return;
        }
    }
    showDialog(
        context: context,
        builder: (_){
          return alert;
        }
    );
  }
}



