import 'search_page.dart';
import 'user_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dotConnect/model/user_items.dart';
import 'package:dotConnect/util/database_client.dart';
import 'login_signup.dart';
import 'sign_up.dart';
import 'profile.dart';
import 'connections.dart';
import 'package:image_picker/image_picker.dart';
import 'upload_item.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'dart:io';

class upload_page extends StatefulWidget {
  final String username;
  upload_page({Key key, this.username}):super(key:key);

  String get _username => username;

  @override
  _upload_pageState createState() => _upload_pageState();
}

class _upload_pageState extends State<upload_page> {

  TextEditingController _uploadText = new TextEditingController();
  var db=new DatabaseHelper();
  profile_item item;
  String profile_image;
  String upload_image;
  File image;
  final picker = ImagePicker();


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

  Future getImage_camera() async {
    //result=' ';
    final img = await picker.getImage(source: ImageSource.camera, imageQuality: 20);

    setState(() {
      image = File(img.path);
      upload_image = img.path.toString();

    });
  }

  Future getImage_gallery() async {
    //result=' ';
    final img = await picker.getImage(source: ImageSource.gallery, imageQuality: 20);

    setState(() {
      image = File(img.path);
      print(img.path);
      upload_image = img.path.toString();
    });
  }

  void initState() {
    // TODO: implement initState
    super.initState();
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
                          child: Image.file(File(profile_image), height: 80, width: 80, fit: BoxFit.fill,)
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
        margin: const EdgeInsets.all(10),
        child: new Column(
          children: <Widget>[
            new Padding(padding: const EdgeInsets.all(10)),
            new Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              height: 30,
              width: 500,
              child: new Text(
                "Put anything you want....",
                style: new TextStyle(
                  fontSize: 22,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
            new Padding(padding: const EdgeInsets.all(10)),
            new Container(
              height: 100,
              width: 500,
              child: new TextField(
                maxLength: 100,
                controller: _uploadText,
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
                  hintText: "Put anything you want...",
                  hintStyle: new TextStyle(
                      color: Colors.black54,
                      fontStyle: FontStyle.italic,
                      fontSize: 17
                  ),
                ),
              ),
            ),
            //new Padding(padding: const EdgeInsets.all(10)),
            new Row(
              children: <Widget>[
                new IconButton(
                    icon: new Icon(Icons.camera),
                    onPressed: getImage_camera,
                    iconSize: 30,
                ),
                new Padding(padding: const EdgeInsets.all(10)),
                new IconButton(
                    icon: new Icon(Icons.image),
                    onPressed: getImage_gallery,
                    iconSize: 30,
                ),
                new Padding(padding: const EdgeInsets.all(10)),
                new IconButton(
                  icon: new Icon(Icons.file_upload),
                  onPressed: uploadContent,
                  iconSize: 30,
                ),
              ],
            ),
            new Padding(padding: const EdgeInsets.all(20)),
            new Flexible(
              child:
                  image != null ?
                    new Image.file(File(upload_image) ,height: 350, width: 350, )
                    :
                    new Center(
                      child: new Text("No Image"),
                    )
            )

          ],
        ),
      ),

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

  void uploadContent() async{

    Uploads item = new Uploads(widget.username, _uploadText.text, DateTime.now().toString(), upload_image);
    _uploadText.clear();
    int res = await db.saveUploadData(item);
    print("Uploaded successfully : $res");

    Navigator.push(
        context,
        new MaterialPageRoute(builder: (BuildContext context){
          return new user_page(username: widget.username,);
        })
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
