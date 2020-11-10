import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:gshop/pages/HomePage.dart';
import 'package:gshop/shared/AdmobService.dart';
import 'package:gshop/shared/RoundDoubleValue.dart';
import 'package:gshop/shared/formDecoration.dart';

// ignore: must_be_immutable
class VerifyReferral extends StatefulWidget {
  String userPhone;

  VerifyReferral({this.userPhone});

  @override
  _VerifyReferralState createState() => _VerifyReferralState(this.userPhone);
}

class _VerifyReferralState extends State<VerifyReferral> {
  String userPhone;

  _VerifyReferralState(this.userPhone);

  final _formKey = GlobalKey<FormState>();
  String toVerifyReferral;
  bool isLoading = false;
  String errorMgs = "";
  final ams = AdMobService();
  InterstitialAd interstitialAd;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    interstitialAd = ams.getInterstitialAd();
    interstitialAd.load();
    AdMobService.showHomeBannerAd();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    interstitialAd.show(
      anchorOffset: 0.0,
      horizontalCenterOffset: 0.0,
      anchorType: AnchorType.bottom,
    );
    AdMobService.hideBannerAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        elevation: 0,
        title: Text("Verify Referral Code"),
      ),
      body: bodyUI(context),
    );
  }

  Widget bodyUI(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.orange[100],
        ),
        margin: EdgeInsets.all(10),
        height: size.height / 2.5,
        width: size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration:
                      updateDecoration.copyWith(hintText: 'Referral Code'),
                  validator: (val) =>
                      val.isEmpty ? "Enter Referral Code" : null,
                  onChanged: (value) {
                    setState(() => toVerifyReferral = value);
                  },
                ),
                SizedBox(height: size.height / 23),
                FlatButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        setState(() {
                          isLoading = true;
                          errorMgs = "";
                        });
                        verifyReferral();
                      }
                    },
                    color: Colors.deepOrange,
                    splashColor: Colors.white,
                    child: Text(
                      "Verify Code",
                      style: TextStyle(color: Colors.white),
                    )),
                SizedBox(height: size.height / 40),
                isLoading
                    ? dualRing()
                    : Container(
                        child: Text(
                          errorMgs,
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future verifyReferral() async {
    final QuerySnapshot snapshot = await Firestore.instance
        .collection('Users')
        .where('phone', isEqualTo: toVerifyReferral)
        .getDocuments();
    List<DocumentSnapshot> referralUser = snapshot.documents;

    final QuerySnapshot querySnapshot = await Firestore.instance
        .collection('Users')
        .where('phone', isEqualTo: userPhone)
        .getDocuments();
    List<DocumentSnapshot> myself = querySnapshot.documents;

    if(myself[0]['phone']!=toVerifyReferral){
      if (referralUser.length != 0) {
        if (myself[0]['verify referral'] == 'false') {
          dynamic updatedPoint = roundDouble((referralUser[0]['point'] + 10.0), 2);
          Firestore.instance
              .collection('Users')
              .document(toVerifyReferral)
              .updateData({
            'point': updatedPoint,
            'total referred': (referralUser[0]['total referred']+1),
          }).then((value) {
            Firestore.instance
                .collection('Users')
                .document(userPhone)
                .updateData({
              'verify referral': 'true',
            });
            setState(() {
              isLoading = false;
              errorMgs = "";
            });

            ///Show Alert Dialog....
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return AlertDialog(
                    title: Text("The person of this Referral Code got 10 Coin",
                        style: TextStyle(color: Colors.green),
                        textAlign: TextAlign.center),
                    content: FlatButton(
                      color: Colors.deepOrange,
                      onPressed: () {
                        Navigator.of(context).pop();
                        //Navigator.push(context, MaterialPageRoute(builder: (context)=> Home(userPhone: userPhone,)));
                      },
                      splashColor: Colors.deepOrange[300],
                      child: Text(
                        "Close",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                });
          });
        } else {
          setState(() {
            isLoading = false;
            errorMgs = "Verification limit expired";
          });
        }
      } else {
        setState(() {
          isLoading = false;
          errorMgs = "Wrong Referral Code";
        });
      }
    }
    else{
      setState(() {
        isLoading = false;
        errorMgs = "Own Referral Code doesn't excepted";
      });
    }
  }
}
