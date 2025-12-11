import 'package:flutter/material.dart';
import 'package:krankmelde_app/Utility/Json.dart';
import 'package:krankmelde_app/Pages/MainPage/MainPage.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
  ]);
  runApp(
    // DevicePreview(
      // builder:  
      // (context) => 
      Phoenix(child: MyApp()),
    // ),
  );
}
 
class MyApp extends StatelessWidget {
  static final Json emailTemplate = Json(); 
  const MyApp({super.key,});

  @override
  Widget build(BuildContext context) {
    final darkColorScheme = ColorScheme(
      brightness: Brightness.dark,

      //TopBar und TopBar Schrift
      primary: Color(0xFF43555B),
      onPrimary: Color(0xFFFFFFFF),

      //BottomNavigationBar und deren Schrift
      secondary: Color(0xFF43555b),
      onSecondary: Color(0xFF000000),

      //Error Zeug
      error: Color.fromARGB(255, 218, 12, 9),
      onError: Color(0xFFFFFFFF),

      //Die Generelle Hintergrundfarbe und Schriftfarbe und Buttonfarbe
      surface: Color.fromARGB(255, 32, 31, 31),
      onSurface: Color(0xFFE0E0E0),
    );

    return MaterialApp(
      title: 'DRV CARE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.light,

          //TopBar und TopBar Schrift
          primary: Color(0xFF43555b),
          onPrimary: Color(0xFF000000),

          //BottomNavigationBar und deren Schrift
          secondary: Color(0xFF43555b), 
          onSecondary: Color(0xFFFFFFFF),  

          //Error Zeug
          error: Color.fromARGB(255, 226, 6, 6),       
          onError: Color(0xFFFFFFFF),

          //Die Generelle Hintergrundfarbe und Schriftfarbe und Buttonfarbe
          surface: Color(0xFFF5F5F5),
          onSurface: Color.fromARGB(255, 30, 29, 29), 
        ),
      ),

   
      darkTheme: ThemeData(
        colorScheme: darkColorScheme,
      ),


      themeMode: ThemeMode.system,

      home: MainPage(),
    );
  }
}
