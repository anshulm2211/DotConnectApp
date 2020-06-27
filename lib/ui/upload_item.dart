import 'search_page.dart';
import 'user_page.dart';
import 'package:flutter/material.dart';
import 'package:dotConnect/model/user_items.dart';
import 'package:dotConnect/util/database_client.dart';
import 'login_signup.dart';
import 'sign_up.dart';
import 'profile.dart';
import 'connections.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';

class upload_item extends StatefulWidget {
  final String username;
  upload_item({Key key, this.username}):super(key:key);

  String get _username => username;

  @override
  _upload_item_State createState() => _upload_item_State();
}

class _upload_item_State extends State<upload_item> {

  TextEditingController _search = new TextEditingController();
  var db=new DatabaseHelper();
  var upload_list = [];


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


  void searchUploads(String username) async{

    if((await db.getUploads(username)) == null)
    {
      setState(() {
        upload_list=[];
      });
    }

    else{
      List<dynamic> res=await db.getUploads(username);
      setState(() {
        upload_list=res;
      });
      for(int i=0;i<upload_list.length;i++)
      {
        print(upload_list[i].text);
      }
    }


  }

  void initState() {
    // TODO: implement initState
    super.initState();
    upload_list=[];
    searchUploads(widget.username);
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
                      Navigator.push(
                          context,
                          new MaterialPageRoute(builder: (BuildContext context){
                            return new Connections(username: widget.username,);
                          })
                      );
                        null;
                      },
                      child: new Text("Connections")
                  )
              ),
              ListTile(
                  title: new FlatButton(
                      onPressed: (){
                        null;
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
                    upload_list.length == 0 ?
                    new Container(
                      height: 400,
                      width: 400,
                      child: new Center(
                        child: new Text(
                          "NO UPLOADS",
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
                          itemCount: upload_list.length,
                          itemBuilder: (_,int index){
                            String image = upload_list[index].image;
                            String time = upload_list[index].time;
                            return new Container(
                              alignment: Alignment.topLeft,
                              child: new Column(
                                children: <Widget>[
                                  new Row(
                                    children: <Widget>[
                                      new ClipOval(
                                        child: new Image.file(File(profile_image), height: 35, width: 35, fit: BoxFit.cover,),
                                      ),
                                      new Padding(padding: const EdgeInsets.all(0)),
                                      new FlatButton(
                                          onPressed: (){
                                            Navigator.push(
                                                context,
                                                new MaterialPageRoute(builder: (BuildContext context){
                                                  return new profile_page(username: widget.username,);
                                                })
                                            );
                                          },
                                          child: new Text(
                                            "${widget.username}",
                                            style: new TextStyle(
                                                fontSize: 20,
                                                fontStyle: FontStyle.italic,
                                                color: Colors.black87
                                            ),
                                          ),
                                      ),
                                      new IconButton(
                                          padding: const EdgeInsets.fromLTRB(140, 0, 0, 0),
                                          icon: new Icon(Icons.delete),
                                          onPressed: (){
                                            removeUpload(widget.username, upload_list[index].id);
                                          }
                                      )
                                    ],
                                  ),
                                  new Padding(padding: const EdgeInsets.all(5)),
                                  new Container(
                                    alignment: Alignment.topLeft,
                                    width: 350,
                                    height: 350,
                                    child: new Image.file(File(image), height: 340, width: 340, fit: BoxFit.cover, ),
                                  ),
                                  new Padding(padding: const EdgeInsets.all(5)),
                                  new Container(
                                    alignment: Alignment.topLeft,
                                    child: new Text(
                                      "${upload_list[index].text}",
                                      style: new TextStyle(
                                        fontSize: 18,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w300
                                      ),
                                    ),
                                  ),
                                  new Container(
                                    alignment: Alignment.topLeft,
                                    child: new Text(
                                      time.substring(11,16) + " , " +time.substring(0,11),
                                      style: new TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 15,
                                        fontStyle: FontStyle.italic

                                      ),
                                    ),
                                  ),
                                  new Padding(padding: const EdgeInsets.all(10))
                                  
                                ],
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



  void removeUpload(String username,int id) async{

    print(id);
    int res = await db.deleteUpload(username, id);
    print(res);
    List<dynamic> result=await db.getUploads(username);
    if(result == null) {
      setState(() {
        upload_list=[];
      });
    }
    else{
      setState(() {
        upload_list=result;
      });
    }


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
