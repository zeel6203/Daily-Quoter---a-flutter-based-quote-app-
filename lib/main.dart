import 'package:api_to_sql/extra.dart';
import 'package:api_to_sql/logic/cubit/post_cubit.dart';
import 'package:api_to_sql/presentation/screen/homescreen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/repositary/apis/api.dart';

Future<void> main() async {
  // API api=API();
  // Response r= await api.sendrequest.get("/random");
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostCubit(),
      child: MaterialApp(
        home: Home(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
