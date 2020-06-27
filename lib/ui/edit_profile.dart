
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'profile.dart';
import 'package:flutter/material.dart';
import 'package:dotConnect/model/user_items.dart';
import 'package:dotConnect/util/database_client.dart';
import 'login_signup.dart';
import 'sign_up.dart';
import 'user_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'connections.dart';
import 'upload_item.dart';

class edit_profile_page extends StatefulWidget {

  final String username;
  String profile_image;
  final int flag;
  edit_profile_page({Key key, this.username,this.profile_image,this.flag}):super(key:key);

  @override
  _edit_profile_pageState createState() => _edit_profile_pageState();
}



class _edit_profile_pageState extends State<edit_profile_page> {

  File image;
  String profile_pic;
  String _image;
  final picker=ImagePicker();
  TextEditingController _username = new TextEditingController();
  TextEditingController _fullname = new TextEditingController();
  TextEditingController _dob = new TextEditingController();
  TextEditingController _gender = new TextEditingController();

  var db=new DatabaseHelper();

  Future getImage_camera() async {
    //result=' ';
    final img = await picker.getImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      image = File(img.path);
      profile_pic = img.path.toString();

    });
  }

  Future getImage_gallery() async {
    //result=' ';
    final img = await picker.getImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      image = File(img.path);
      profile_pic = img.path.toString();
    });
  }

  Future<List<int>> testCompressFile(File file) async {
    print("testCompressFile");
    final result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 2300,
      minHeight: 1500,
      quality: 94,
      rotate: 180,
    );
    print(file.lengthSync());
    print(result.length);
    return result;
  }

  void makeProfile(String fullname,String dob,String gender) async{
    _fullname.clear();
    _gender.clear();
    _dob.clear();
    profile_item item = new profile_item(widget.username, fullname, gender, dob, profile_pic);
    int res = await db.saveProfile(item);
    print("profile $res made");
    Navigator.push(
        context,
        new MaterialPageRoute(builder: (BuildContext context){
          return new profile_page(username: widget.username,);
        })
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profile_pic=widget.profile_image;
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
                          child: profile_pic == null ?
                          new Image.asset('images/male-icon.png', height: 70, width: 70,)
                              :
                          new ClipOval(
                            child: new Image.file(File(profile_pic), height: 90, width: 90, fit: BoxFit.cover,),
                          )
                      ),
                    ],
                  )
              ),
              ListTile(
                  title: new FlatButton(
                      onPressed: (){ null;},
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
        body: new ListView(
          children: <Widget>[
            Container(
                margin: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Container(
                          child: profile_pic == null ?
                          new Image.asset('images/male-icon.png', height: 70, width: 70,)
                              :
                          new CircleAvatar(
                            radius: 63,
                            backgroundColor: Colors.black87,
                            child: new ClipOval(
                              child: new Image.file(File(profile_pic), height: 120, width: 120, fit: BoxFit.cover,),
                            ),
                          )
                      ),
                      new Padding(padding: const EdgeInsets.all(10)),

                      new Row(
                        children: <Widget>[
                          new Padding(padding: const EdgeInsets.fromLTRB(120, 0, 0, 0)),
                          new IconButton(
                              icon: new Icon(Icons.camera),
                              onPressed: getImage_camera,
                              iconSize: 35,
                          ),
                          new Padding(padding: const EdgeInsets.fromLTRB(40, 0, 0, 0)),
                          new IconButton(
                              icon: new Icon(Icons.image),
                              onPressed: getImage_gallery,
                            iconSize: 35,
                          ),
                          new Padding(padding: const EdgeInsets.fromLTRB(45, 0, 0, 0)),
                          widget.flag == 1 ?
                          new IconButton(
                            icon: new Icon(Icons.check),
                            onPressed: (){
                              updateProfileImage(widget.username, profile_pic);
                            },
                            iconSize: 35,
                          )
                          :
                          new Text(" ")
                          ,
                        ],
                      )
                    ],
                  ),
                )
            ),


            new Padding(padding: const EdgeInsets.all(10)),
            new Container(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0), //new Padding(padding: const EdgeInsets.all(10.0)),
              //width: 250.0,
              child: new TextField(
                controller: _fullname,
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
                    hintText: "Fullname",
                    hintStyle: new TextStyle(
                        color: Colors.black54,
                        fontStyle: FontStyle.italic,
                        fontSize: 17
                    )
                ),
              ),
            ),
            new Padding(padding: const EdgeInsets.all(10)),
            new Container(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0), //new Padding(padding: const EdgeInsets.all(10.0)),
              //width: 250.0,
              child: new TextField(
                controller: _gender,
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
                    hintText: "Gender",
                    hintStyle: new TextStyle(
                        color: Colors.black54,
                        fontStyle: FontStyle.italic,
                        fontSize: 17
                    )
                ),
              ),
            ),
            new Padding(padding: const EdgeInsets.all(10)),
            new Container(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0), //new Padding(padding: const EdgeInsets.all(10.0)),
              //width: 250.0,
              child: new TextField(
                controller: _dob,
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
                    hintText: "DOB : dd/mm/yyyy",
                    hintStyle: new TextStyle(
                        color: Colors.black54,
                        fontStyle: FontStyle.italic,
                        fontSize: 17
                    )
                ),
              ),
            ),
            new Padding(padding: const EdgeInsets.all(10)),

            new Row(
              children: <Widget>[
                new Padding(padding: const EdgeInsets.fromLTRB(150, 0, 0, 0)),
                widget.flag == 1?
                new RaisedButton(
                  onPressed: (){
                    updateProfileData(widget.username, _fullname.text, _gender.text, _dob.text);
                  },
                  child: new Icon(Icons.update,),
                  color: Colors.lightGreen,
                )
                :
                new RaisedButton(
                    onPressed: (){
                      makeProfile(_fullname.text, _dob.text, _gender.text);
                    },
                    child: new Icon(Icons.file_upload),
                    color: Colors.lightGreen,
                )
                ,
                
                

              ],
            )

          ],
        )
    );
  }

  void updateProfileData(String username, String fullname, String gender, String dob) async{
    int res = await db.updateProfileData(username, fullname, gender, dob);
    print("updated: $res");
    Navigator.push(
        context,
        new MaterialPageRoute(builder: (BuildContext context){
          return new profile_page(username: widget.username,);
        })
    );

  }

  void updateProfileImage(String username, String image) async{
    int res = await db.updateProfilePicture(username, image);
    print("updated : $res");
    Navigator.push(
        context,
        new MaterialPageRoute(builder: (BuildContext context){
          return new profile_page(username: widget.username,);
        })
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
