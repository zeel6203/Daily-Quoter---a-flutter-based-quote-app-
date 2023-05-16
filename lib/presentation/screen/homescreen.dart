import 'dart:math';
import 'dart:ui';

import 'package:api_to_sql/logic/cubit/post_cubit.dart';
import 'package:api_to_sql/logic/sqlite/databasehelper.dart';
import 'package:api_to_sql/presentation/screen/savedlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sqflite/sqflite.dart';
import '../../data/models/datamodel.dart';
import 'package:path/path.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final dbhelper = DatabaseHelper.instance;
  datamodel? currentquote;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Center(child: Text("Quote of the day")),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/saved");
            },
            icon: Icon(Icons.menu),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          BlocProvider.of<PostCubit>(context).fetchdata();
        },
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/th.jpeg'), fit: BoxFit.cover)),
          alignment: Alignment.center,
          child: ListView(children: [
            BlocConsumer<PostCubit, PostState>(
              listener: (context, state) {
                // TODO: implement listener
              },
              builder: (context, state) {
                if (state is PostInitial || state is PostLoading) {
                  return Center(child: Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: CircularProgressIndicator(color: Colors.black,),
                  ));
                } else if (state is PostLoaded) {
                  currentquote=state.quote;
                  //todo : databse
                  return mainbody(state.quote!);
                } else if (state is PostError) {
                  return Text("errror");
                } else {
                  return Text("unknown error");
                }
              },
            ),
          ]),
        ),
      ),
      extendBody: true,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: Row(

          // mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 20),
                child: ElevatedButton.icon(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.cyan),elevation: MaterialStateProperty.all(20)),
/// SAVE BUTTON
                  onPressed: () {
                    print(currentquote);
                    if(currentquote !=null){
                    _insert(currentquote!);}
                    // print(_read());

                  },
                  icon: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),

                    child: Icon(
                      Icons.bookmark_add,
                      size: 35,
                      color: Colors.white,
                    ),
                  ),
                  label: Text("save"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20, bottom: 20),
                child: BlocBuilder<PostCubit, PostState>(
                  builder: (context, state) {
                    if(state is PostInitial || state is PostLoading){
                      final state = context.watch<PostCubit>().state;
                      // print(state);
                      return ElevatedButton.icon(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.cyan),elevation: MaterialStateProperty.all(20)),
                        onPressed: () {
                          // BlocProvider.of<PostCubit>(context).fetchdata();
                        },
                        icon: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Icon(
                            Icons.arrow_forward_outlined,
                            size: 35,
                            color: Colors.white,
                          ),
                        ),
                        label: Text("next",style: TextStyle(fontWeight: FontWeight.bold),),
                      );
                    }
                    else if(state is PostLoaded){
                      print(state.quote!.tags);
                      return ElevatedButton.icon(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.cyan),elevation: MaterialStateProperty.all(20)),
                        onPressed: () {
                          BlocProvider.of<PostCubit>(context).fetchdata();
                        },
                        icon: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Icon(
                            Icons.arrow_forward_outlined,
                            size: 35,
                            color: Colors.white,
                          ),
                        ),
                        label: Text("next",style: TextStyle(fontWeight: FontWeight.bold),),
                      );
                    }
                    else{
                      return CircularProgressIndicator();
                    }
                  },
                ),
              ),
            ]),
      ),
    );
  }

  void _insert(datamodel data) async{
    print(data.tags);
    int? id= await dbhelper.insert(data);
    print(id);
  }




}

Widget mainbody(datamodel quote) {
  return Padding(
    padding: const EdgeInsets.all(11.0),
    child: Container(
      // color: Colors.blue.shade300,
      decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            // BoxShadow(color: Colors.black, blurRadius: 3, offset: Offset(1, 1))
          ]),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          // mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 0, right: 25, left: 25, top: 70),
              child: Container(
                child: Center(
                    child: Text("""" ${quote.content!} " """,
                        style: GoogleFonts.lemon(
                            color: Colors.white,
                            fontWeight: FontWeight.w100,
                            fontSize: 30,
                            shadows: [
                              Shadow(
                                  color: Colors.black,
                                  blurRadius: 10,
                                  offset: Offset(1, 1))
                            ]))),
                width: double.maxFinite,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              child: Center(
                  child: Text(
                    "-  ${quote.author!}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  )),
              // width: double.maxFinite,
              alignment: Alignment.centerRight,
            ),
            SizedBox(
              height: 30,
            ),

            SizedBox(
              height: 50,
            ),
            // Align(
            //   alignment: Alignment.centerLeft,
            //   child: Container(
            //     height: 50,
            //     // width: 5,
            //     child: ListView.builder(
            //         shrinkWrap: true,
            //         scrollDirection: Axis.horizontal,
            //         itemCount: quote.tags!.length,
            //         itemBuilder: (context, int index) {
            //           return Padding(
            //             padding: const EdgeInsets.all(8.0),
            //             child: Container(
            //               // margin: EdgeInsets.all(5),
            //               child: Padding(
            //                 padding: const EdgeInsets.all(8.0),
            //                 child: Text(quote.tags![index]),
            //               ),
            //               decoration: BoxDecoration(
            //                 color: Colors.grey.shade200,
            //                 borderRadius: BorderRadius.all(
            //                   Radius.circular(20),
            //                 ),
            //               ),
            //             ),
            //           );
            //         }),
            //   ),
            // ),
          ],
        ),
      ),
    ),
  );
}

