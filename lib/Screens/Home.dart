import 'dart:convert';



import 'package:drivercic/Models/BuslistDriver.dart';
import 'package:drivercic/Models/endTrip.dart';
import 'package:drivercic/Models/startTrip.dart';
import 'package:drivercic/Screens/Splash.dart';
import 'package:drivercic/Screens/no_trip_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Widget/HexColor.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreen> {
  int itemCount = 5;
  List<bool> selected = <bool>[];

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < itemCount; i++) {
      selected.add(false);
    }

    getBusListDriver();
  }

  Icon firstIcon = Icon(
    Icons.done, // Icons.favorite
    color: Colors.green, // Colors.red
    size: 35,
  );
  Icon secondIcon = Icon(
    Icons.add, // Icons.favorite_border
    color: Colors.black,
    size: 35,
  );

  Future refresh_busListData() async {
    setState(() {
      getBusListDriver();
    });
  }

  bool pressed = false;
  int _index = 0;
  String ticket = '';
  bool visible = false;

  void _updateSelected(int index) => setState(() => _index = index);

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
          ),
        );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldpop = await showWairing(context);
        return shouldpop ?? false;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme:
            ThemeData(colorSchemeSeed: HexColor('#BD0006'), useMaterial3: true),
home: Scaffold(
  appBar: AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: HexColor('#BD0006'),
    flexibleSpace: SafeArea(
      child: Align(
        alignment: Alignment.center,
        child: Text(
          "Driver CIC",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    ),
  ),
  body: Column(
    children: [
      Expanded(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [HexColor('#BD0006'), HexColor('#FF6347')],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: FutureBuilder(
            future: getBusListDriver(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              }
              if (snapshot.hasData) {
                if (snapshot.data[0].startStatus == "N") {
                  return RefreshIndicator(
                    onRefresh: refresh_busListData,
                    child: Center(
                      child: Text(
                        "لا يوجد طلاب",
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  );
                } else if (snapshot.data[0].startStatus == "Y") {
                  return ListView.builder(
                    itemCount: snapshot.data[0].data_name.length,
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    itemBuilder: (BuildContext context, int index) {
                      var student = snapshot.data[0].data_name[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        elevation: 8,
                        child: Container(
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.white, HexColor('#FFE4E1')],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 6,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "ID: ${student.studId}",
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: HexColor('#BD0006'),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                student.studName,
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    student.pickPoint,
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      if (snapshot.data[0].data_name[index].status == "Y" ||
                                          selected[index]) {
                                        return;
                                      }
                                      _updateSelected(index);
                                      CheckIN();
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(0),
                                      decoration: BoxDecoration(
                                        color: snapshot.data[0].data_name[index].status == "Y"
                                            ? Colors.green.withOpacity(0.2)
                                            : Colors.red.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.1),
                                            blurRadius: 8,
                                            offset: Offset(2, 2),
                                          ),
                                        ],
                                      ),
                                      child: IconButton(
                                        icon: snapshot.data[0].data_name[index].status == "Y"
                                            ? firstIcon
                                            : (selected.elementAt(index) ? firstIcon : secondIcon),
                                        color: snapshot.data[0].data_name[index].status == "Y"
                                            ? Colors.green
                                            : Colors.red,
                                        iconSize: 30,
                                        onPressed: () {
                                          if (snapshot.data[0].data_name[index].status == "Y" ||
                                              selected[index]) {
                                            return;
                                          }
                                          try {
                                            setState(() {
                                              visible = true;
                                              CheckIN();
                                              selected[index] = true;
                                            });
                                          } catch (e) {
                                            print(e);
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    student.seats,
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    ":عدد الكراسي",
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: HexColor('#BD0006'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  );
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              }
            },
          ),
        ),
      ),
            ElevatedButton(
              onPressed: () {
                // Call function to show the end trip dialog
                _showEndTripDialog(context); 
              },
              style: ElevatedButton.styleFrom(
                primary: HexColor('#BD0006'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 140, vertical: 10),
                elevation: 10,
                shadowColor: Colors.black.withOpacity(0.3),
              ),
              child: Text(
                "انهاء الرحلة", 
                style: TextStyle(
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.width * 0.07),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

void _showEndTripDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            "انهاء الرحله",
            style: TextStyle(
              fontFamily: 'Cairo', // استخدام خط عربي جميل
              color: HexColor('#BD0006'),
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.warning_rounded,
              color: HexColor('#BD0006'),
              size: 50,
            ),
            SizedBox(height: 15),
            Text(
              "هل تريد انهاء الرحله ألان؟",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Cairo',
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actionsPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: HexColor('#BD0006'),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onPressed: () async {

              await endTrip();

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => noTrip()),
              (Route<dynamic> Route) => false,
              
              );
            },
            child: Text(
              "نعم",
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: HexColor('#BD0006')),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onPressed: () {
              Navigator.pop(context); // غلق الحوار بدون إجراء
            },
            child: Text(
              "لا",
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: HexColor('#BD0006'),
              ),
            ),
          ),
        ],
      );
    },
  );
}

// Future<void> endTrip() async {
//   try {
//     // هنا يمكنك إضافة الكود اللازم لإنهاء الرحلة مثل إرسال طلب API أو تحديث الحالة
//     // محاكاة عملية تأخير (مثل API call)
//     await Future.delayed(Duration(seconds: 2)); // محاكاة التأخير لمدة ثانيتين
//     print("الرحلة تم إنهاؤها بنجاح");
//   } catch (e) {
//     print("خطأ أثناء إنهاء الرحلة: $e");
//   }
// }

  List<dynamic> data = [];
  var data_CheckIn = [];
  var data_end = [];
  List<BusListDriver> results = [];
  List<StartTripModel> results2 = [];
  List<EndTrip> results3 = [];
  String urlList = 'http://mobile.cic-cairo.edu.eg/BUS/BusList';
  String urlList2 = 'http://mobile.cic-cairo.edu.eg/BUS/CheckIN';
  String urlList3 = 'http://mobile.cic-cairo.edu.eg/BUS/EndTrip';

  Future<List<BusListDriver>> getBusListDriver() async {
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
       // print('hannnnnnnnnnnnnny');
      print(data);
        results = data.map((e) => BusListDriver.fromJson(e)).toList();
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

  Future<List<StartTripModel>> CheckIN() async {
    var url = Uri.parse(urlList2);
    try {
      setState(() {
        visible = true;
      });
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      List<BusListDriver> _tags =
          data.map((e) => BusListDriver.fromJson(e)).toList();
      print("id");
      print(_tags[0].data_name[_index].ticketNo);
      ticket = _tags[0].data_name[_index].ticketNo;
      print("tick");
      print(ticket);
      Map post_data = {'ticket': ticket};
      var response = await http.post(url, body: post_data);
      if (response.statusCode == 200) {
        data_CheckIn = json.decode(response.body);

        results2 = data_CheckIn.map((e) => StartTripModel.fromJson(e)).toList();
      } else {
        print("fetch error");
      }
    } on Exception catch (e) {
      print('error: $e');
    }
    setState(() {
      visible = false;
    });
    return results2;
  }

Future<List<EndTrip>> endTrip() async {
  var url = Uri.parse(urlList3);
  try {

    setState(() {
      visible = true;
    });


    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? username = prefs.getString('username');
    
    if (username == null) {
      print("لا يوجد username في SharedPreferences");
      setState(() {
        visible = false;
      });
      return [];
    }

    Map post_data = {'username': username};

    var response = await http.post(url, body: post_data);

    if (response.statusCode == 200) {
      data_end = json.decode(response.body);
      results3 = data_end.map((e) => EndTrip.fromJson(e)).toList();
      print("TesssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssT");

    } else {
      print("خطأ في استجابة الخادم: ${response.statusCode}");
    }
  } on Exception catch (e) {
    print('خطأ أثناء تنفيذ طلب endTrip: $e');
  }

  setState(() {
    visible = false;
  });

  return results3;
}


  
  
  final snackBar = SnackBar(
    content: Text('test'),
    action: SnackBarAction(
      label: 'test label',
      textColor: Colors.white,
      onPressed: () {},
    ),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      side: BorderSide(color: Colors.red, width: 1),
      borderRadius: BorderRadius.circular(24),
    ),
    backgroundColor: Colors.blue,
  );
}
