import 'package:flutter/material.dart';
import 'dashboard_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // ignore: prefer_const_constructors
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          
          backgroundColor: Colors.blue,
          iconSize: 20
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
          elevation: 1,
        ),
        useMaterial3: true,
      ),
      home: const DashboardPage(),
    );
  }
}
