import 'dart:async';


import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:new_version/new_version.dart';
import 'package:overlay_support/overlay_support.dart';

import 'Screens/Splash.dart';
import 'Widget/AppTheme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) => runApp(MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool hasInternet = false;

  ConnectivityResult result = ConnectivityResult.none;

  bool isInternetAvailable = false;

  @override
  void initState() {

    super.initState();
    initTimer();

  }

  void initTimer()  async
  {
    if(await checkConnection())
    {

      Timer(const Duration(seconds: 2),() =>  new MaterialPageRoute(
          builder: (context) => SplashScreen()));
    }
  }

  Future<bool> checkConnection() async
  {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if(connectivityResult == ConnectivityResult.mobile ||connectivityResult == ConnectivityResult.wifi )
    {
      return true;
    }
    else
    {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      // statusBarBrightness: Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return MaterialApp(
        title: 'CIC',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.red,
          textTheme: AppTheme.textTheme,
          platform: TargetPlatform.iOS,
        ),
        // home: TestPage(),
        // home: ProfileTest(),
        home: FutureBuilder(
          future: checkConnection(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.data == null)
            {
              return  SplashScreen();
            }
            else if(snapshot.data == true)
            {
              return  SplashScreen();
            }
            else
            {
              return Scaffold(
                backgroundColor: Colors.white,
                body: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/images/maintenace.svg',
                        height: MediaQuery.of(context).size.height*.2,
                        width: MediaQuery.of(context).size.width*.2,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 25,),
                      Column(
                        children: [
                          Text(
                            "No Internet connection",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20),
                          ),
                          SizedBox(height:20 ,),
                          Text(
                            "Check your connection, then refresh the page",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(height: 20,),
                      ElevatedButton(
                          style: ElevatedButton
                              .styleFrom(
                            textStyle: TextStyle(
                              fontSize: 18,
                              color:Colors.blue,
                            ),

                            primary:Colors.white,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.blue,width: 1),
                                borderRadius:
                                BorderRadius
                                    .circular(
                                    25.0)),
                          ),

                          onPressed: (){
                            setState(() {
                              initTimer();
                            });

                          }, child: Text("Refresh",style: TextStyle(
                          fontSize: 16,
                          color:Colors.blue,
                          fontWeight: FontWeight.bold
                      )))
                    ],
                  ),
                ),
              );
            }
          },
        )
    );
  }
}
