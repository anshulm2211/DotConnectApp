import 'package:flutter/material.dart';
import 'login_signup.dart';

class Home_page extends StatefulWidget {
  @override
  _Home_pageState createState() => _Home_pageState();
}

class _Home_pageState extends State<Home_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.lightGreenAccent,
      body: new Stack(
        children: <Widget>[
          new Image.asset(
            'images/background.jpg',
            fit: BoxFit.fill,
            height: 1000.0,
            width: 450.0,
          ),
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Center(
                child: new FlatButton(
                    onPressed: (){
                      Navigator.push(
                          context,
                          new MaterialPageRoute(builder: (BuildContext context){
                            return new Login_page();
                          })
                      );
                    },
                    child: new Text(
                        "DOT CONNECT",
                        style: new TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize:40.0,
                            color: Colors.black87,
                            fontWeight: FontWeight.w600
                        )
                    ),
                )
              ),
//              new Padding(padding: const EdgeInsets.all(20)),
//              new Text(
//                "Welcome >>>>>",
//                style: new TextStyle(
//                  fontStyle: FontStyle.italic,
//                  fontSize: 25,
//                  color: Colors.black87,
//                ),
//              )
            ],
          )
        ],
      )
    );
  }
}
