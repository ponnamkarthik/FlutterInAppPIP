import 'package:flutter/material.dart';
import 'package:fluttervideoinapppip/overlay_handler.dart';
import 'package:fluttervideoinapppip/overlay_service.dart';
import 'package:fluttervideoinapppip/players/video_player_title_page.dart';
import 'file:///C:/Users/ponna/Desktop/code/Tuts/flutter_video_inapp_pip/lib/players/video_player_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OverlayHandlerProvider>(
      create: (_) => OverlayHandlerProvider(),
      child: MaterialApp(
        title: 'InApp PIP',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Flutter InApp PIP'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  _addVideoOverlay() {
    OverlayService().addVideosOverlay(context, VideoPlayerPage());
  }
  _addVideoWithTitleOverlay() {
    OverlayService().addVideoTitleOverlay(context, VideoPlayerTitlePage());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(Provider.of<OverlayHandlerProvider>(context, listen: false).overlayActive) {
          Provider.of<OverlayHandlerProvider>(context, listen: false).enablePip(1.77);
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Text("Add Video With Drag Overlay"),
                onPressed: () {
                  _addVideoOverlay();
                },
              ),
              RaisedButton(
                child: Text("Add Video With Title Overlay"),
                onPressed: () {
                  _addVideoWithTitleOverlay();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
