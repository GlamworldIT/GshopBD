import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:gshop/shared/AdmobService.dart';
import 'package:gshop/shared/formDecoration.dart';

// ignore: must_be_immutable
class UpdateAccount extends StatefulWidget {
  String userPhone;
  String userName;
  String userAddress;
  dynamic userPoint;

  UpdateAccount(
      {this.userPhone, this.userName, this.userAddress, this.userPoint});

  @override
  _UpdateAccountState createState() => _UpdateAccountState(
      this.userPhone, this.userName, this.userAddress, this.userPoint);
}

class _UpdateAccountState extends State<UpdateAccount> {
  String userPhone;
  String userName;
  String userAddress;
  dynamic userPoint;

  _UpdateAccountState(
      this.userPhone, this.userName, this.userAddress, this.userPoint);

  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAdMob.instance.initialize(appId: AdMobService().getAdMobAppId());
    retrievePreviousData();
  }

  @override
  void dispose() {
    super.dispose();
    AdMobService.hideBannerAd();
  }

  retrievePreviousData() {
    nameController = TextEditingController(text: userName);
    addressController = TextEditingController(text: userAddress);

    AdMobService.showHomeBannerAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        elevation: 0,
        title: Text("Update Account"),
      ),
      body: bodyUI(),
    );
  }


  Widget bodyUI() {
    return isLoading
        ? Container(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  dualRing(),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Updating, please wait",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          )
        : Container(
            padding: EdgeInsets.all(10),
            child: Stack(children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                        shape: BoxShape.circle,
                        color: Colors.white,
                        image: DecorationImage(
                            image: AssetImage("assets/image/profile.png"),
                            fit: BoxFit.cover),
                      ),
                    ),

                    Text(
                      "$userPhone",
                      style: TextStyle(
                          color: Colors.deepOrange,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),

                    SizedBox(height: 10),

                    ///Horizontal Line....
                    Container(
                        color: Colors.grey,
                        child: CustomPaint(
                          size: Size(MediaQuery.of(context).size.width, 1),
                        )),

                    SizedBox(
                      height: 50,
                    ),

                    Container(
                      alignment: Alignment.topLeft,
                      child: Text("Name : ",
                          style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600])),
                    ),
                    TextField(
                      textCapitalization: TextCapitalization.words,
                      controller: nameController,
                      decoration:
                          updateDecoration.copyWith(hintText: 'Your Name'),
                      onChanged: (value) {
                        setState(() => userName = value);
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    Container(
                      alignment: Alignment.topLeft,
                      child: Text("Address : ",
                          style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600])),
                    ),
                    TextField(
                      textCapitalization: TextCapitalization.words,
                      controller: addressController,
                      maxLines: 5,
                      decoration:
                          updateDecoration.copyWith(hintText: 'Your Address'),
                      onChanged: (value) {
                        setState(() => userAddress = value);
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    OutlineButton(
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                          });
                          updateUserInfo();
                        },
                        highlightedBorderColor: Colors.green,
                        focusColor: Colors.green,
                        splashColor: Colors.green[200],
                        borderSide: BorderSide(color: Colors.green, width: 2.0),
                        child: Container(
                          width: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.update_outlined,
                                color: Colors.green,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                "Update",
                                style: TextStyle(
                                  color: Colors.green[700],
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ]),
          );
  }

  Future<void> updateUserInfo() async {
    Firestore.instance.collection("Users").document(userPhone).updateData({
      "name": userName,
      "address": userAddress,
    }).then((data) async {
      setState(() {
        isLoading = false;
      });

      ///Show Alert Dialog....
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text("Information Updated",textAlign: TextAlign.center),
              content: FlatButton(
                color: Colors.deepOrange,
                onPressed: () {
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
    }, onError: (errorMgs) {
      print(errorMgs.toString());
      setState(() {
        isLoading = false;
      });
    });
  }
}
