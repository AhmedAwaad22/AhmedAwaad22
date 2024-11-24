import 'dart:convert';


import 'package:drivercic/Models/startTrip.dart';
import 'package:drivercic/Screens/Home.dart';
import 'package:drivercic/Screens/Login.dart';
import 'package:drivercic/Widget/HexColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class StartTrip extends StatefulWidget {
  const StartTrip({Key? key}) : super(key: key);

  @override
  State<StartTrip> createState() => _StartTripState();
}
bool visible = false;

Future<bool?> showWairing(BuildContext context) async => showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text(" هل تريد اغلاق التطبيق ؟ "),
      actions: [
        ElevatedButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("لا")),
        ElevatedButton(
            onPressed: () => SystemNavigator.pop(),
            child: const Text("نعم"))
      ],
    ));

class _StartTripState extends State<StartTrip> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(

      onWillPop: () async {
        final shouldpop = await showWairing(context);
        return shouldpop ?? false;
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: HexColor('#BD0006'),
            elevation: 0.0,
            titleSpacing: 0.0,
            title: Align(
            alignment: Alignment.topLeft,
            child: InkWell(
              onTap: () async {
                Widget AcceptButton = TextButton(
                    onPressed: () {
                      Logout();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Logged out",
                            style: TextStyle(
                                color: HexColor('#F5F5F5'),
                                fontWeight: FontWeight.bold)),
                      ));
                    },
                    child: Text('Yes',
                        style: TextStyle(
                            color: HexColor('#BD0006'),
                            fontSize: 16,
                            fontWeight: FontWeight.bold)));
                Widget RejectButton = TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('No',
                        style: TextStyle(
                            color: HexColor('#BD0006'),
                            fontSize: 16,
                            fontWeight: FontWeight.bold)));

                // set up the AlertDialog
                AlertDialog alert = AlertDialog(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  contentPadding: EdgeInsets.all(30),
                  title: Text(
                    "Logout",
                    style: TextStyle(
                        color: HexColor('#BD0006'),
                        fontSize: 19,
                        fontWeight: FontWeight.bold),
                  ),
                  content: Text(
                    'Are you sure to logout from application ?',
                    style: TextStyle(fontSize: 14),
                  ),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AcceptButton,
                        SizedBox(
                          width: 12,
                        ),
                        RejectButton,
                      ],
                    )
                  ],
                );
                // show the dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return alert;
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Icon(
                        Icons.logout,
                        color: Colors.white,
                        size: 30.0,
                      ),
                    ),
                    Text(
                      'Logout',
                      style: TextStyle(
                          fontFamily: 'Cairo-ExtraLight',
                          fontSize: 16,
                          fontWeight: FontWeight.w800),
                    )
                  ],
                ),
              ),
            ),
          ),
            automaticallyImplyLeading: false,
            flexibleSpace: SafeArea(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Start Trip",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
          ),
          body: Container(
              child: Align(
            alignment: Alignment.center,
              child: Column(

                children: [
                  Lottie.asset('assets/images/lottie2.json'),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary:HexColor('#BD0006'),
                    shape:RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                  ),

                  onPressed: () {
                    // set up the buttons
                    Widget cancelButton = TextButton(
                      child: Text("نعم",style: TextStyle(
                          color:  HexColor('#BD0006'),
                          fontWeight: FontWeight.bold,
                          fontSize: 20),),
                      onPressed: () {
                        setState(() {
                          Start_trip();
                          visible = true;
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (context) => HomeScreen()));
                        });

                      },
                    );
                    Widget continueButton = TextButton(
                      child: Text("لا",style: TextStyle(
                          color:  HexColor('#BD0006'),
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop('dialog');
                      },
                    );

                    // set up the AlertDialog
                    AlertDialog alert = AlertDialog(
                      title: Text("بدايه الرحله",style: TextStyle(
                          color:  Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                      content: Text("هل تريد أن تبدأ الرحله ألان؟",style: TextStyle(
                          color:   Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                      actions: [
                        cancelButton,
                        continueButton,
                      ],
                    );

                    // show the dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return alert;
                      },
                    );
                  },
                  child: Text(
                    "أبدأ الرحله",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width*0.1),
                  ),
              ),
            ],
              ),
          ))),
    );
  }
  var data = [];
  List<StartTripModel> results = [];
  String urlList = 'http://mobile.cic-cairo.edu.eg/BUS/StartTrip';
  Future<List<StartTripModel>> Start_trip() async {
    var url = Uri.parse(urlList);
    try {
      setState(() {
        visible = true;
      });
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? username = prefs.getString('username');
      Map post_data = {'username': username};

      var response = await http.post(url, body: post_data);

      if (response.statusCode == 200) {
        data = json.decode(response.body);
        results = data.map((e) => StartTripModel.fromJson(e)).toList();
      } else {
        print("fetch error");
      }
    } on Exception catch (e) {
      print('error: $e');
    }
    setState(() {
      visible = false;
    });
    return results;

  }
  Logout() async {
    setState(() {
      visible = true;
    });

    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => LoginScreen(), fullscreenDialog: true));
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    sharedPreferences.remove('login');

    setState(() {
      visible = false;
    });
  }
}
