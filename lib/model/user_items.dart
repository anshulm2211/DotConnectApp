import 'package:flutter/material.dart';

class user_item {
  String _username;
  String _password;
  String _email;
  int _id;

  user_item(this._email,this._username,this._password);

  user_item.map(dynamic obj){
    this._username=obj['username'];
    this._password=obj['password'];
    this._email=obj['email'];
    this._id=obj['id'];
  }

  String get username=> _username;
  String get email => _email;
  int get id => _id;
  void set setId(int id)
  {
    _id=id;
  }

  Map<String,dynamic> toMap()
  {
    Map<String,dynamic> map=new Map<String,dynamic>();
    map['username']=_username;
    map['password']=_password;
    map['email']=_email;
    if(_id != null)
    {
      map["id"] = _id;
    }
    return map;
  }

  user_item.fromMap(Map<String,dynamic> map)
  {
    this._username=map["username"];
    this._password=map['password'];
    this._email=map["email"];
    this._id=map["id"];
  }

}

class connections{
  String _username;
  String _connection;
  int _id;

  connections(this._username,this._connection);

  connections.map(dynamic obj){
    this._username=obj['username'];
    this._connection=obj['connection'];
    this._id=obj['id'];
  }

  String get username=> _username;
  String get connection => _connection;
  int get id => _id;
  void set setId(int id)
  {
    _id=id;
  }

  Map<String,dynamic> toMap()
  {
    Map<String,dynamic> map=new Map<String,dynamic>();
    map['username']=_username;
    map['connection']=_connection;
    if(_id != null)
    {
      map["id"] = _id;
    }
    return map;
  }

  connections.fromMap(Map<String,dynamic> map)
  {
    this._username=map["username"];
    this._connection=map['connection'];
    this._id=map["id"];
  }


}

class profile_item{

  String _username;
  String _fullname;
  String _gender;
  String _dob;
  String _image;
  int _id;

  profile_item(this._username,this._fullname,this._gender,this._dob,this._image);

  profile_item.map(dynamic obj){
    this._username=obj['username'];
    this._fullname=obj['fullname'];
    this._gender=obj['gender'];
    this._dob=obj['dob'];
    this._image=obj['profile_pic'];
    this._id=obj['id'];
  }

  String get username=> _username;
  String get fullname => _fullname;
  int get id => _id;
  String get gender => _gender;
  String get dob => _dob;
  String get image => _image;
  void set setId(int id)
  {
    _id=id;
  }

  Map<String,dynamic> toMap()
  {
    Map<String,dynamic> map=new Map<String,dynamic>();
    map['username']=_username;
    map['fullname']=_fullname;
    map['gender']=_gender;
    map['dob']=_dob;
    map['profile_pic']=_image;
    if(_id != null)
    {
      map["id"] = _id;
    }
    return map;
  }

  profile_item.fromMap(Map<String,dynamic> map)
  {
    this._username=map["username"];
    this._fullname=map['fullname'];
    this._gender=map["gender"];
    this._dob=map['dob'];
    this._image=map['profile_pic'];
    this._id=map["id"];
  }


}

class Uploads{
  String _username;
  String _image;
  String _text;
  String _time;
  int _id;

  Uploads(this._username,this._text,this._time,this._image);

  Uploads.map(dynamic obj){
    this._username=obj['username'];
    this._text=obj['upload_text'];
    this._time=obj['upload_time'];
    this._image=obj['upload_image'];
    this._id=obj['id'];
  }

  String get username=> _username;
  String get image => _image;
  String get text => _text;
  String get time => _time;
  int get id => _id;
  void set setId(int id)
  {
    _id=id;
  }

  Map<String,dynamic> toMap()
  {
    Map<String,dynamic> map=new Map<String,dynamic>();
    map['username']=_username;
    map['upload_text']=_text;
    map['upload_time']=_time;
    map['upload_image']=_image;
    if(_id != null)
    {
      map["id"] = _id;
    }
    return map;
  }

  Uploads.fromMap(Map<String,dynamic> map)
  {
    this._username=map["username"];
    this._text=map['upload_text'];
    this._time=map['upload_time'];
    this._image=map['upload_image'];
    this._id=map["id"];
  }


}

