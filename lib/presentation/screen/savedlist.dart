import 'dart:math';
import 'dart:ui';

import 'package:api_to_sql/data/models/datamodel.dart';
import 'package:api_to_sql/logic/cubit/savedquotecubit_cubit.dart';
// import 'package:api_to_sql/logic/cubit/updatecubit/update_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../logic/sqlite/databasehelper.dart';

class savedlist extends StatefulWidget {
  const savedlist({Key? key}) : super(key: key);

  @override
  State<savedlist> createState() => _savedlistState();
}

class _savedlistState extends State<savedlist> {
  final dbhelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar:
            AppBar(title: Text('Saved Quotes'), backgroundColor: Colors.black),
        body: RefreshIndicator(
          onRefresh: () async {},
          child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/img.png'), fit: BoxFit.cover)),
            alignment: Alignment.center,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaY: 50, sigmaX: 50),
                      // child:

                      // Padding(
                      // padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: TextField(
                        // out
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: "search",
                        ),
                        onChanged: (newvalue) {
                          BlocProvider.of<SavedquotecubitCubit>(context)
                              .fetchfromdb(texttofind: newvalue);
                        },
                      ),
                    ),
                    //   Icon(Icons.filter_list)
                  ),
                  // ),
                ),
                Expanded(
                  child: BlocConsumer<SavedquotecubitCubit, SavedquoteState>(
                    listener: (context, state) {
                      // TODO: implement listener
                    },
                    builder: (context, state) {
                      if (state is SavedquotecubitInitial) {
                        return Center(child: CircularProgressIndicator());
                      } else if (state is SavedLoaded) {
                        print("${state.saveddata} is already loaded");
                        return savedquotelist(state);
                      } else if (state is Empty) {
                        return Center(
                            child: Center(
                          child: Container(
                            width: 250,
                            height: 100,
                            decoration: BoxDecoration(color: Colors.orange),
                            child: Center(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "no results found ",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                            )),
                          ),
                        ));
                      } else {
                        return Text("error ");
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Future<List<dynamic>> _read() async {
    List<dynamic> data = await dbhelper.fetchSavedQuotes();
    print(data);
    print(data);
    return data;
  }
}

Widget savedquotelist(statedata) {
  return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: false,
      itemCount: statedata.saveddata?.length,
      itemBuilder: (context, index) {
        return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                    // height: 200,
                    // width: double.maxFinite,
                    decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black),
                        boxShadow: [
                          // BoxShadow(
                          //     color: Colors.black,
                          //     blurRadius: 2,
                          //     offset: Offset(2, 2))
                        ]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(11.0),
                                  child: Container(
                                      width: 290,
                                      child: Text(
                                          """ " ${statedata.saveddata?[index].content!} " """,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 8,
                                          style: GoogleFonts.lemon(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w100,
                                              fontSize: 20,
                                              shadows: [
                                                Shadow(
                                                    color: Colors.black,
                                                    blurRadius: 10,
                                                    offset: Offset(1, 1))
                                              ]))),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // copy to clipboard button
                                IconButton(
                                    onPressed: () {
                                      Clipboard.setData(ClipboardData(
                                          text: statedata
                                              .saveddata?[index].content!));
                                    },
                                    icon: Icon(
                                      Icons.copy_outlined,
                                      color: Colors.black,
                                    )),
                                // update button
                                IconButton(
                                    onPressed: () {
                                      //todo: update
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.yellow,
                                    )),
                                // delete button
                                IconButton(
                                    onPressed: () {
                                      BlocProvider.of<SavedquotecubitCubit>(
                                              context)
                                          .del(statedata.saveddata![index].id);
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    )),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 20),
                              child: Container(
                                  child: Text(
                                "-- ${statedata.saveddata?[index].author}",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(
                            //       vertical: 15.0, horizontal: 20),
                            //   child: Container(
                            //       child:ListView.builder(scrollDirection: Axis.horizontal,itemCount: statedata.saveddata?[index].tags.length,itemBuilder: (context,index2){return Container(
                            //         child: Text("${statedata.saveddata?[index].tags[index2]}", style: TextStyle(
                            //             fontSize: 10,
                            //             fontWeight: FontWeight.bold,
                            //             color: Colors.black),),
                            //       );}
                            //
                            //   )),
                            // )

                          ],
                        )
                      ],
                    )),
              ),
            ));
      });
}
