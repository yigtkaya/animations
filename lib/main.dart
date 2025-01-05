import 'package:animations/image_carousel_with_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  // set navigation buttons on android white
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(systemNavigationBarColor: Colors.white));

  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: ImageCarouselView(),
      ),
    ),
  );
}
