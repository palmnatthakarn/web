import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_app/blocs/main/app_bloc.dart';
import 'package:flutter_web_app/blocs/report/bloc.dart';
import 'package:flutter_web_app/repository/repository.dart';
import 'screens/main/main_screen.dart';
import 'theme/theme_web.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AppBloc()),
        BlocProvider(create: (_) => ReportBloc(ReportRepository())),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: Theme_Web.lightTheme,
        debugShowCheckedModeBanner: false,
        home: const MainScreen(),
      ),
    );
  }
}