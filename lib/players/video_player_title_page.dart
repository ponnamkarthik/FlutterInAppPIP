import 'package:flutter/material.dart';
import 'package:fluttervideoinapppip/overlay_handler.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../constants.dart';

class VideoPlayerTitlePage extends StatefulWidget {
  @override
  _VideoPlayerTitlePageState createState() => _VideoPlayerTitlePageState();
}

class _VideoPlayerTitlePageState extends State<VideoPlayerTitlePage> {

  VideoPlayerController _videoPlayerController;
  double aspectRatio = 16/9;

  _initVideo() {

    _videoPlayerController = VideoPlayerController.network(
      "https://file-examples.com/wp-content/uploads/2017/04/file_example_MP4_640_3MG.mp4",
    );
    _videoPlayerController.setLooping(true);

    _videoPlayerController..initialize().then((value) {
      setState(() {
        aspectRatio = _videoPlayerController.value.aspectRatio ?? 16/9;
      });
      _videoPlayerController.play();
    });

    _videoPlayerController..addListener(() {
      setState(() {

      });
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<OverlayHandlerProvider>(
          builder: (context, overlayProvider, _) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if(!overlayProvider.inPipMode)
                SizedBox(height: 32.0,),
              _buildVideoPlayer(),
              if(!overlayProvider.inPipMode)
              Expanded(child: _buildVideosList()),
            ],
          );
        }
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return Consumer<OverlayHandlerProvider>(
      builder: (context, overlayProvider, _) {
        return Stack(
          overflow: Overflow.clip,
          children: <Widget>[
            Row(
              children: <Widget>[
                AnimatedContainer(
                  duration: Duration(milliseconds: 250),
                  width: overlayProvider.inPipMode ? (Constants.VIDEO_TITLE_HEIGHT_PIP*aspectRatio) : MediaQuery.of(context).size.width,
                  color: Colors.black,
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width,
                  ),
                  child: AspectRatio(
                    aspectRatio: aspectRatio,
                    child: VideoPlayer(
                      _videoPlayerController,
                    ),
                  ),
                ),
                if(overlayProvider.inPipMode)
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Provider.of<OverlayHandlerProvider>(context, listen: false).disablePip();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              "This is Title",
                            ),
                            Text(
                              "I am Description Here",
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                if(overlayProvider.inPipMode)
                  IconButton(
                    icon: Icon(
                      _videoPlayerController.value.isPlaying ? Icons.pause : Icons.play_arrow,
                    ),
                    onPressed: () {
                      if(_videoPlayerController.value.isPlaying) {
                        _videoPlayerController.pause();
                      } else {
                        _videoPlayerController.play();
                      }
                    },
                  ),
                if(overlayProvider.inPipMode)
                  IconButton(
                    icon: Icon(
                      Icons.close
                    ),
                    onPressed: () {
                      Provider.of<OverlayHandlerProvider>(context, listen: false).removeOverlay(context);
                    },
                  )
              ],
            ),
            if(!overlayProvider.inPipMode)
              Positioned(
                top: 8.0,
                left: 8.0,
                child: IconButton(
                    icon: Icon(Icons.keyboard_arrow_down),
                    color: Colors.white,
                    onPressed: () {
                      Provider.of<OverlayHandlerProvider>(context, listen: false).enablePip(aspectRatio);
                    }
                ),
              ),
          ],
        );
      }
    );
  }

  Widget _buildVideosList() {
    return Consumer<OverlayHandlerProvider>(
        builder: (context, overlayProvider, _) {
          if(overlayProvider.inPipMode) return Container();
          return AnimatedOpacity(
            duration: Duration(milliseconds: 500),
            opacity: overlayProvider.inPipMode ? 0 : 1,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                itemCount: 10,
                shrinkWrap: true,
                primary: false,
                separatorBuilder: (context, index) {
                  return Container(height: 8.0,);
                },
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Row(
                    children: <Widget>[
                      Container(
                        width: 150.0,
                        child: AspectRatio(
                          aspectRatio: 16/9,
                          child: Image.network(
                            "https://4.img-dpreview.com/files/p/E~TS590x0~articles/3925134721/0266554465.jpeg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Video Title",
                                  style: Theme.of(context).textTheme.headline6.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Video SubTitle Description",
                                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                                    color: Colors.grey
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
    );
  }
}
