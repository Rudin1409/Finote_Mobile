
import 'package:flutter/material.dart';
import 'package:myapp/screens/auth/welcome_screen.dart';
import 'package:myapp/screens/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finote',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Set the initial route to the welcome screen
      initialRoute: '/welcome',
      // Define the routes for your application
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/main': (context) => const MainScreen(),
      },
      // You can remove the 'home' property when using 'initialRoute'
      // home: const MainScreen(), 
    );
  }
}
