import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:gshop/shared/AdmobService.dart';
import 'package:gshop/shared/DatabaseManager.dart';
import 'package:gshop/shared/RoundDoubleValue.dart';
import 'package:gshop/shared/formDecoration.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// ignore: must_be_immutable
class GetRewardPoint extends StatefulWidget {
  String userPhone;

  GetRewardPoint({this.userPhone});

  @override
  _GetRewardPointState createState() => _GetRewardPointState(this.userPhone);
}

class _GetRewardPointState extends State<GetRewardPoint> {
  _GetRewardPointState(this.userPhone);

  String userPhone;
  bool isLoading = true;
  List user;
  List points=[];
  String videoURL ="https://www.youtube.com/watch?v=QFiTn9iuIhY";
  YoutubePlayerController _youtubeController;

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance.initialize(appId: AdMobService().getAdMobAppId());

    ///Youtube Video Player Controller...
    _youtubeController = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(videoURL),
    );
    fetchUser();
  }

  Future fetchUser() async {
    dynamic result = await DatabaseManager().getUsers(userPhone);
    setState(() {
      user = result;
    });
    getRewardPoint();
  }

  Future getRewardPoint() async {
    final QuerySnapshot querySnapshot =
    await Firestore.instance.collection("Point per video").getDocuments();

    points = querySnapshot.documents;
    setState(() {
      isLoading = false;
    });
    AdMobService.showHomeBannerAd();
  }

  @override
  void dispose() {
    super.dispose();
    AdMobService.hideBannerAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Get Free Coin"),
        elevation: 0,
      ),
      body: isLoading ? dualRing() : bodyUI(),
    );
  }

  Widget bodyUI() {
    Size size = MediaQuery.of(context).size;
    fetchUser();
    getRewardPoint();
    loadRewardVideo();
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10,),
                ///Balance Container....
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    height: size.height/8,
                    color: Colors.yellowAccent[700],
                    child: Column(
                      children: [
                        CircleAvatar(
                          child: Icon(
                            Icons.monetization_on_outlined,
                            size: 40,
                            color: Colors.deepOrange,
                          ),
                          backgroundColor: Colors.yellowAccent[700],
                        ),
                        Text(
                          "Your total coin: ${user[0]['point']}",
                          style: TextStyle(
                              color: Colors.deepOrange,
                              fontSize: size.width/20,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: size.height/30,),

                Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      child: Container(
                        child: Image.asset(
                          "assets/gif/bc.gif",
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          child: Text(
                            "Watch video and get free coin !",
                            style: TextStyle(color: Colors.white,fontSize: size.width/20),
                          ),
                        ),
                        SizedBox(height: size.height/30),

                        RaisedButton(
                          color: Colors.deepOrange,
                          onPressed: () {
                            setState(() {
                              isLoading = true;
                            });
                            showRewardVideo();
                          },
                          child: Text("Get My Free Coin",style: TextStyle(color: Colors.white),),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: size.height/30),

                YoutubePlayer(
                  controller: _youtubeController,
                ),
                SizedBox(height: size.height/10,),

              ],
            ),
          )
        ],
      ),
    );
  }

  loadRewardVideo() {
    RewardedVideoAd.instance.load(
        adUnitId: AdMobService().getRewardAdId(),
        targetingInfo: MobileAdTargetingInfo());
  }

  showRewardVideo() {
    RewardedVideoAd.instance..show();
    RewardedVideoAd.instance.listener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      if (event == RewardedVideoAdEvent.rewarded) {
        fetchUser();
        dynamic rewardPoint = roundDouble((user[0]['point'] + points[0]['point']), 2);

        Firestore.instance.collection("Users").document(userPhone).updateData({
          'point': rewardPoint,
        }).then((value) {
          setState(() => isLoading = false);

          ///Show Alert Dialog....
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: Text("You got ${points[0]['point']} points"),
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
        });
      }
    };
  }
}
