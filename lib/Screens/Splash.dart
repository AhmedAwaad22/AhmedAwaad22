
import 'dart:async';
import 'dart:convert';

import 'package:drivercic/Models/BuslistDriver.dart';
import 'package:drivercic/Models/main.dart';
import 'package:drivercic/Screens/Home.dart';
import 'package:drivercic/Screens/Login.dart';
import 'package:drivercic/Screens/NoDriverScreen.dart';
import 'package:drivercic/Screens/StartTrip.dart';
import 'package:drivercic/Screens/no_trip_data.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


String? finalEmail;
bool loginToken=false;

var data = [];
List<BusListDriver> results = [];
//String urlList = 'http://mobile.cic-cairo.edu.eg/BUS/BusList';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  

  @override
  void initState() {
    Timer(Duration(seconds: 2), () {
      getValidationData().whenComplete(() async {
        if (loginToken == false) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => LoginScreen()));
        }else
          {

            Get_trip();
            //getBusListDriver();
          }
      });
    });
    super.initState();
  }

  /*Future getValidationData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var obtainedEmail = sharedPreferences.getString('username');
    setState(() {
      finalEmail = obtainedEmail;
    });
    print(finalEmail);
  }*/

  Future getValidationData() async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    var obtainedToken = sharedPreferences.getBool('login');

    setState(() {
      loginToken = obtainedToken! ;
    });

    //print(loginToken);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 120.0,
                  child: Image.asset('assets/images/logo_splash.png'),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50.0, bottom: 250),
                  child: CircularProgressIndicator(
                    color: Colors.red,
                    backgroundColor: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }

  var data = [];
  List<MainOh> results = [];
  String urlList = 'http://mobile.cic-cairo.edu.eg/BUS/GetTrip';

  Future<List<MainOh>> Get_trip() async {
    var url = Uri.parse(urlList);
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? username = prefs.getString('username');
      Map post_data = {'username': username};

      var response = await http.post(url, body: post_data);

        //print(results2[0].isDriver);

      if (response.statusCode == 200) {
        data = json.decode(response.body);
        //print(data);
        results = data.map((e) => MainOh.fromJson(e)).toList();

        //print(results[0].status);

        if(results[0].status=='Y')
          {
             Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen()));
          }
        else if(results[0].status=='N')
          {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => StartTrip()));
          }
        else if(results[0].status=='E')
        {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => noTrip()));
        }
        else if(results[0].isDriver == 'N')
        {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  NoDriverScreen()));
        }
      }
      else
        {
             print("Fetch Error");
        }
    } on Exception catch (e) {
      print('error: $e');
    }
    return results;
  }

  List<dynamic> data_use = [];
  List<BusListDriver> results2 = [];
  //String urlList2 = 'http://mobile.cic-cairo.edu.eg/BUS/BusList';

}
