import 'dart:convert';

import 'package:drivercic/Screens/Home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Widget/HexColor.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<LoginScreen> {
  late Image myImage;
  FocusNode myFocusNode = FocusNode();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  void initState() {

    // SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.initState();

  }

  Future<bool?> showWairing(BuildContext context) async => showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Do you want close the application ?"),
        actions: [
          ElevatedButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("No")),
          ElevatedButton(
              onPressed: () => SystemNavigator.pop(),
              child: const Text("Yes"))
          //SystemNavigator.pop()
        ],
      ));

  String? password;
  bool visible = false;

  bool _showPassword = false;

  bool hasInternet = false;
  void _togglevisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  //Future getValidationDate() async {final
  // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //var obtainEmail = sharedPreferences.getString('email')}

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldpop = await showWairing(context);
        return shouldpop ?? false;
      },
      child: Scaffold(
          body: Stack(
            children: <Widget>[
              Image.asset('assets/images/Background.jpg',width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height,fit: BoxFit.cover,),
              Center(
                  child: Padding(
                      padding: (EdgeInsets.all(10)),
                      child: ListView(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(80.0),
                            child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(0),
                                child: Image.asset('assets/images/logo_white.png')),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: TextField(
                              cursorColor: Colors.white,
                              style: TextStyle(color: Colors.white),
                              controller: nameController,
                              decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.white, width: 5.0),
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(14.0))),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white30, width: 5.0),
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(14.0))),
                                  labelText: 'User Name',
                                  hintText: "User Name",
                                  hintStyle: TextStyle(color: Colors.white),
                                  labelStyle: TextStyle(
                                      color: myFocusNode.hasFocus
                                          ? Colors.white
                                          : Colors.white)),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: TextFormField(
                              cursorColor: Colors.white,
                              style: const TextStyle(color: Colors.white),
                              focusNode: myFocusNode,
                              obscureText: !_showPassword,
                              controller: passwordController,
                              decoration: InputDecoration(
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.white, width: 5.0),
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(14.0))),
                                  enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white30, width: 5.0),
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(14.0))),
                                  labelText: 'Password',
                                  hintText: "Password",
                                  hintStyle: const TextStyle(color: Colors.white),
                                  labelStyle: TextStyle(
                                      color: myFocusNode.hasFocus
                                          ? Colors.white
                                          : Colors.white),
                                  border: InputBorder.none,
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      _togglevisibility();
                                    },
                                    child: Icon(
                                      _showPassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.white,
                                    ),
                                  )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 40.0, bottom: 20.0),
                            child: Container(
                                height: 52,
                                padding: EdgeInsets.fromLTRB(120, 0, 120, 0),
                                child: ElevatedButton(
                                  // shape: RoundedRectangleBorder(
                                  //   borderRadius: BorderRadius.circular(24),
                                  // ),
                                  //padding: EdgeInsets.all(15),
                                  //color: HexColor('#A40007'),
                                  //color: Colors.white,
                                  child: Text('Login',
                                      style: TextStyle(
                                        //color: Colors.white,
                                          color: HexColor('#BD0006'),
                                          fontWeight: FontWeight.bold)),
                                  onPressed: () async {
                                    final SharedPreferences sharedPreferences =
                                    await SharedPreferences.getInstance();
                                    sharedPreferences.setString(
                                        'username', nameController.text);
                                    print("Login Pressed");
                                    var encoded1 = base64
                                        .encode(utf8.encode(passwordController.text));
                                    // userData(nameController.text);
                                    signIn(nameController.text, encoded1, context);
                                    /*  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => NavigationHomeScreen(),
                                    fullscreenDialog: true));*/
                                  },
                                )),
                          ),
                          Visibility(
                              maintainSize: true,
                              maintainAnimation: true,
                              maintainState: true,
                              visible: visible,
                              child: const Center(
                                  child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white)))),
                        ],
                      ))),
            ],
          )),
    );
  }

  signIn(String username, password, context) async {
    if (username.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Username should be at least 5 characters long.",
            style: TextStyle(
                color: HexColor('#F5F5F5'), fontWeight: FontWeight.bold)),
      ));

      return;
    }
    if (password.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Password should be at least 8 characters long.",
            style: TextStyle(
                color: HexColor('#F5F5F5'), fontWeight: FontWeight.bold)),
      ));
      return;
    }
    setState(() {
      visible = true;
    });
    Map data = {'username': username.trim(), 'password': password.trim()};
    var jsonResponse;

    var response = await http.post(
        Uri.parse(
            "http://mobile.cic-cairo.edu.eg/BUS/LDAP_auth"),
        body: data);

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);

      print(jsonResponse);

      if (jsonResponse['campus'] == "MAIN") {
        jsonResponse['campus'] = "nc";
      } else if (jsonResponse['campus'] == "6OCT") {
        jsonResponse['campus'] = "zy";
      }
      print(jsonResponse['campus']);

      if (jsonResponse['login']) {
        final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
        sharedPreferences.setBool("login", jsonResponse['login']);
        sharedPreferences.setString("campus", jsonResponse['campus']);
        sharedPreferences.setString("username", jsonResponse['username']);
        sharedPreferences.setString("fullname", jsonResponse['fullname']);
        sharedPreferences.setString("cicid", jsonResponse['cicid']);
        sharedPreferences.setString("full_name", jsonResponse['full_name']);

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
                (Route<dynamic> route) => false);

        // sharedPreferences.setString("token", jsonResponse['data']['token']);
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Password or username is not correct",
              style: TextStyle(
                  color: HexColor('#F5F5F5'), fontWeight: FontWeight.bold)),
        ));
      }

    }


    else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("login not complete.",
            style: TextStyle(
                color: HexColor('#F5F5F5'), fontWeight: FontWeight.bold)),
      ));
    }

    setState(() {
      visible = false;
    });
  }



}
