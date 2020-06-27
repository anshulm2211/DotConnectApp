import 'connected_profile_page.dart';
import 'search_page.dart';
import 'user_page.dart';
import 'package:flutter/material.dart';
import 'package:dotConnect/model/user_items.dart';
import 'package:dotConnect/util/database_client.dart';
import 'login_signup.dart';
import 'sign_up.dart';
import 'profile.dart';
import 'upload_item.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

class Connections extends StatefulWidget {
  final String username;
  Connections({Key key, this.username}):super(key:key);

  String get _username => username;

  @override
  _Connections_State createState() => _Connections_State();
}

class _Connections_State extends State<Connections> {

  TextEditingController _search = new TextEditingController();
  var db=new DatabaseHelper();
  var connection_list = [];

  profile_item item;
  String profile_image;

  void getProfileData() async{
    profile_item res=await db.getProfile(widget.username);
    int count = await db.getConnectionCount(widget.username);
    if(res != null){
      setState(() {
        item = res;
        profile_image = item.image;
      });
    }
    else{
      setState(() {
        item=null;
      });
    }
  }


  void searchConnection(String username) async{

    if((await db.getConnections(username)) == null)
      {
        setState(() {
          connection_list=[];
        });
      }

    else{
      List<dynamic> res=await db.getConnections(username);
      setState(() {
        connection_list=res;
      });
      for(int i=0;i<connection_list.length;i++)
      {
        print(connection_list[i].connection);
      }
    }


  }

  void initState() {
    // TODO: implement initState
    super.initState();
    connection_list=[];
    searchConnection(widget.username);
    getProfileData();
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
                      new Padding(padding: EdgeInsets.all(15)),
                      Container(
                          child: item == null ?
                          new Image.asset('images/male-icon.png', height: 70, width: 70,)
                              :
                          new ClipOval(
                            child: new Image.file(File(profile_image), height: 80, width: 80, fit: BoxFit.cover,),
                          )
                      ),
                    ],
                  )
              ),
              ListTile(
                  title: new FlatButton(
                      onPressed: (){
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
              //new Padding(padding: const EdgeInsets.all(10)),
              ListTile(
                  title: new FlatButton(
                      onPressed: (){
//                      Navigator.push(
//                          context,
//                          new MaterialPageRoute(builder: (BuildContext context){
//                            return new profile_page(username: widget.username,);
//                          })
//                      );
                        null;
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
        body: new Container(
            margin : const EdgeInsets.all(10),
            child: Center(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Row(
                      children: <Widget>[
                        new Container(
                          height: 50,
                          width: 300,
                          child: new TextField(
                            controller: _search,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:Colors.black87
                                  ),
                                  borderRadius: BorderRadius.circular(25)
                              ) ,
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:Colors.black87
                                  ),
                                  borderRadius: BorderRadius.circular(25)
                              ) ,
                              hintText: "search username",
                              hintStyle: new TextStyle(
                                  color: Colors.black54,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 17
                              ),
                            ),
                          ),
                        ),
                        new Padding(padding: const EdgeInsets.all(10)),
                        new IconButton(
                          icon: new Icon(Icons.search),
                          onPressed: (){
                            Navigator.push(
                                context,
                                new MaterialPageRoute(builder: (BuildContext context){
                                  return new search_page(username: widget.username,search: _search.text,);
                                })
                            );
                          },
                        ),
                      ],
                    ),

                  connection_list.length == 0 ?
                      new Container(
                        height: 400,
                        width: 400,
                        child: new Center(
                          child: new Text(
                              "NO CONNECTIONS",
                             style: new TextStyle(
                               fontSize: 20,
                             ),
                          ),
                        ),
                      )
                      :
                      new Flexible(
                       child: new ListView.builder(
                        padding: new EdgeInsets.all(8.0),
                        //reverse: false,
                        itemCount: connection_list.length,
                        itemBuilder: (_,int index){
                          return new Card(
                            color: Colors.white70,
                            child: new ListTile(
                              title: new FlatButton(
                                  onPressed: (){
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(builder: (BuildContext context){
                                          return new connected_profile_page(username: widget.username,connect_username: connection_list[index].connection,);
                                        })
                                    );
                                  },
                                  child: new Text("${connection_list[index].connection}")
                              ),
                              trailing: new Listener(
                                key: new Key(connection_list[index].connection),
                                child: new Icon(Icons.remove_circle, color: Colors.black87,),
                                onPointerDown: (pointerEvent)=> {
                                  removeConnection(widget.username,connection_list[index].connection)
                                },
                              ),
                            ),
                          );
                        }
                    ),
                   ),

                  ],
                )
            )
        )
    );
  }

//  void searchUser(String username) async{
//
//    List<dynamic> items = await db.searchItem(username);
//    for(int i=0;i<items.length;i++)
//      {
//        print(items[i].username);
//      }
//    Navigator.push(
//        context,
//        new MaterialPageRoute(builder: (BuildContext context){
//          return new search_page(username: widget.username,search: _search.text,);
//        })
//    );
//  }

  void removeConnection(String username,String connection) async{

    int res = await db.deleteConnection(username, connection);
    List<dynamic> result=await db.getConnections(username);
    if(result == null) {
      setState(() {
        connection_list=[];
      });
    }
    else{
      setState(() {
        connection_list=result;
      });
    }
    var alert=new AlertDialog(
      content: new Container(
        height: 50.0,
        width: 50.0,
        child: new Center(
            child: new Text(
              "Connection $connection removed",
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
            Navigator.pop(context);
          },
          child: Text("OK"),
        ),

      ],
    );
    showDialog(

        context: context,
        builder: (_){
          return alert;
        }
    );

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
