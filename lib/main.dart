import 'package:api_to_sql/extra.dart';
import 'package:api_to_sql/logic/cubit/post_cubit.dart';
import 'package:api_to_sql/logic/cubit/savedquotecubit_cubit.dart';
// import 'package:api_to_sql/logic/cubit/updatecubit/update_cubit.dart';
import 'package:api_to_sql/presentation/screen/homescreen.dart';
import 'package:api_to_sql/presentation/screen/savedlist.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:ThemeData(
          androidOverscrollIndicator: AndroidOverscrollIndicator.stretch
      ) ,

      home: BlocProvider(create: (context) => PostCubit(),

      child: Home(),


      ),
routes: {
        "/saved": (context)=>BlocProvider(create: (context) => SavedquotecubitCubit(), child: savedlist())
},

    );
  }

}
