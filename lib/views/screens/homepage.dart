import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:media_booster/provider/themeprovider.dart';
import 'package:media_booster/views/component/audio_component.dart';
import 'package:media_booster/views/component/video_component.dart';
import 'package:media_booster/views/screens/favourite_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.black),
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              child: Container(
                decoration: BoxDecoration(color: Colors.black),
                height: 150,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(
                            "https://i.pinimg.com/564x/3d/91/09/3d910919cf4d41c1114457504dc29201.jpg")),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.dark_mode),
              title: Text(
                'Change Theme',
                style: GoogleFonts.mulish(
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onTap: () {
                Provider.of<Themeprovider>(context, listen: false)
                    .Changetheme();
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text(
                'Add Favourite',
                style: GoogleFonts.mulish(
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FavouritePage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Music Player',
            style: GoogleFonts.mulish(
              textStyle: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            )),
        elevation: 0,
        bottom: TabBar(
          controller: tabController,
          indicatorColor: Colors.white,
          labelPadding: const EdgeInsets.symmetric(horizontal: 16),
          tabs: const [
            Tab(
              icon: Icon(
                Icons.music_note,
              ),
              text: "Audio",
            ),
            Tab(
              icon: Icon(
                Icons.video_library,
              ),
              text: "Video",
            ),
          ],
        ),
      ),
      body: Container(
        child: TabBarView(
          controller: tabController,
          physics: BouncingScrollPhysics(),
          children: [
            AudioComponent(),
            VideoComponent(),
            // VideoComponent(),
          ],
        ),
      ),
    );
  }
}
