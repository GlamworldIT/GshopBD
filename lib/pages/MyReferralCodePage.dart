import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:gshop/shared/AdmobService.dart';

// ignore: must_be_immutable
class MyReferralCode extends StatefulWidget {
  String referralCode;
  MyReferralCode({this.referralCode});

  @override
  _MyReferralCodeState createState() => _MyReferralCodeState();
}

class _MyReferralCodeState extends State<MyReferralCode> {

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
        title: Text("Your Referral Code"),
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
        height: size.height / 3,
        width: size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Share this referral code and get bonus Coin !!!",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.deepOrange,
                    fontSize: size.width/15
                ),
              ),
              SizedBox(height: size.height/20),
              Text(
                "Code: ${widget.referralCode}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: size.width/20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


