import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:media_booster/utils/allsongs.dart';
import 'package:video_player/video_player.dart';

import '../screens/video_detail_page.dart';

class VideoComponent extends StatefulWidget {
  const VideoComponent({super.key});

  @override
  State<VideoComponent> createState() => _VideoComponentState();
}

class _VideoComponentState extends State<VideoComponent> {
  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;
  bool isLoading = true;
  int index = 0;

  @override
  void initState() {
    super.initState();
    if (songList.isNotEmpty) {
      loadVideo(songList[0]['video']);
    }
  }

  Future<void> loadVideo(String videoPath) async {
    videoPlayerController = VideoPlayerController.asset(videoPath);
    await videoPlayerController!.initialize();

    chewieController = ChewieController(
      videoPlayerController: videoPlayerController!,
      autoPlay: false,
    );

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    videoPlayerController?.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          isLoading
              ? Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 20, right: 16, left: 16),
                  child: Column(
                    children: songList.map(
                      (e) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VideoDetailPage(
                                    videoUrl: e['video'],
                                    name: e['name'],
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 3,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 0),
                                      child: Container(
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              bottomLeft: Radius.circular(10)),
                                          image: DecorationImage(
                                            image: AssetImage(e['img']),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // Song name
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("${e['name']},",
                                                  style: GoogleFonts.mulish(
                                                    textStyle: const TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )),
                                            ],
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${e['artist']},", // Text to display
                                                style: GoogleFonts.mulish(
                                                  textStyle: const TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                textAlign: TextAlign
                                                    .start, // Align the text to the start
                                                maxLines:
                                                    1, // Restrict the text to a single line
                                                overflow: TextOverflow
                                                    .ellipsis, // Add ellipsis if text overflows
                                              ),
                                            ],
                                          ),

                                          Text(
                                            "${e['Description']}",
                                            style: GoogleFonts.mulish(
                                              textStyle: const TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            maxLines: 2, // Limit to 3 lines
                                            overflow: TextOverflow
                                                .ellipsis, // Adds '...' at the end if text exceeds 3 lines
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),
        ],
      ),
    ));
  }
}
