import 'package:flutter/material.dart';
import 'package:fluttervideoinapppip/overlay_handler.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerPage extends StatefulWidget {
  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {

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
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            _buildVideoPlayer(),
            Expanded(child: _buildVideosList()),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return Consumer<OverlayHandlerProvider>(
      builder: (context, overlayProvider, _) {
        return Stack(
          overflow: Overflow.clip,
          children: <Widget>[
            Container(
              color: Colors.black,
              child: AspectRatio(
                aspectRatio: aspectRatio,
                child: VideoPlayer(
                  _videoPlayerController,
                ),
              ),
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
            if(overlayProvider.inPipMode)
              Positioned(
                top: 0,
                left: 0,
                bottom: 0,
                right: 0,
                child: InkWell(
                  onTap: () {
                    Provider.of<OverlayHandlerProvider>(context, listen: false).disablePip();
                  },
                  child: Container(),
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
