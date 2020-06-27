import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'profile.dart';
import 'package:flutter/material.dart';
import 'package:dotConnect/model/user_items.dart';
import 'package:dotConnect/util/database_client.dart';
import 'login_signup.dart';
import 'sign_up.dart';
import 'user_page.dart';
import 'edit_profile.dart';
import 'connections.dart';
import 'upload_item.dart';

class connected_profile_page extends StatefulWidget {

  final String username;
  final String connect_username;
  connected_profile_page({Key key, this.username,this.connect_username}):super(key:key);

  @override
  _connected_profile_pageState createState() => _connected_profile_pageState();
}

class _connected_profile_pageState extends State<connected_profile_page> {


  TextEditingController _search = new TextEditingController();
  var db=new DatabaseHelper();
  profile_item item;
  String connect_profile_image;
  String profile_image;
  int connection_count;
  int flag;

  void getConnectProfileData() async{
    profile_item res=await db.getProfile(widget.connect_username);
    int count = await db.getConnectionCount(widget.connect_username);
    if(res != null){
      setState(() {
        item = res;
        flag=1;
        connect_profile_image = item.image;
        count==null?connection_count=0:connection_count=count;
      });
    }
    else{
      setState(() {
        item=null;
        connect_profile_image = null;
        flag=0;
      });
    }
  }

  void getProfileData() async{
    profile_item res=await db.getProfile(widget.username);

    if(res != null){
      setState(() {
        item = res;
        profile_image = item.image;

      });
    }
    else{
      setState(() {
        item=null;
        profile_image = null;
      });
    }
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    getProfileData();
    getConnectProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new FlatButton(
            onPressed: (){
              Navigator.push(
                  context,
                  new MaterialPageRoute(builder: (BuildContext context){
                    return new user_page(username: widget.username,);
                  })
              );
            },
            child: new Text(
              'DOT CONNECT',
              style: new TextStyle(
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Colors.black87
              ),
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.lightGreen,
          actions: <Widget>[
            IconButton(
              icon: new Icon(Icons.power_settings_new),
              onPressed: do_logout,
              color: Colors.black87,
            ),

          ],
        ),
        drawer: new Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                  decoration: BoxDecoration(
                      color: Colors.lightGreen
                  ),
                  child: new Column(
                    children: <Widget>[
                      new Text(
                        "${widget.username}",
                        style: new TextStyle(
                          color: Colors.black87,
                          fontSize: 23,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      new Padding(padding: EdgeInsets.all(5)),
                      Container(
                          child: item == null ?
                          new Image.asset('images/male-icon.png', height: 70, width: 70,)
                              :
                          new ClipOval(
                            child: new Image.file(File(profile_image), height: 90, width: 90, fit: BoxFit.cover,),
                          )
                      ),
                    ],
                  )
              ),
              ListTile(
                  title: new FlatButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(builder: (BuildContext context){
                              return new profile_page(username: widget.username,);
                            })
                        );
                      },
                      child: new Text("Profile")
                  )
              ),
              ListTile(
                  title: new FlatButton(
                      onPressed: (){
                        Navigator.push(
                            context,
                            new MaterialPageRoute(builder: (BuildContext context){
                              return new Connections(username: widget.username,);
                            })
                        );
                      },
                      child: new Text("Connections")
                  )
              ),
              ListTile(
                  title: new FlatButton(
                      onPressed: (){
                        Navigator.push(
                            context,
                            new MaterialPageRoute(builder: (BuildContext context){
                              return new upload_item(username: widget.username,);
                            })
                        );
                      },
                      child: new Text("Uploads")
                  )
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        body: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
                margin: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Container(
                          child: item == null ?
                          new Image.asset('images/male-icon.png', height: 70, width: 70,)
                              :
                          new CircleAvatar(
                            radius: 63,
                            backgroundColor: Colors.black87,
                            child: new ClipOval(
                              child: new Image.file(File(connect_profile_image), height: 120, width: 120, fit: BoxFit.cover,),
                            ),
                          )
                      ),
                      new Padding(padding: const EdgeInsets.all(10)),
                      new Row(
                        children: <Widget>[
                          //new Padding(padding: const EdgeInsets.fromLTRB(135, 0, 0, 0)),
                          new Container(
                            height: 40,
                            width: 370,
                            child: new Center(
                              child: new Text(
                                widget.connect_username,
                                style: new TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.lightGreen
                                ),
                              ),
                            ),
                          )

                        ],
                      )
                    ],
                  ),
                )
            ),
            new Padding(padding: const EdgeInsets.all(20)),

            new Column(
              children: <Widget>[
                new Container(
                  width: 300,
                  child: new Card(
                    color: Colors.white70,
                    child: new ListTile(
                      title: new Text(
                        item.fullname,
                        style: new TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black
                        ),
                      ),
                    ),
                  ),
                ),
//                new Container(
//                  width: 300,
//                  child: new Card(
//                    color: Colors.white70,
//                    child: new ListTile(
//                      title: new Text(
//                        item.gender,
//                        style: new TextStyle(
//                            fontSize: 18,
//                            fontWeight: FontWeight.w600,
//                            color: Colors.black
//                        ),
//                      ),
//                    ),
//                  ),
//                ),
                new Container(
                  width: 300,
                  child: new Card(
                    color: Colors.white70,
                    child: new ListTile(
                      title: new Text(
                        item.gender,
                        style: new TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black
                        ),
                      ),
                    ),
                  ),
                ),
                new Container(
                  width: 300,
                  child: new Card(
                    color: Colors.white70,
                    child: new ListTile(
                      title: new Text(
                        "Connection : $connection_count",
                        style: new TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )


          ],
        )
    );
  }

  Future<int> checkProfile(String username) async{
    profile_item profile = await db.getProfile(username);
    if(profile == null) return 0;
    return 1;
  }

  void do_logout(){
    var alert=new AlertDialog(
      content: new Container(
        height: 50.0,
        width: 50.0,
        child: new Center(
            child: new Text(
              "You sure want to logout ?",
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
          onPressed: (){
            Navigator.push(
                context,
                new MaterialPageRoute(builder: (BuildContext context){
                  return new Login_page();
                })
            );
          },
          child: Text("YES"),
        ),

        new FlatButton(
          onPressed: ()=> Navigator.pop(context),
          child: Text("NO"),
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
