
import 'package:drivercic/Screens/Login.dart';
import 'package:drivercic/Widget/HexColor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class noTrip extends StatefulWidget {
  const noTrip({Key? key}) : super(key: key);

  @override
  State<noTrip> createState() => _noTripState();
}

class _noTripState extends State<noTrip> {
  bool visible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          "Trips",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ),
      ),
    ),
  ),
     
      backgroundColor: HexColor('#F5F5F5'),
      body: Container(
        child: Column(

            children: [
              SizedBox(height: MediaQuery.of(context).size.height*0.1,),
              Lottie.asset('assets/images/lottie2.json'),
              SizedBox(height: MediaQuery.of(context).size.height*0.07,),
              Text("لا يوجد رحلات الان" ,style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.1,color: HexColor('#BD0006')),textAlign: TextAlign.center,)]),
      ),
    );
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
