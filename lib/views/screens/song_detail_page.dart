import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

List<Map<String, String>> favoriteSongs = [];

class SongDetailPage extends StatefulWidget {
  const SongDetailPage({super.key});

  @override
  State<SongDetailPage> createState() => _SongDetailPageState();
}

class _SongDetailPageState extends State<SongDetailPage> {
  final AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();
  String audio = '';
  bool isPrepared = false;
  bool isFavorite = false;
  final int songIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    assetsAudioPlayer.dispose();
    super.dispose();
  }

  Future<void> openAudio() async {
    if (audio.isNotEmpty && !isPrepared) {
      await assetsAudioPlayer.open(
        Audio(audio),
        autoStart: false,
        showNotification: true,
      );
      setState(() {
        isPrepared = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> alldata =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    audio = alldata['audio'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text("Music",
            style: GoogleFonts.mulish(
              textStyle: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            )),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                size: 24,
                color: isFavorite ? Colors.red : Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  isFavorite = !isFavorite;
                });

                if (isFavorite) {
                  bool alreadyAdded = favoriteSongs
                      .any((song) => song['name'] == alldata['name']);

                  if (!alreadyAdded) {
                    favoriteSongs
                        .add({'name': alldata['name'], 'img': alldata['img']});
                  }
                } else {
                  favoriteSongs
                      .removeWhere((song) => song['name'] == alldata['name']);
                }
              },
            ),
          )
        ],
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              clipBehavior: Clip.antiAlias,
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(
                "${alldata['img']}",
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              alldata['name'],
              style: GoogleFonts.mulish(
                textStyle: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () async {
                    final currentPosition =
                        await assetsAudioPlayer.currentPosition.first;
                    final newPosition =
                        currentPosition - const Duration(seconds: 10);
                    if (newPosition.inSeconds > 0) {
                      await assetsAudioPlayer.seek(newPosition);
                    } else {
                      await assetsAudioPlayer.seek(Duration.zero);
                    }

                    setState(() {});
                  },
                  icon: const Icon(Icons.skip_previous, size: 40),
                ),
                GestureDetector(
                  onTap: () async {
                    await openAudio();
                    if (assetsAudioPlayer.isPlaying.value) {
                      await assetsAudioPlayer.pause();
                    } else {
                      await assetsAudioPlayer.play();
                    }
                    setState(() {});
                  },
                  onLongPress: () async {
                    if (audio.isNotEmpty) {
                      await assetsAudioPlayer.stop();
                    }
                    setState(() {});
                  },
                  child: Icon(
                    assetsAudioPlayer.isPlaying.value
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill,
                    size: 45,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    final currentPosition =
                        await assetsAudioPlayer.currentPosition.first;
                    final totalDuration =
                        assetsAudioPlayer.current.value?.audio.duration;
                    if (totalDuration != null) {
                      final newPosition =
                          currentPosition + const Duration(seconds: 10);
                      if (newPosition < totalDuration) {
                        await assetsAudioPlayer.seek(newPosition);
                      } else {
                        await assetsAudioPlayer.seek(totalDuration);
                      }

                      setState(() {});
                    }
                  },
                  icon: const Icon(Icons.skip_next, size: 40),
                ),
              ],
            ),
            const SizedBox(height: 20),
            StreamBuilder<Duration>(
              stream: assetsAudioPlayer.currentPosition,
              builder: (context, snapshot) {
                Duration? currentPosition = snapshot.data;

                return StreamBuilder<Playing?>(
                  stream: assetsAudioPlayer.current,
                  builder: (context, ss) {
                    Playing? playing = ss.data;
                    Duration? totalDuration = playing?.audio.duration;

                    return Column(
                      children: [
                        Slider(
                          min: 0,
                          max: totalDuration?.inSeconds.toDouble() ?? 0.0,
                          value: currentPosition?.inSeconds.toDouble() ?? 0.0,
                          onChanged: (value) {
                            assetsAudioPlayer
                                .seek(Duration(seconds: value.toInt()));
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 23, right: 23),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  "${currentPosition?.toString().split(".")[0] ?? '0:00'}"),
                              Text(
                                "${totalDuration?.toString().split(".")[0] ?? '0:00'}",
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void navigateToSong(int index) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SongDetailPage()),
    );
  }
}
