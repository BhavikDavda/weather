import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/provider/theme_provider.dart';
import 'package:weather/provider/web.dart';
import 'package:weather/view/screens/addlocation_page.dart';
import 'package:weather/view/screens/home_page.dart';
import 'package:weather/view/screens/splashscreen.dart';
import 'package:weather/view/screens/them.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => WebProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'SplashScreen',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeProvider.getThemeMode() == ThemeMode.system
          ? ThemeMode.system
          : themeProvider.getThemeMode(),
      routes: <String, WidgetBuilder>{
        '/': (context) => HomeScreen(),
        'WeatherScreen':(context)=> WeatherScreen(),
        'SplashScreen': (context) => SplashScreen(),
      },
    );
  }
}