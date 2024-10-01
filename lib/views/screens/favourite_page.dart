import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:media_booster/views/screens/song_detail_page.dart';

import '../../utils/allsongs.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
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
      appBar: AppBar(
        title: Text(
          "Favorite Songs",
          style: GoogleFonts.mulish(
            textStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: favoriteSongs.isEmpty
          ? Center(
              child: Text(
                'No Favorite Songs',
                style: GoogleFonts.mulish(
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          : ListView.builder(
              itemCount: favoriteSongs.length,
              itemBuilder: (context, index) {
                return Card(
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
                            favoriteSongs[index]['img']!,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 20),
                        // Song Name
                        Expanded(
                          child: Text(favoriteSongs[index]['name']!,
                              style: GoogleFonts.mulish(
                                textStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )),
                        ),
                        // Play/Pause Button
                        IconButton(
                          onPressed: () {
                            togglePlayPause(songList[index]['audio']);
                          },
                          icon: Icon(
                            isPlaying &&
                                    currentAudioPath == songList[index]['audio']
                                ? Icons.pause_circle_filled
                                : Icons.play_circle_fill,
                            color: Colors.black,
                            size: 30,
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(
                                        "DELETE",
                                        style: GoogleFonts.mulish(
                                          textStyle: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      content: Text(
                                        "Are you sure want to delete this song?",
                                        style: GoogleFonts.mulish(
                                          textStyle: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      actions: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  "Cancel",
                                                  style: GoogleFonts.mulish(
                                                    textStyle: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                )),
                                            TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    favoriteSongs
                                                        .removeAt(index);
                                                  });
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  "Delete",
                                                  style: GoogleFonts.mulish(
                                                    textStyle: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ))
                                          ],
                                        )
                                      ],
                                    );
                                  });
                            },
                            icon: Icon(
                              Icons.delete,
                              size: 30,
                              color: Colors.black,
                            ))
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
