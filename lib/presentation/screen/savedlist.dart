// import 'dart:js';
import 'dart:math';
import 'dart:ui';

import 'package:api_to_sql/data/models/datamodel.dart';
import 'package:api_to_sql/logic/cubit/savedquotecubit_cubit.dart';
// import 'package:api_to_sql/logic/cubit/updatecubit/update_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../logic/sqlite/databasehelper.dart';

class savedlist extends StatefulWidget {
  const savedlist({Key? key}) : super(key: key);

  @override
  State<savedlist> createState() => _savedlistState();
}

List authorlist = [];
List tagslist = [];

class _savedlistState extends State<savedlist> {
  final dbhelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar:
          AppBar(title: Text('Saved Quotes'), backgroundColor: Colors.black),
      body: RefreshIndicator(
        onRefresh: () async {
          authorselected = "all";
          tagselected = "all";
          startdate = null;
          enddate = null;
          BlocProvider.of<SavedquotecubitCubit>(context).fetchfromdb();
        },
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
                          suffixIcon: IconButton(
                            onPressed: () {
                              //todo: popupfilter

                              openfilterdialogue(context);
                            },
                            icon: Icon(Icons.filter_list),
                          )),
                      onChanged: (newvalue) {
                        BlocProvider.of<SavedquotecubitCubit>(context)
                            .fetchfromdb(texttofind: newvalue);
                      },
                    ),
                  ),
                ),
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

                      return savedquotelist(state, context);
                    } else if (state is Empty) {
                      return ListView(shrinkWrap: false, children: [
                        SizedBox(
                          height:MediaQuery.of(context).size.height/4,
                          child: Center(
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
                          )),
                        ),
                      ]);
                    } else {
                      return Text("error ");
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<dynamic>> _read() async {
    List<dynamic> data = await dbhelper.fetchSavedQuotes();
    print(data);
    print(data);
    return data;
  }
}

Widget savedquotelist(statedata, context) {
  double width = MediaQuery.of(context).size.width;
  return ListView.builder(
    // reverse: true,
    scrollDirection: Axis.vertical,
    // shrinkWrap: false,
    itemCount: statedata.saveddata?.length,
    itemBuilder: (context, index) {
      // statedata.saveddata=statedata.saveddata.reversed();
      DateTime dateadded = DateTime.parse(statedata.saveddata[index].dateAdded);
      String formattedDate =
          DateFormat('hh:mm a -- yyyy-MM-dd').format(dateadded);
      print(formattedDate);
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
                                width: width - 100,
                                child: Text(
                                    """ " ${statedata.saveddata?[index].content!} " """,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 8,
                                    style: GoogleFonts.lemon(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w100,
                                        fontSize: 23,
                                        height: 1.2,
                                        // letterSpacing: 1.1,
                                        wordSpacing: 1.4,
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
                                    text:
                                        statedata.saveddata?[index].content!));
                              },
                              icon: Icon(
                                Icons.copy_outlined,
                                color: Colors.black,
                              )),
                          // update button
                          IconButton(
                              onPressed: () async {
                                //todo: update
                                await openupdatedialogue(
                                    context, statedata.saveddata?[index]);
                                // BlocProvider.of<SavedquotecubitCubit>(
                                //     context)
                                //     .fetchfromdb();
                              },
                              icon: Icon(
                                Icons.edit,
                                color: Colors.yellow,
                              )),
                          // delete button
                          IconButton(
                              onPressed: () {
                                BlocProvider.of<SavedquotecubitCubit>(context)
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
                  Divider(thickness: 2),
                  Row(
                    // mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // mainAxisSize: MainAxisSize.max,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 18),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Text(
                                  "- ${statedata.saveddata?[index].author}",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: EdgeInsets.only(right: 10),
                            height: 22,
                            width: MediaQuery.of(context).size.width / 2.7,
                            child: ListView.builder(
                              physics: PageScrollPhysics(),
                              reverse: true,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  statedata.saveddata?[index].tags.length,
                              itemBuilder: (context, index2) {
                                // print("tagss is ${statedata.saveddata?[index].tags}");
                                return Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border:
                                          Border.all(color: Colors.black38)),
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                    "${statedata.saveddata?[index].tags[index2]}",
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              child: Text(
                                formattedDate,
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 10),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

String authorselected = "all";
String tagselected = "all";
DateTime? startdate;
DateTime? enddate;
String gettextfromdate(DateTime? date) {
  if (date == null) {
    return "select date";
  } else {
    return "${date.day} : ${date.month} : ${date.year}";
  }
}

Future openfilterdialogue(BuildContext context) {
  final startdatecontroller = TextEditingController();
  final enddatecontroller = TextEditingController();
  startdatecontroller.text = gettextfromdate(startdate);
  enddatecontroller.text = gettextfromdate(enddate);

  return showDialog(
      context: context,
      builder: (dialogcontext) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaY: 2, sigmaX: 2),
          child: AlertDialog(
            insetPadding: EdgeInsets.all(15),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(20)),
            title: Text("Filter"),
            backgroundColor: Colors.white,
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // DropdownButton(
                  //   items: authorlist.map((item) {
                  //     return DropdownMenuItem(
                  //       child: Text(item),
                  //     );
                  //   }).toList(),
                  //   onChanged: (value) {},
                  // ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Icon(Icons.calendar_month,color: Colors.black45,),
                      ),

                      Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: 50,
                          decoration: BoxDecoration(
                              // border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(20)),
                          child: TextField(
                            decoration: InputDecoration(label: Text("From")),
                            readOnly: true,
                            onTap: () =>
                                startdatepicker(context, startdatecontroller),
                            controller: startdatecontroller,
                          )),
                      Icon(Icons.navigate_next),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: 50,
                          decoration: BoxDecoration(
                              // border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(20)),
                          child: TextField(
                            decoration: InputDecoration(label: Text("To")),
                            readOnly: true,
                            onTap: () => enddatepicker(
                                context, dialogcontext, enddatecontroller),
                            controller: enddatecontroller,
                          )),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: DropdownButtonFormField(

                        decoration: InputDecoration(label: Text("author"),icon: Icon(Icons.person)),
                        // icon: Icon(Icons.person),
                        items: authorlist
                            .map((item) => DropdownMenuItem(
                                  child: Text(item),
                                  value: item,
                                ))
                            .toList(),
                        value: authorselected,

                        onChanged: (value) {
                          print("🟥🟥🟥🟥🟥$value");
                          authorselected=value.toString();
                          // tagselected = value.toString();
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: DropdownButtonFormField(

                        decoration: InputDecoration(label: Text("tags"),icon: Icon(Icons.tag)),
                        // icon: Icon(Icons.person),
                        items: tagslist
                            .map((item) => DropdownMenuItem(
                                  child: Text(item),
                                  value: item,
                                ))
                            .toList(),
                        value: tagselected,

                        onChanged: (value) {
                          print("🟥🟥🟥🟥🟥$value");
                          // authorselected=value.toString();
                          tagselected = value.toString();
                        },
                      ),
                    ),
                  ),
                  // DropdownMenu(
                  //     width: MediaQuery.of(context).size.width - 150,
                  //     label: Text("tags"),
                  //     leadingIcon: Icon(Icons.tag_sharp),
                  //     inputDecorationTheme: InputDecorationTheme(),
                  //     initialSelection: tagselected,
                  //     onSelected: (value) {
                  //       tagselected = value;
                  //
                  //       // BlocProvider.of<SavedquotecubitCubit>(context)
                  //       //     .fetchfromdb(texttofind: value);
                  //     },
                  //     dropdownMenuEntries: tagslist.map((item) {
                  //       return DropdownMenuEntry(value: item, label: item);
                  //     }).toList()),
                  //todo: tags filter
                  Container(),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Center(
                      child: TextButton(
                        onPressed: () async {
                          //todo: update

                          Navigator.of(context).pop();
                          // return;
                        },
                        child: Container(
                          height: 40,
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            boxShadow: [BoxShadow(color: Colors.black)],
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextButton(
                            onPressed: () {
                              BlocProvider.of<SavedquotecubitCubit>(context)
                                  .fetchfromdb(
                                      start: startdate,
                                      end: enddate,
                                      author: authorselected,
                                      tag: tagselected);
                              Navigator.pop(dialogcontext);
                            },
                            child: Center(
                              child: Text(
                                "apply",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
}

Future startdatepicker(BuildContext context, controller) async {
  final initialadate = DateTime.now();
  final newdate = await showDatePicker(

      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5));
  if (newdate == null) {
    return;
  }
  startdate = newdate;
  controller.text = gettextfromdate(newdate);
}

Future enddatepicker(BuildContext context, dialogcontext, controller) async {
  final initialadate = DateTime.now();
  final newdate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5));

  if (newdate == null) {
    return;
  }
  if (newdate.isBefore(startdate!) && startdate != null) {
    ScaffoldMessenger.of(dialogcontext)
        .showSnackBar(SnackBar(content: Text("please provide valid range !!")));
    Navigator.of(dialogcontext).pop();
  }
  enddate = newdate;
  controller.text = gettextfromdate(newdate);
}

Future openupdatedialogue(BuildContext context, datamodel quote) {
  final quotecontroller = TextEditingController();
  quotecontroller.text = quote.content;
  final authorcontroller = TextEditingController();
  authorcontroller.text = quote.author;
  return showDialog(
    context: context,
    builder: (context1) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.circular(20)),
          title: Text("edit the quote"),
          alignment: Alignment.center,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "quote",
                    icon: Icon(Icons.format_quote),
                  ),
                  controller: quotecontroller,
                  maxLines: 4,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "author",
                    icon: Icon(Icons.person),
                  ),
                  controller: authorcontroller,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: TextButton(
                    onPressed: () async {
                      //todo: update
                      if (quotecontroller.text.length < 1 ||
                          authorcontroller.text.length < 1) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                                Text("unable to save because value is empty")));
                        Navigator.of(context).pop();
                      } else {
                        quote.content = quotecontroller.text;
                        quote.author = authorcontroller.text;
                        BlocProvider.of<SavedquotecubitCubit>(context)
                            .update(quote);
                        Navigator.of(context).pop();
                      }
                      // return;
                    },
                    child: Container(
                      height: 40,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        boxShadow: [BoxShadow(color: Colors.black)],
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          "save",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
