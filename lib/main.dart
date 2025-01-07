import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sql_lite/service/navigation_key.dart';
import 'package:sql_lite/screen/home_bloc_screen.dart';
import 'package:sql_lite/bloc/home_screen/home_bloc.dart';
import 'package:sql_lite/bloc/image_picker/image_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(create: (_) => HomeBloc()),
        BlocProvider<ImageBloc>(create: (_) => ImageBloc()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        home: HomeBlocScreen(),
      ),
    );
  }
}
