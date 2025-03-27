import 'package:age_fact_ai/pages/home_page_mobile.dart';
import 'package:age_fact_ai/pages/home_page_web.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'agefactsai',
          home: constraints.maxWidth >= 600 ? HomePageWeb() : HomePageMobile()
        );
      },
    );
  }
}
