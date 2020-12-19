import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:gshop/shared/AdmobService.dart';
import 'package:gshop/shared/DatabaseManager.dart';
import 'package:gshop/shared/RoundDoubleValue.dart';
import 'package:gshop/shared/formDecoration.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
  // String videoURL ="https://www.youtube.com/watch?v=QFiTn9iuIhY";
  // YoutubePlayerController _youtubeController;
  final ams = AdMobService();
  InterstitialAd interstitialAd;

  @override
  void initState() {
    super.initState();
    // ///Youtube Video Player Controller...
    // _youtubeController = YoutubePlayerController(
    //   initialVideoId: YoutubePlayer.convertUrlToId(videoURL),
    // );
    interstitialAd = ams.getInterstitialAd();
    interstitialAd.load();
    fetchUser();
  }

  @override
  void dispose() {
    super.dispose();
    interstitialAd.show(
      anchorOffset: 0.0,
      horizontalCenterOffset: 0.0,
      anchorType: AnchorType.bottom,
    );
    AdMobService.hideBannerAd();
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
                            setState(() => isLoading = true);
                            fetchUser().then((value) {
                              if(user[0]['reward limit day'] == ""){
                                Firestore.instance.collection('Users').document(user[0]['phone']).updateData({
                                  'reward limit day': DateTime.now().day.toString(),
                                });
                                showRewardVideo();
                              }
                              else{
                                if(int.parse(user[0]['reward limit day']) < DateTime.now().day){
                                  Firestore.instance.collection('Users').document(user[0]['phone']).updateData({
                                    'reward limit day': DateTime.now().day.toString(),
                                    'video watched each day':0,
                                  });
                                  showRewardVideo();
                                }
                                else if(int.parse(user[0]['reward limit day']) == DateTime.now().day){
                                  showRewardVideo();
                                }
                                else if(int.parse(user[0]['reward limit day']) > DateTime.now().day){
                                  Firestore.instance.collection('Users').document(user[0]['phone']).updateData({
                                    'reward limit day': DateTime.now().day.toString(),
                                    'video watched each day':0,
                                  });
                                  showRewardVideo();
                                }
                              }
                            });


                          },
                          child: Text("Get My Free Coin",style: TextStyle(color: Colors.white),),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: size.height/30),

                // YoutubePlayer(
                //   controller: _youtubeController,
                // ),
                // SizedBox(height: size.height/10,),

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

    fetchUser().then((value) {
      if(user[0]['video watched each day'] < 20){
        RewardedVideoAd.instance..show();
        RewardedVideoAd.instance.listener =
            (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
          if (event == RewardedVideoAdEvent.rewarded) {
            dynamic rewardPoint = roundDouble((user[0]['point'] + points[0]['point']), 2);

            Firestore.instance.collection("Users").document(userPhone).updateData({
              'point': rewardPoint,
              'video watched': (user[0]['video watched']+1),
              'video watched each day': (user[0]['video watched each day']+1),
            }).then((value) {
              setState(() => isLoading = false);

              ///Show Alert Dialog....
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("You got ${points[0]['point']} points",textAlign: TextAlign.center),
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
      } //if statement
      else{
        ///Show Alert Dialog....
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: Text("Your video limit of the day is over",textAlign: TextAlign.center),
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
      }
    });

  }


}
