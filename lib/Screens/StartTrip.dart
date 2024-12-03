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
          backgroundColor: HexColor('#9e1510'),
          elevation: 0.0,
          titleSpacing: 0.0,
          title: Align(
          alignment: Alignment.topLeft, // Aligns the title to the top left
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: InkWell(
                    onTap: () async {
                      // Define Accept and Reject buttons
                      Widget acceptButton = TextButton(
                        onPressed: () {
                          // Call the Logout function on accept
                          Logout();
                        },
                        child: Text(
                          'Yes',
                          style: TextStyle(
                            color: HexColor('#BD0006'),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );

                      Widget rejectButton = TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Close the dialog on reject
                        },
                        child: Text(
                          'No',
                          style: TextStyle(
                            color: HexColor('#BD0006'),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );

                      // Set up the container with gradient background
                      Container customDialog = Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                // Add gradient background for a smooth transition of colors
                                colors: [
                                  Colors.white,
                                  Colors.white,
                                ], // Define two gradient colors (red to orange)
                                begin: Alignment
                                    .topLeft, // Start of gradient (top-left)
                                end: Alignment
                                    .bottomRight, // End of gradient (bottom-right)
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(
                                      0.2), // Soft shadow with some transparency
                                  offset: Offset(0,
                                      4), // Shadow positioned slightly below the container
                                  blurRadius:
                                      6, // Makes the shadow softer and spread out
                                  spreadRadius:
                                      2, // Makes the shadow expand
                                ),
                              ],
                              borderRadius:
                                  BorderRadius.circular(15),
                            ),
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment:CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Logout",
                              style: TextStyle(
                                color: HexColor('#BD0006'),
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 20), // Space between title and content
                            Text(
                              'Are you sure you want to logout from the application?',
                              style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold,),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20), // Space between content and buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // Accept Button
                                acceptButton,
                                SizedBox(width: 12),
                                // Reject Button
                                rejectButton,
                              ],
                            ),
                          ],
                        ),
                      );

                      // Show the custom dialog inside a modal bottom sheet or overlay
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            backgroundColor: Colors.transparent, // Transparent background
                            child: customDialog, // Show the custom container as the dialog
                          );
                        },
                      );
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.logout,
                          color: Colors.white,
                          size: 30.0,
                        ),
                        SizedBox(width: 8), // Add spacing between icon and text
                        Text(
                          'Logout',
                          style: TextStyle(
                            fontFamily: 'Cairo-ExtraLight',
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
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
    decoration: BoxDecoration(
    ),
    child: Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/images/lottie2.json'),
          SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: HexColor('#9e1510'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              elevation: 10,
              shadowColor: Colors.black.withOpacity(0.3),
            ),
            onPressed: () {
              // Define the buttons for the dialog
              Widget cancelButton = TextButton(
                child: Text(
                  "نعم",
                  style: TextStyle(
                      color: HexColor('#BD0006'),
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                onPressed: () {
                  setState(() {
                    Start_trip();
                    visible = true;
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  });
                },
              );

              Widget continueButton = TextButton(
                child: Text(
                  "لا",
                  style: TextStyle(
                      color: HexColor('#BD0006'),
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop('dialog'); // Close the dialog
                },
              );

              // Show the dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      "بداية الرحلة",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    content: Text(
                      "هل تريد أن تبدأ الرحلة الآن؟",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    actions: [
                      cancelButton,
                      continueButton,
                    ],
                  );
                },
              );
            },
            child: Text(
              "أبدأ الرحلة",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.width * 0.1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
