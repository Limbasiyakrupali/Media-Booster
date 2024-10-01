import 'package:flutter/material.dart';
import 'package:media_booster/provider/themeprovider.dart';
import 'package:media_booster/views/screens/homepage.dart';
import 'package:media_booster/views/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (BuildContext context) {
          return Themeprovider();
        }),
      ],
      builder: (context, _) {
        return MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: (Provider.of<Themeprovider>(context).istapped)
              ? ThemeMode.light
              : ThemeMode.dark,
          debugShowCheckedModeBanner: false,
          routes: {
            '/': (context) => SplashScreen(),
            'home': (context) => HomePage(),
          },
        );
      }));
}
