

import 'dart:io';


import 'package:drivercic/Screens/Login.dart';
import 'package:drivercic/Widget/HexColor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class NoDriverScreen extends StatefulWidget {
  const NoDriverScreen({Key? key}) : super(key: key);

  @override
  State<NoDriverScreen> createState() => _NoDriverScreenState();
}

class _NoDriverScreenState extends State<NoDriverScreen> {
  bool visible = false;

  Future<void> _launchInWebViewOrVC(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppWebView,
      webViewConfiguration: const WebViewConfiguration(
          headers: <String, String>{'my_header_key': 'my_header_value'}),
    )) {
      throw 'Could not launch $url';
    }
  }
  Future<void> _launchUniversalLinkIos(Uri url) async {
    final bool nativeAppLaunchSucceeded = await launchUrl(
      url,
      mode: LaunchMode.externalNonBrowserApplication,
    );
    if (!nativeAppLaunchSucceeded) {
      await launchUrl(
        url,
        mode: LaunchMode.inAppWebView,
      );
    }
  }




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
              "CIC BUS",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
        ),
      ),
      backgroundColor: HexColor('#F5F5F5'),
      body: Column(

          children: [
            Lottie.asset('assets/images/no_user.json'),
            SizedBox(height: MediaQuery.of(context).size.height*0.07,),
            Text("This app for drivers \n Download your Bus app now" ,style: TextStyle(fontSize: 16,color: HexColor('#BD0006'),fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: HexColor('#BD0006'),
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                ),
              ),
              onPressed: () {
                // set up the buttons
                if (Platform.isAndroid || Platform.isIOS) {
                  final appId = Platform.isAndroid ? 'com.zcic.cicbus' : '1640899336';
                  final url = Uri.parse(
                    Platform.isAndroid
                        ? "market://details?id=$appId"
                        : "https://apps.apple.com/app/id$appId",
                  );
                  launchUrl(
                    url,
                    mode: LaunchMode.externalApplication,
                  );
                }

              }, child: Expanded(child: Text("CIC BUS Download Link")),
            ),


          ]),
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
