import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gshop/pages/HomePage.dart';
import 'package:gshop/pages/RegisterPage.dart';
import 'package:gshop/shared/formDecoration.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {

  final _formKey = GlobalKey<FormState>();
  String phone;
  String password;
  bool isLoading = false;
  String errorMgs = '';
  SharedPreferences preferences;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // AdMobService.hideBannerAd();
    // fetchUser();
    checkAlreadyCheckedIn();
  }

  checkAlreadyCheckedIn() async{
    preferences = await SharedPreferences.getInstance();
    String phone= preferences.getString('phone');
    String password= preferences.getString('password');
    if(!(phone==null) && !(password==null)){
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Home(userPhone: phone)),(route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.yellowAccent[700],
        body: bodyUITwo(context),
    );
  }

  Widget bodyUITwo(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: size.height/25),
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
                    child: Image.asset("assets/image/lg.png",
                    height: 100,),
                  ),
                ),
                // Text(
                //   "Login",
                //   style: TextStyle(
                //       color: Colors.white,
                //       fontSize: MediaQuery.of(context).size.height / 25),
                // ),MediaQuery.of(context).size.height / 15MediaQuery.of(context).size.height / 15
                SizedBox(height: MediaQuery.of(context).size.height / 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(50),bottomLeft: Radius.circular(50)),
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
                                decoration: textInputDecoration,
                                keyboardType: TextInputType.phone,
                                validator: (value) =>
                                value.isEmpty ? "Enter Phone Number" : null,
                                onChanged: (value) {
                                  setState(() => phone = value);
                                },
                              ),
                              SizedBox(height: size.height/35,),

                              TextFormField(
                                obscureText: true,
                                decoration: textInputDecoration.copyWith(hintText: "Password",prefixIcon: Icon(Icons.security_rounded)),
                                keyboardType: TextInputType.text,
                                validator: (value) =>
                                value.isEmpty ? "Enter Password" : null,
                                onChanged: (value) {
                                  setState(() => password = value);
                                },
                              ),

                              Padding(
                                padding: const EdgeInsets.only(top: 10,right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text("New user? ",style: TextStyle(color: Colors.grey[800],fontSize: size.width/25)),
                                    InkWell(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=> Register()));
                                      },
                                      splashColor: Colors.white,
                                      child: Text("register",style: TextStyle(color: Colors.deepOrange,fontSize: size.width/22),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: size.height/30,),

                              InkWell(
                                onTap: (){
                                  if (_formKey.currentState.validate()) {
                                    if (phone.length==11) {
                                      setState(() {
                                        isLoading = true;
                                        errorMgs ="";
                                        userLogIn(context);
                                      });
                                    } else {
                                      setState(() {
                                        errorMgs = "Phone number must be 11 digit";
                                        isLoading = false;
                                      });
                                    }
                                  } else {
                                    setState(() {
                                     errorMgs ="";
                                      isLoading = false;
                                    });
                                  }

                                },
                                splashColor: Colors.white,
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 150,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: Colors.deepOrange,
                                    border: Border.all(
                                        color: Colors.deepOrange, width: 1.0),
                                    borderRadius:  BorderRadius.only(topRight: Radius.circular(50),bottomLeft: Radius.circular(50)),
                                  ),
                                  child: Text(
                                    "Sign in",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                        MediaQuery.of(context).size.height /
                                            40,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Container(
                                child: isLoading ? dualRing() : Container(child: Text(errorMgs, style: TextStyle(color: Colors.red),),),
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


  Future userLogIn(BuildContext context) async {
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection("Users").where('phone', isEqualTo: phone).getDocuments();
      List users = querySnapshot.documents;

      if(users.length!=0){
        if(users[0]['password']==password){
          preferences = await SharedPreferences.getInstance();
          preferences.setString("phone", phone);
          preferences.setString("password", password);
          setState(() {
            isLoading = false;
            errorMgs ="";
          });
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => Home(
                    userPhone: phone,
                  )),
                  (route) => false);
        }
        else{
          setState(() {
            isLoading = false;
            errorMgs ="Wrong password";
          });
        }
      }
      else{
        setState(() {
          isLoading = false;
          errorMgs ="Wrong phone number";
        });
      }


  }




}
