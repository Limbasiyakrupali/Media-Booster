import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:media_booster/utils/allsongs.dart'; // Assuming songList is in this file

import '../screens/song_detail_page.dart';

class AudioComponent extends StatefulWidget {
  @override
  _AudioComponentState createState() => _AudioComponentState();
}

class _AudioComponentState extends State<AudioComponent> {
  final AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();
  bool isPlaying = false;
  String? currentAudioPath;

  @override
  void initState() {
    super.initState();
    assetsAudioPlayer.playlistAudioFinished.listen((event) {
      setState(() {
        isPlaying = false;
        currentAudioPath = null;
      });
    });
  }

  @override
  void dispose() {
    assetsAudioPlayer.dispose();
    super.dispose();
  }

  void togglePlayPause(String audioPath) async {
    if (isPlaying && currentAudioPath == audioPath) {
      await assetsAudioPlayer.pause();
      setState(() {
        isPlaying = false;
      });
    } else {
      await assetsAudioPlayer.open(
        Audio(audioPath),
        autoStart: true,
        showNotification: true,
      );
      setState(() {
        isPlaying = true;
        currentAudioPath = audioPath;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Expanded(
              flex: 7,
              child: CarouselSlider.builder(
                itemCount: gujartisong.length,
                itemBuilder: (context, index, realIndex) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        gujartisong[index]['img'],
                        width: 350,
                        height: 210,
                        fit: BoxFit.cover,
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SongDetailPage(),
                              settings: RouteSettings(
                                arguments: {
                                  'img': gujartisong[index]['img'],
                                  'name': gujartisong[index]['name'],
                                  'audio': gujartisong[index]['audio'],
                                },
                              ),
                            ),
                          );
                        },
                        iconSize: 60,
                        icon: Icon(
                          Icons.slow_motion_video,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  );
                },
                options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  viewportFraction: 0.8,
                  autoPlayAnimationDuration: Duration(milliseconds: 1200),
                ),
              ),
            ),
            Expanded(
              flex: 14,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: songList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SongDetailPage(),
                          settings: RouteSettings(
                            arguments: {
                              'img': songList[index]['img'],
                              'name': songList[index]['name'],
                              'audio': songList[index]['audio'],
                            },
                          ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 3,
                      margin: const EdgeInsets.all(8),
                      child: Container(
                        padding: const EdgeInsets.only(left: 5),
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            // Song Image
                            Container(
                              clipBehavior: Clip.antiAlias,
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Image.asset(
                                "${songList[index]['img']}",
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 20),
                            // Song Name
                            Expanded(
                              child: Text("${songList[index]['name']}",
                                  style: GoogleFonts.mulish(
                                    textStyle: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  )),
                            ),
                            // Play/Pause Button
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconButton(
                                onPressed: () {
                                  togglePlayPause(songList[index]['audio']);
                                },
                                icon: Icon(
                                  isPlaying &&
                                          currentAudioPath ==
                                              songList[index]['audio']
                                      ? Icons.pause_circle_filled
                                      : Icons.play_circle_fill,
                                  color: Colors.black,
                                  size: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
