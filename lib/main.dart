import 'package:bike_rental_2/constants.dart';
import 'package:bike_rental_2/screens/start_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BikeRental',
      theme: ThemeData(
        fontFamily: 'Comfortaa',
        useMaterial3: true,
        scaffoldBackgroundColor: surfaceColor,
        colorScheme: .fromSeed(seedColor: primaryColor),
        appBarTheme: AppBarTheme(
          backgroundColor: surfaceColor,
          foregroundColor: onSurfaceColor,
          elevation: 0,
          //scrolledUnderElevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontFamily: 'Comfortaa',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: onSurfaceColor,
          ),
          iconTheme: const IconThemeData(color: onSurfaceColor, size: 24),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
      ),
      home: const StartPage(),
    );
  }
}
