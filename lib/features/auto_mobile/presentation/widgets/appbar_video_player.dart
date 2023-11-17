import 'package:flutter/material.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/get_youtube_video_id.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class AppBarVideoPlayer extends StatefulWidget {
  final String videoUrl;

  const AppBarVideoPlayer({super.key, required this.videoUrl});

  @override
  State<AppBarVideoPlayer> createState() => _AppBarVideoPlayerState();
}

class _AppBarVideoPlayerState extends State<AppBarVideoPlayer> {
  YoutubePlayerController? _controller;

  @override
  void initState() {
    // requestPermission();

    videoPlayerInit();

    super.initState();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    // _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildFrame();
  }

  /*void requestPermission() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      // You can request multiple permissions at once.
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
        Permission.camera,
      ].request();
      print(statuses[Permission.storage]); // it should print PermissionStatus.granted
    }
  }*/

  void videoPlayerInit() {
    String? videoId = urlToVid(widget.videoUrl);
    //String videoId = url.split("si=").last;

    _controller = YoutubePlayerController(
      initialVideoId: videoId ?? "",
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: true,
        isLive: false,
      ),
    );
  }

  Widget _buildFrame() {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller!,
        showVideoProgressIndicator: true,
        bottomActions: [
          const SizedBox(width: 14.0),
          CurrentPosition(),
          const SizedBox(width: 8.0),
          ProgressBar(
            isExpanded: true,
            colors: const ProgressBarColors(
              playedColor: Colors.amber,
              handleColor: Colors.amberAccent,
            ),
          ),
          RemainingDuration(),
          const PlaybackSpeedButton(),
          // FullScreenButton(),
        ],
        /*progressIndicatorColor: Colors.amber,
        progressColors: const ProgressBarColors(
          playedColor: Colors.amber,
          handleColor: Colors.amberAccent,
        ),*/
      ),
      builder: (context, player) {
        return AspectRatio(
          aspectRatio: _controller!.value.playbackRate,
          // Use the VideoPlayer widget to display the video.
          child: player,
        );
      },
    );
  }

}
