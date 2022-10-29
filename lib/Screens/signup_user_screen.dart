import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:travelapp/Screens/login_user_screen.dart';
import 'package:travelapp/Utils/constants.dart';
import 'package:travelapp/Utils/extensions.dart';
import 'package:travelapp/services/database_helper.dart';

//import 'package:meconline/HomePage.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  //snackbar message
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void _showMessageInScaffold(String message) {
    _scaffoldKey.currentState!.showSnackBar(SnackBar(
      backgroundColor: Colors.red,
      content: Text(message),
    ));
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  final name = TextEditingController();
  String? _email, _password, _name;

  // ignore: non_constant_identifier_names
  SignUp(String email, String password) async {
    // _formKey.currentState.save();
    print(email + "Chec email");
    print(password + "cech password");
    try {
      UserCredential user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (user != null) {
        print("Sucess");
        _showMessageInScaffold("Registered Successfully");
        clearTextInput();
        new Future.delayed(const Duration(seconds: 1), () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => LoginPage()));
        });
        // Navigator.of(context)
        //     .pushReplacement(MaterialPageRoute(builder: (_) => Login()));
      }
    } catch (e) {
      throw e;
    }
  }

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

  //clear controller
  clearTextInput() {
    email.clear();
    password.clear();
    name.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('$imgpath/carbackground.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          key: _scaffoldKey,
          body: SingleChildScrollView(
            child: Container(
                height: sizeheight(context),
                child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding:
                            EdgeInsets.only(top: sizeheight(context) * 0.20),
                        child: Text("Fare Share",
                            style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal)),
                      ),
                      SizedBox(height: sizeheight(context) * 0.10),
                      Container(
                          child: Form(
                              key: _formKey,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    // child: TextField(
                                    //   decoration: InputDecoration(
                                    //       border: OutlineInputBorder(),
                                    //       hintText: 'Enter Name'
                                    //   ),
                                    // ),
                                    child: TextFormField(
                                        // ignore: missing_return
                                        validator: (input) {
                                          if (input == null)
                                            return 'Enter Name';
                                        },
                                        controller: name,
                                        decoration: InputDecoration(
                                          labelText: 'Name',
                                          prefixIcon: Icon(Icons.person),
                                        ),
                                        onSaved: (input) => _name = input),
                                  ),
                                  Container(
                                    child: TextFormField(
                                        // ignore: missing_return
                                        //Please enter a valid email
                                        validator: (String? v) {
                                          if (v!.isValidEmail) {
                                            return null;
                                          } else {
                                            return "Please enter a valid email";
                                          }
                                        },
                                        controller: email,
                                        decoration: InputDecoration(
                                            labelText: 'Email',
                                            prefixIcon: Icon(Icons.email)),
                                        onSaved: (input) => _email = input
                                        ),
                                  ),

                                  Container(
                                    child: TextFormField(
                                        validator: (String? v) {
                                          if (v!.isValidPassword) {
                                            return null;
                                          } else {
                                            return "Password must contain an uppercase, lowercase, numeric digit and special character ";
                                          }
                                        },
                                        controller: password,
                                        decoration: InputDecoration(
                                          labelText: 'Password',
                                          prefixIcon: Icon(Icons.lock),
                                        ),
                                        obscureText: true,
                                        onSaved: (input) => _password = input),
                                  ),
                                  SizedBox(height: 30),
                                  // ignore: deprecated_member_use
                                  RaisedButton(
                                    padding:
                                        EdgeInsets.fromLTRB(70, 10, 70, 10),
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        String? devicetoken =
                                            await FirebaseMessaging.instance
                                                .getToken();
                                        if (email.text.isNotEmpty &&
                                            password.text.isNotEmpty &&
                                            name.text.isNotEmpty) {
                                          print("add user details----------");
                                          await Database.adduserdata(
                                            name: name.text,
                                            Email: email.text,
                                            password: password.text,
                                            token: devicetoken,
                                          );
                                          //_showMessageInScaffold("Registered Successfully${locationMessage}");
                                          _showMessageInScaffold(
                                              "Registered Successfully");
                                          // _register();
                                          SignUp(email.text, password.text);
                                        } else {
                                          print("------------");
                                          _showMessageInScaffold(
                                              "Please Fill all Fields");
                                        }
                                      }
                                    },
                                    child: Text('SignUp',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold)),
                                    color: Colors.teal,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  )
                                ],
                              )))
                    ])),
          )),
    );
  }
}
