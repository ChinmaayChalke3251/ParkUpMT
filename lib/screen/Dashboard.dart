import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';

class Dashoboard extends StatefulWidget {
  @override
  _DashoboardState createState() => _DashoboardState();
}

class _DashoboardState extends State<Dashoboard>with TickerProviderStateMixin {
  String _title = '';
  String _image = '';
  String _desc = '';
  bool isLoading;
  bool isClick;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  _register() {
    _firebaseMessaging.getToken().then((token) => print(token));
    _firebaseMessaging.subscribeToTopic('try');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = false;

    getMessage();
  }




  void getMessage(){
    _register();
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print('on message $message');
          setState(() {
            Wakelock.enable();
            _image = message["data"]["image"];
            _title = message["notification"]["title"];
            _desc = message["data"]["desc"];

          });
        },
        onResume: (Map<String, dynamic> message) async {
      print('on resume $message');
      setState(() {
        Wakelock.enable();
        _image = message["data"]["image"];
        _title = message["data"]["title"];
        _desc = message["data"]["desc"];

      });
    }, onLaunch: (Map<String, dynamic> message) async {
      print('on launch $message');
      setState(() {
        Wakelock.enable();
        _image = message["data"]["image"];
        _title = message["data"]["title"];
        _desc = message["data"]["desc"];

      });
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('FCM'),
        ),
        body: isLoading? Center(
          child: CircularProgressIndicator(backgroundColor: Colors.yellow,),)
            :Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5.0,10.0,5.0,0),
            child: Column(
                children: <Widget>[
                  Center(
                    child: CachedNetworkImage(
                      height: 200,
                      imageUrl: _image,
                      placeholder: (context,url) => CircularProgressIndicator(),
                   //   errorWidget: (context,url,error) => new Icon(Icons.cloud_download),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Text(_title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24.0),),
                    ),
                  ),
                 Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Container(
                      child: Text(_desc,style: TextStyle(fontWeight: FontWeight.normal,fontSize: 18.0),),
                    ),
                 ),
                  new RaisedButton(
                      child: new Text("Clear Notification",style: TextStyle(
                          fontSize: 18.0,color: Colors.white
                      ),),
                    padding: EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.white),),
                    color: Colors.blue,
                    splashColor: Colors.yellow,
                    disabledColor: Colors.grey,
                    onPressed: () {
                      setState(() {
                        _image = "";
                        _title = "";
                        _desc = "";
                      });
                    }
                  ),// Text("Message: $message")
                ]),
          ),
        ),
      ),
    );
  }
}
