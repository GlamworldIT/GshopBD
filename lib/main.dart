import 'package:flutter/material.dart';
import 'package:gshop/pages/LoginPage.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: [
        Locale('en', 'US'),
      ],
      // localizationsDelegates: [
      //   CountryLocalizations.delegate,
      //
      //   ///Show country name in english
      // ],
      title: 'Glam Shop',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        canvasColor: Colors.transparent,
        cursorColor: Colors.deepOrange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LogIn(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// class SplashHomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return SplashScreen(
//       seconds: 3,
//       navigateAfterSeconds:LogIn(),
//       title: Text(
//         "Welcome to GShop",
//         style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: Colors.deepOrange,
//             fontSize: size.width/10),
//       ),
//       image: Image.asset(
//         "assets/gif/racket.gif",
//       ),
//       //backgroundColor: Colors.orange,
//       photoSize: 100.0,
//       loaderColor: Colors.transparent,
//       backgroundColor: Colors.white,
//       // gradientBackground: LinearGradient(
//       //   begin: Alignment.topCenter,
//       //   colors: [
//       //     Colors.white,
//       //     Colors.grey[50],
//       //     Colors.grey[100],
//       //     Colors.grey[200],
//       //   ],
//       // ),
//       loadingText: Text(
//         "Powered by Glamworld IT Ltd.",
//         style: new TextStyle(
//             fontWeight: FontWeight.bold,
//             color: Colors.grey[800],
//             fontSize: size.width/25
//         ),
//       ),
//     );
//   }
// }
