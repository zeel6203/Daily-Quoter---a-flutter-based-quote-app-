import 'package:flutter/material.dart';

class extra extends StatelessWidget {
  const extra({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            leading: Icon(Icons.arrow_back),
            title: Text("Pay"),
            actions: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.search),
                ),
              ),
              Icon(Icons.menu)
            ],
            backgroundColor: Colors.black),
        body: SafeArea(
          child: Container(
            height: double.maxFinite,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: Text("Pay your Bills")),
                ),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  children: [
                  c("electricity",Icons.electric_bolt),c("water",Icons.water_drop),c("mobile",Icons.phone_android),c("mobile",Icons.phone_android),c("mobile",Icons.phone_android),c("mobile",Icons.phone_android)
                  ],
                ),Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: Text("Pay your Bills")),
                ),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  children: [
                  c("mobile",Icons.phone_android),c("mobile",Icons.phone_android),c("mobile",Icons.phone_android)
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget c(tagname,icon){
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(color: Colors.grey.shade300,borderRadius: BorderRadius.circular(10),boxShadow: [BoxShadow(color: Colors.grey.shade400,blurRadius: 1,offset: Offset(1, 1))]),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Text(tagname)),
              ),
            ]  ),
      ),

    ),
  );
}