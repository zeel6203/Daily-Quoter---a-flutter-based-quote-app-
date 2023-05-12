import 'package:api_to_sql/logic/cubit/post_cubit.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Center(child: Text("Quote of the day")),
        actions: [IconButton(onPressed: (){},icon: Icon(Icons.menu),)],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          BlocProvider.of<PostCubit>(context).fetchdata();
        },
        child: ListView(children: [
          BlocConsumer<PostCubit, PostState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              if (state is PostInitial) {
                return CircularProgressIndicator();
              } else if (state is PostLoaded) {
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
    );
  }
}

Widget mainbody(datamodel quote) {
  return Padding(
    padding: const EdgeInsets.all(11.0),
    child: Container(
      // color: Colors.blue.shade300,
      decoration: BoxDecoration(
          color: Colors.blue.shade300,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black, blurRadius: 3, offset: Offset(1, 1))
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(bottom: 0, right: 25, left: 25, top: 70),
            child: Container(
              child: Center(
                  child: Text("""" ${quote.content!} " """,
                      style: GoogleFonts.lemon(
                          color: Colors.white,
                          fontWeight: FontWeight.w100,
                          fontSize: 35,
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
          Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: Container(
              child: Row(

                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left:30),
                      child: ElevatedButton.icon(onPressed: () {  },icon: Icon(Icons.bookmark_add,size: 25,color: Colors.white,), label: Text("save"),
                       ),
                    ),
                    Container(
                      child: Center(child: Text("-  ${quote.author!}")),
                      // width: double.maxFinite,
                      alignment: Alignment.centerRight,
                    ),
                  ]),
            ),
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
  );
}
