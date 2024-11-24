import 'dart:convert';



import 'package:drivercic/Models/BuslistDriver.dart';
import 'package:drivercic/Models/endTrip.dart';
import 'package:drivercic/Models/startTrip.dart';
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
          ));

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
                      fontSize: 20),
                ),
              ),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: Container(
                  color: Colors.white60,
                  padding: EdgeInsets.all(15),
                  child: FutureBuilder(
                    future: getBusListDriver(),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasData) {
                        if (snapshot.data[0].startStatus == "N") {
                          return RefreshIndicator(
                              onRefresh: refresh_busListData,
                              child: Center(
                                child: Text(
                                  "No students found",
                                  style: TextStyle(
                                      color: HexColor('#BD0006'),
                                      fontWeight: FontWeight.bold),
                                ),
                              ));
                        } else if (snapshot.data[0].startStatus == "Y") {
                          return ListView.builder(
                            itemBuilder: (BuildContext context, int index) {
                              // itemCount = (index == _index) as int;

                              // pressed = index as bool;

                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                elevation: 22,
                                child: ClipPath(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 25),
                                    decoration: BoxDecoration(
                                      border: Border(
                                          right: BorderSide(
                                              color: HexColor('#BD0006'),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .02)),
                                      color: HexColor('#f4f4f4'),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                         Row(
                                           children: [
                                             Text(snapshot.data[0]
                                                 .data_name[index].studId, style: TextStyle(
                                               fontWeight:
                                               FontWeight.bold,
                                               fontSize: 16,
                                               color:
                                               HexColor('#BD0006'),
                                             )),
                                             SizedBox(width: 10,),
                                             Text(
                                               " - ",
                                               style: TextStyle(
                                                 fontWeight:
                                                 FontWeight.bold,
                                                 fontSize: 18,
                                                 color:
                                                 HexColor('#BD0006'),
                                               ),
                                             ),
                                             SizedBox(width: 10,),
                                             SingleChildScrollView(
                                               child: Text(
                                                 snapshot
                                                     .data[0]
                                                     .data_name[index]
                                                     .studName,
                                                 style: TextStyle(
                                                   fontWeight:
                                                   FontWeight.bold,
                                                   fontSize: 18,
                                                   color:
                                                   HexColor('#BD0006'),
                                                 ),
                                               ),
                                             ),
                                            ],
                                         ),

                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(snapshot.data[0]
                                                  .data_name[index].pickPoint,
                                              style: TextStyle(
                                                fontWeight:
                                                FontWeight.bold,
                                                fontSize: 16,
                                                color:
                                                HexColor('#BD0006'),
                                              ),

                                            ),
                                            InkWell(
                                              onTap: (){
                                                _updateSelected(index);
                                                CheckIN();
                                              },
                                              child: IconButton(
                                                icon: snapshot
                                                    .data[0]
                                                    .data_name[index]
                                                    .status ==
                                                    "Y"
                                                    ? firstIcon
                                                    : (selected
                                                    .elementAt(index)
                                                    ? firstIcon
                                                    : secondIcon),
                                                onPressed: () {
                                                  try {
                                                    print(snapshot.data[0]
                                                        .data_name[0].status);
                                                    // your code that you want this IconButton do
                                                    setState(() {
                                                      visible = true;
                                                      CheckIN();
                                                      selected[index] =
                                                      !selected.elementAt(
                                                          index);
                                                    });
                                                    print(
                                                        'tap on ${index + 1}th IconButton ( change to : ');
                                                    print(selected[index]
                                                        ? 'active'
                                                        : 'deactive' + ' )');
                                                    _index = index;
                                                    print(_index);
                                                  } catch (e) {
                                                    print(e);
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),

                                        SizedBox(width: 10,),
                                        Text(snapshot.data[0]
                                            .data_name[index].seats, style: TextStyle(
                                          fontWeight:
                                          FontWeight.bold,
                                          fontSize: 16,
                                          color:
                                          HexColor('#BD0006'),
                                        )),


                                      ],
                                    ),
                                  ),
                                  clipper: ShapeBorderClipper(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15))),
                                ),
                              );
                            },
                            itemCount: snapshot.data[0].data_name.length,
                          );
                        } else {
                          return CircularProgressIndicator();
                        }
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: HexColor('#BD0006'),
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: () {
                    // set up the buttons
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
                          endTrip();
                          visible = true;
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => noTrip()));
                          // Navigator.of(context, rootNavigator: true).pop('dialog');
                        });
                      },
                    );
                    Widget continueButton = TextButton(
                      child: Text("لا",
                          style: TextStyle(
                              color: HexColor('#BD0006'),
                              fontWeight: FontWeight.bold,
                              fontSize: 20)),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true)
                            .pop('dialog');
                      },
                    );

                    // set up the AlertDialog
                    AlertDialog alert = AlertDialog(
                      title: Text("انهاء الرحله",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20)),
                      content: Text("هل تريد انهاء الرحله ألان؟",
                          style: TextStyle(
                              color: Colors.black,
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
                    "انهاء الرحله",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width * 0.1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
        print('hannnnnnnnnnnnnny');
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
      Map post_data = {'username': username};

      var response = await http.post(url, body: post_data);
      if (response.statusCode == 200) {
        data_end = json.decode(response.body);
        results3 = data_end.map((e) => EndTrip.fromJson(e)).toList();
      } else {
        print("fetch error");
      }
    } on Exception catch (e) {
      print('error: $e');
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
