import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelapp/Driver/driver_main_page.dart';
import 'package:travelapp/Screens/driver_options.dart';
import 'package:travelapp/Screens/forget_password.dart';
import 'package:travelapp/Screens/main_screen.dart';
import 'package:travelapp/Screens/signup_driver_screen.dart';
import 'package:travelapp/Screens/signup_user_screen.dart';
import 'package:travelapp/Screens/driver_profile_screen.dart';
import 'package:travelapp/Utils/constants.dart';
import 'package:travelapp/bottomnav.dart';

class DriverLoginPage extends StatefulWidget {
  @override
  _DriverLoginPageState createState() => _DriverLoginPageState();
}

class _DriverLoginPageState extends State<DriverLoginPage> {
  // navigateToLogin() async {
  //   Navigator.pushReplacementNamed(context, "Login");
  // }

  // navigateToRegister() async {
  //   Navigator.pushReplacementNamed(context, "SignUp");
  // }

  bool? _success;
  var obscureText = true;
  String? _email, _password;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  //Sign in fun
  void _signInWithEmailAndPassword() async {
    final user = (await _auth.signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    ))
        .user;

    if (user != null) {
      print("------------------${user}");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('driveremail', _emailController.text);
      prefs.setBool("misLoggedIn", true);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => DriverProfileScreen()));
      // setState(() {
      //  // _success = true;
      //   Navigator.of(context).push(MaterialPageRoute(builder: (_) => mecchanicaccount()));
      //   _userEmail = user.email;
      // });
    } else {
      setState(() {
        _success = false;
      });
      //showError("Login field");
    }
  }
//sign in fun end

  showError(String errormessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(errormessage),
            actions: <Widget>[
              // ignore: deprecated_member_use
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final double btnmargsize = MediaQuery.of(context).size.width * 0.09;
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("$imgpath/carbackground.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 70.0, right: 280.0),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.teal,
                    size: 30.0,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => MainScreen()));
                  },
                ),
              ),
              SizedBox(height: sizeheight(context) * 0.10),
              Container(
                child: Column(
                  children: [
                    Text(
                      'For Driver',
                      style: TextStyle(
                          color: Colors.teal,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Container(
                      child: Form(
                        key: _formkey,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                color: Colors.white,
                                child: TextFormField(
                                    // ignore: missing_return
                                    // validator: (input) {
                                    //   if (input.isEmpty) return 'Enter Email';
                                    // },
                                    validator: (input) {
                                      if (input == null) return 'Enter Email';
                                    },
                                    controller: _emailController,
                                    decoration: InputDecoration(
                                        labelText: 'Email',
                                        prefixIcon: Icon(Icons.email)),
                                    onSaved: (input) => _email = input),
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                color: Colors.white,
                                child: TextFormField(
                                  controller: _passwordController,
                                  obscureText: obscureText,
                                  decoration: InputDecoration(
                                      labelText: 'Password',
                                      prefixIcon: Icon(Icons.lock),
                                      suffixIcon: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              obscureText = !obscureText;
                                            });
                                          },
                                          child: obscureText
                                              ? const Icon(
                                                  Icons.visibility_off,
                                                  color: Colors.grey,
                                                )
                                              : const Icon(
                                                  Icons.visibility,
                                                  color: Colors.black,
                                                ))),
                                  //obscureText: true,
                                  validator: (input) {
                                    if (input == null) return 'Enter Password';
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                         Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (_) => ForgetPasswordScreen()));
                                    });
                                  },
                                  child: Container(
                                      margin: EdgeInsets.only(
                                          top: 10, left: 0, right: 10),
                                      child: TextButton(
                                        child: const Text(
                                          "Forgot Passsword?",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors
                                                  .black //Color(0xFF267D43)
                                              ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (_) => ForgetPasswordScreen()));
                                    
                                          // if (_formkey.currentState!
                                          //     .validate()) {
                                          //   // login(emailController.text, password.text);
                                          //   print("Driver login");
                                          //   _signInWithEmailAndPassword();
                                          //   // Navigator.of(context).pushReplacement(MaterialPageRoute(
                                          //   //     builder: (BuildContext context) => UserDeshboardScreen()));
                                          //   // Navigator.of(context)
                                          //   //     .push(MaterialPageRoute(builder: (_) => UserDeshboardScreen()));
                                          // } else {
                                          //   print('Validation error');
                                          // }
                                        },
                                      )),
                                ),
                              ],
                            ), //Check
                            SizedBox(height: 20),
                            // ignore: deprecated_member_use
                            Container(
                              width: sizeWidth(context),
                              margin: EdgeInsets.only(
                                  left: btnmargsize, right: btnmargsize),
                              child: RaisedButton(
                                padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                                onPressed: () {
                                  if (_formkey.currentState!.validate()) {
                                    // login(emailController.text, password.text);
                                    print("Driver login");
                                    _signInWithEmailAndPassword();
                                    //                           Navigator.of(context)
                                    // .push(MaterialPageRoute(builder: (_) => DriverProfileScreen()));
                                    // Navigator.of(context).pushReplacement(MaterialPageRoute(
                                    //     builder: (BuildContext context) => UserDeshboardScreen()));
                                    // Navigator.of(context)
                                    //     .push(MaterialPageRoute(builder: (_) => UserDeshboardScreen()));
                                  } else {
                                    print('Validation error');
                                  }
                                },
                                child: Text('LOGIN',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold)),
                                color: Colors.teal,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 10.0),
                              alignment: Alignment.center,
                              child: RichText(
                                text: TextSpan(
                                  text: "Don't Have an Account? ",
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 16),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: ('Sign Up'),
                                      style: const TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Colors.teal,
                                          fontSize: 18),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          DriverOptions()));
                                        },
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
