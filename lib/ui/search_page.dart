import 'user_page.dart';
import 'package:flutter/material.dart';
import 'package:dotConnect/model/user_items.dart';
import 'package:dotConnect/util/database_client.dart';
import 'login_signup.dart';
import 'sign_up.dart';
import 'profile.dart';
import 'connections.dart';
import 'upload_item.dart';

class search_page extends StatefulWidget {
  final String search;
  final String username;
  search_page({Key key, this.search,this.username}):super(key:key);

//  String get  => username;

  @override
  _search_pageState createState() => _search_pageState();
}

class _search_pageState extends State<search_page> {

  TextEditingController _search = new TextEditingController();
  var db=new DatabaseHelper();

  List<dynamic> search_item = new List<dynamic>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _search.text=widget.search;
    searchUser(widget.username,_search.text);
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
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: AssetImage('images/male-icon.png'),
                              fit: BoxFit.fill
                          ),
                        ),
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
//                            Navigator.push(
//                                context,
//                                new MaterialPageRoute(builder: (BuildContext context){
//                                  return new search_page(username: widget.username,search: _search.text,);
//                                })
//                            );
                            searchUser(widget.username,_search.text);
                          },
                        ),
                      ],
                    ),
                    new Flexible(
                      child: new ListView.builder(
                          padding: new EdgeInsets.all(8.0),
                          //reverse: false,
                          itemCount: search_item.length,
                          itemBuilder: (_,int index){
                            return new Card(
                              color: Colors.white70,
                              child: new ListTile(
                                title: new Text("${search_item[index].username}"),
                                trailing: new Listener(
                                  key: new Key(search_item[index].username),
                                  child: new Icon(Icons.add, color: Colors.black87,),
                                  onPointerDown: (pointerEvent)=> {
                                    debugPrint("user ${search_item[index].username} followed"),
                                    _showFollowStatus(search_item[index].username,index)
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

  void searchUser(String username,String pattern) async{

      if((await db.searchItem(username,pattern)) == null)
        {
            setState(() {
              _search.text="";
              search_item=[];
            });
            var alert=new AlertDialog(
            content: new Container(
              height: 50.0,
              width: 50.0,
              child: new Center(
                  child: new Text(
                    "No Match",
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


      else{
        List<dynamic> res = await db.searchItem(username,pattern);
        setState(() {
          search_item = res;

        });
        for(int i=0;i<search_item.length;i++)
        {
          print(search_item[i].username);
        }
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

  void _showFollowStatus(String username,int index) async{

    connections item=new connections(widget.username, username);
    int res = await db.saveConnection(item);
    print("connetion id $res saved");
    var alert=new AlertDialog(
      content: new Container(
        height: 50.0,
        width: 50.0,
        child: new Center(
            child: new Text(
              "user ${search_item[index].username} followed",
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
