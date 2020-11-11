import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gshop/shared/formDecoration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HomePage.dart';

// ignore: must_be_immutable
class ForgotPassword extends StatefulWidget {
  String phone;

  ForgotPassword({this.phone});

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState(this.phone);
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String phone;

  _ForgotPasswordState(this.phone);

  final _formKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();
  String newPassword, confirmPassword;
  String errorMgs = '';
  bool isLoading = false,confirmOTP = false;
  SharedPreferences preferences;
  final _codeController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    writeDataToController();
  }

  writeDataToController() {
    phoneController = TextEditingController(text: phone);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: bodyUI(context),
    );
  }

  Widget bodyUI(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: size.height / 25),
            height: size.height * 0.7,
            width: size.width,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  colors: [
                    Colors.orange[900],
                    Colors.orange[800],
                    Colors.orange[700],
                    Colors.orange[300],
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(70),
                  //bottomRight: Radius.circular(70),
                  //topLeft: Radius.circular(70),
                  topRight: Radius.circular(70),
                ),
              ),
            ),
          ),
          Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 15),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child: Container(
                    child: Image.asset(
                      "assets/image/lg.png",
                      height: 100,
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(50),
                          bottomLeft: Radius.circular(50)),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        color: Colors.white,
                        height: MediaQuery.of(context).size.height * 0.6,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextFormField(
                                decoration: InputDecoration(
                                    fillColor: Colors.black12,
                                    filled: true,
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(50)),
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                        width: 1.0,
                                      ),
                                    )),
                                keyboardType: TextInputType.phone,
                                controller: phoneController,
                                enabled: false,
                              ),
                              SizedBox(
                                height: size.height / 35,
                              ),
                              confirmOTP
                                  ? Column(
                                      children: [
                                        TextFormField(
                                          decoration:
                                              textInputDecoration.copyWith(
                                                  hintText: "New Password",
                                                  prefixIcon: Icon(
                                                      Icons.security_rounded)),
                                          keyboardType: TextInputType.text,
                                          validator: (value) => value.isEmpty
                                              ? "Enter Password"
                                              : null,
                                          onChanged: (value) {
                                            setState(() => newPassword = value);
                                          },
                                        ),
                                        SizedBox(
                                          height: size.height / 35,
                                        ),
                                        TextFormField(
                                          decoration:
                                              textInputDecoration.copyWith(
                                                  hintText: "Confirm Password",
                                                  prefixIcon: Icon(
                                                      Icons.security_rounded)),
                                          keyboardType: TextInputType.text,
                                          validator: (value) => value.isEmpty
                                              ? "Enter Password"
                                              : null,
                                          onChanged: (value) {
                                            setState(
                                                () => confirmPassword = value);
                                          },
                                        ),
                                        SizedBox(
                                          height: size.height / 35,
                                        ),
                                        RaisedButton(
                                          onPressed: () {
                                            if(_formKey.currentState.validate()){
                                              if(newPassword==confirmPassword){
                                                setState(() {
                                                  isLoading=true;
                                                  errorMgs="";
                                                  resetPassword();
                                                });
                                              }
                                              else{
                                                setState(() {
                                                  isLoading=false;
                                                  errorMgs="Confirm password not matched";
                                                });
                                              }
                                            }
                                          },
                                          color: Colors.deepOrange,
                                          splashColor: Colors.deepOrange[200],
                                          child: Text(
                                            "Reset Password",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    )
                                  : RaisedButton(
                                      onPressed: () {
                                        setState(() {
                                          isLoading=true;
                                          errorMgs='';
                                        });
                                        getOTP();
                                      },
                                      color: Colors.deepOrange,
                                      splashColor: Colors.deepOrange[200],
                                      child: Text(
                                        "Get OTP",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                              SizedBox(height: size.height / 30),
                              Container(
                                child: isLoading ? dualRing() : Container(
                                  child: Text(
                                    errorMgs,
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future getOTP()async{
    FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.verifyPhoneNumber(
        phoneNumber: "+88"+phone, //phoneWithCountryCode,
        timeout: Duration(seconds: 120),
        ///Automatic verify....
        verificationCompleted: (AuthCredential credential) async {
          Navigator.of(context).pop();
          AuthResult result = await _auth.signInWithCredential(credential);
          FirebaseUser user = result.user;
          if (user != null) {
            setState(() {
              isLoading=false;
              confirmOTP=true;
            });
            //saveUserAndGotoNextPage(context);
          }
        },
        ///If verification failed....
        verificationFailed: (AuthException exception) async {
          ///Show Alert Dialog....
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: Text("Incorrect phone number"),
                  content: FlatButton(
                    color: Colors.deepOrange,
                    onPressed: () {
                      setState(() {
                        isLoading=false;
                        errorMgs="";
                        confirmOTP=false;
                      });
                      Navigator.of(context).pop();
                    },
                    splashColor: Colors.deepOrange[300],
                    child: Text(
                      "Close",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              });
        },
        ///Manually code sent to user....
        codeSent: (String verificationId, [int forceResendingToken]) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: Text("Enter verification code"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _codeController,
                      ),
                      SizedBox(height: 10,),
                      FlatButton(
                        onPressed: () async {
                          final code = _codeController.text.trim();
                          AuthCredential credential =
                          PhoneAuthProvider.getCredential(
                            verificationId: verificationId,
                            smsCode: code,
                          );
                          AuthResult result =
                          await _auth.signInWithCredential(credential);
                          FirebaseUser user = result.user;
                          if (user != null) {
                            setState(() {
                              isLoading=false;
                              confirmOTP=true;
                            });
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text("Verify",style: TextStyle(fontSize: 16),),
                        textColor: Colors.white,
                        color: Colors.deepOrange,
                      ),
                    ],
                  ),

                );
              });
        },
        codeAutoRetrievalTimeout: null);
  }

  Future resetPassword() async{
    Firestore.instance.collection('Users').document(phone).updateData({
      'password': newPassword,
    }).then((value)async{
      preferences = await SharedPreferences.getInstance();
      preferences.setString("phone", phone);
      preferences.setString("password", newPassword);
    }).then((value){
      ///Show Alert Dialog....
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text("Password reset successful",
                  style: TextStyle(color: Colors.deepOrange),
                  textAlign: TextAlign.center),
              content: Container(
                child: FlatButton(
                  color: Colors.deepOrange,
                  onPressed: () {
                    setState(() {
                      isLoading=false;
                      errorMgs='';
                      confirmOTP=false;
                    });
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => Home(
                              userPhone: phone,
                            )),
                            (route) => false);
                  },
                  splashColor: Colors.deepOrange[300],
                  child: Text(
                    "Close",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            );
          });
    });
  }
}
