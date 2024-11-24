

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
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        ),
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
