import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mehndiorderwithdetabase/auth/auth_screen.dart';
import 'package:mehndiorderwithdetabase/firebase_options.dart';
import 'package:mehndiorderwithdetabase/home_page.dart';
import 'package:mehndiorderwithdetabase/screen/order.dart';

late Size mq;
final theme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: const Color.fromARGB(255, 131, 57, 0)),
    textTheme: GoogleFonts.latoTextTheme().copyWith(
      // Update the text colors for various text styles
      bodyText1: TextStyle(color: Colors.blue),
      // Example of changing bodyText1 color to black
      bodyText2: TextStyle(color: Colors.blue),
      // Example of changing bodyText2 color to black
      headline1: TextStyle(
          color: Colors.blue), // Example of changing headline1 color to black
      // Add more text styles as needed),
    ));

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // Loading indicator while checking auth state
            }
            if (snapshot.hasData) {
              return  OrderScreen();
            }
            return const AuthScreen();
          }),
    );
  }
}
