import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

class VideoDetailPage extends StatefulWidget {
  String videoUrl;
  String name;
  VideoDetailPage({super.key, required this.videoUrl, required this.name});

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  Future initializePlayer() async {
    videoPlayerController = VideoPlayerController.asset(widget.videoUrl);
    await Future.wait([videoPlayerController.initialize()]);
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      allowedScreenSleep: false,
      showOptions: true,
      allowPlaybackSpeedChanging: true,
      draggableProgressBar: true,
      showControls: true,
      allowFullScreen: true,
      looping: true,
      autoInitialize: true,
      showControlsOnInitialize: true,
    );
    setState(() {});
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController!.dispose();
    super.dispose();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name,
            style: GoogleFonts.mulish(
              textStyle: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            )),
        centerTitle: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          chewieController != null &&
                  chewieController!.videoPlayerController.value.isInitialized
              ? GestureDetector(
                  child: Chewie(
                    controller: chewieController!,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
