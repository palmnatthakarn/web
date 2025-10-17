import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_app/blocs/main/app_bloc.dart';
import 'package:flutter_web_app/screens/main/widgets_main/widgets.dart';

void main() {
  runApp(const MyApp());
}

/// MyApp is the main application widget.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF4C7FFF),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 188, 211, 249),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        scaffoldBackgroundColor: const Color(0xFFF3F7FF),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (_) => AppBloc(),
        child: const MainScreen(),
      ),
    );
  }
}

/// MainScreen is the main screen of the application.
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Row(
          children: const [
            // LeftNavigationPanel อยู่ด้านซ้ายตลอดแนว
            LeftNavigationPanel(),
            // ส่วนด้านขวาที่มี AppBar และ MainContent
            Expanded(
              child: Column(
                children: [
                  // CustomAppBar อยู่ด้านบนของพื้นที่ด้านขวา
                  CustomAppBar(),
                  // MainContentPanel อยู่ด้านล่าง AppBar
                  Expanded(child: MainContentPanel()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
