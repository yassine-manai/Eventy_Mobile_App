import 'package:flutter/material.dart';
import 'screens/event_list_screen.dart';
import 'screens/login_screen.dart'; // Import the LoginScreen
import 'screens/register_screen.dart'; // Import the RegisterScreen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Events App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginScreen(), // Set LoginScreen as the initial screen
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => EventListScreen(),
      },
    );
  }
}