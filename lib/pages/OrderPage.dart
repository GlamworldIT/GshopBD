import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:gshop/shared/AdmobService.dart';
import 'package:gshop/shared/DatabaseManager.dart';
import 'package:gshop/shared/RoundDoubleValue.dart';
import 'package:gshop/shared/formDecoration.dart';

// ignore: must_be_immutable
class Order extends StatefulWidget {

  String userPhone;
  String productID;
  String id;
  Order({this.userPhone,this.productID,this.id});

  @override
  _OrderState createState() => _OrderState(this.userPhone,this.productID,this.id);
}

class _OrderState extends State<Order> {

  String userPhone;
  String productID;
  String id;
  _OrderState(this.userPhone,this.productID,this.id);

  bool isLoading = true;
  String loadingMgs = "";
  List users = [];
  List mainCartList = [];
  List particularCartList = [];
  List<DocumentSnapshot> particularProduct;
  String changedName, changedAddress, changedPhone;

  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAdMob.instance.initialize(appId: AdMobService().getAdMobAppId());
    fetchCartList();
  }
  @override
  void dispose(){
    super.dispose();
    AdMobService.hideBannerAd();
    showRewardVideo();
  }

  Future fetchCartList() async{
    dynamic result = await DatabaseManager().getCartList(userPhone);
    setState(() {
      mainCartList = result;
    });
    fetchUser();
  }

  Future fetchUser() async{
    dynamic result = await DatabaseManager().getUsers(userPhone);
    setState(() {
      users = result;
    });
    getParticularCartList();
  }

  Future getParticularCartList() async{
    particularCartList.clear();

    for(int i=0; i<mainCartList.length; i++){
      if(mainCartList[i]['id']==id){
        particularCartList.add(mainCartList[i]);
      }
    }
    retrievePreviousData();
  }

  Future retrievePreviousData() async{
    nameController = TextEditingController(text: users[0]['name']);
    addressController = TextEditingController(text: users[0]['address']);
    phoneController = TextEditingController(text: users[0]['phone']);

    getAvailableProductStock();
  }

  Future getAvailableProductStock() async{
    final QuerySnapshot result = await Firestore.instance.collection("Products")
        .where('id', isEqualTo: particularCartList[0]['product id']).getDocuments();
    setState(() {
      particularProduct = result.documents;
      isLoading = false;
    });
    AdMobService.showHomeBannerAd();
    loadRewardVideo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Confirm Your Order"),
        elevation: 0,
      ),

      body: isLoading ? loadingContainer() : bodyUI(),
    );
  }

  loadingContainer() {
    return Container(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            dualRing(),
            SizedBox(height: 10,),
            Text(
              "$loadingMgs",
              style: TextStyle(color: Colors.grey[700]),
            ),
          ],
        ),
      ),
      color: Colors.transparent,
    );
  }

  bodyUI() {
    return Container(
      margin: EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              SizedBox(height: 20,),
              Container(
                alignment: Alignment.topLeft,
                child: Text("Name : ",
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600])),
              ),
              TextFormField(
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.text,
                controller: nameController,
                validator: (value)=> value.isEmpty ? "Enter Name": null,
                decoration: updateDecoration.copyWith(
                    hintText: 'Your name'),
                onChanged: (value) {
                  setState(() => changedName = value);
                },
              ),
              SizedBox(height: 20,),

              Container(
                alignment: Alignment.topLeft,
                child: Text("Phone Number : ",
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600])),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: phoneController,
                validator: (value)=> value.isEmpty ? "Enter Phone Number": null,
                decoration: updateDecoration.copyWith(
                    hintText: 'Your Phone Number'),
                onChanged: (value) {
                  setState(() => changedPhone = value);
                },
              ),
              SizedBox(height: 20,),

              Container(
                alignment: Alignment.topLeft,
                child: Text("Address : ",
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600])),
              ),
              TextFormField(
                validator: (value)=> value.isEmpty ? "Enter Address": null,
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                controller: addressController,
                decoration: updateDecoration.copyWith(
                    hintText: 'Your address'),
                onChanged: (value) {
                  setState(() => changedAddress = value);
                },
              ),
              SizedBox(height: 20,),

              Container(
                alignment: Alignment.topLeft,
                child: Text("${particularCartList[0]['product name']}",
                style: TextStyle(color: Colors.grey[800],fontWeight: FontWeight.w500,fontSize: 16),),
              ),
              SizedBox(height: 10,),

              Container(
                alignment: Alignment.topLeft,
                child: Text("Order Quantity: ${particularCartList[0]['product quantity']}",
                  style: TextStyle(color: Colors.grey[700],fontWeight: FontWeight.w500,fontSize: 15),),
              ),
              SizedBox(height: 5,),

              Container(
                alignment: Alignment.topLeft,
                child: Text("Unit Coin: ${particularCartList[0]['unit point']}",
                  style: TextStyle(color: Colors.grey[700],fontWeight: FontWeight.w500,fontSize: 15),),
              ),
              SizedBox(height: 5,),

              Container(
                alignment: Alignment.topLeft,
                child: Text("Total Coin: ${particularCartList[0]['total price']}",
                  style: TextStyle(color: Colors.grey[700],fontWeight: FontWeight.w500,fontSize: 15),),
              ),
              SizedBox(height: 5,),

              particularCartList[0]['ordered size']==null? Container() :
              Container(
                alignment: Alignment.topLeft,
                child: Text("Size: ${particularCartList[0]['ordered size']}",
                  style: TextStyle(color: Colors.grey[700],fontWeight: FontWeight.w500,fontSize: 15),),
              ),
              SizedBox(height: 30,),

              ///Buttons....
              Container(
                //margin: EdgeInsets.only(top:30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlineButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        highlightedBorderColor: Colors.deepOrange,
                        focusColor: Colors.deepOrange,
                        splashColor: Colors.deepOrange[200],
                        borderSide: BorderSide(
                            color: Colors.deepOrange, width: 2.0),
                        child: Container(
                          child: Text(
                            "Cancel Order",
                            style: TextStyle(
                              color: Colors.deepOrange[700],
                              fontSize: 14,
                            ),
                          ),
                        )),
                    SizedBox(width: 20,),

                    OutlineButton(
                        onPressed: () {
                          if(_formKey.currentState.validate()){
                            setState(() {
                              isLoading = true;
                              loadingMgs = "Confirmation completing, please wait";
                            });
                            confirmOrder();
                          }
                        },
                        highlightedBorderColor: Colors.green,
                        focusColor: Colors.green,
                        splashColor: Colors.green[200],
                        borderSide:
                        BorderSide(color: Colors.green, width: 2.0),
                        child: Center(
                          child: Text(
                            "Confirm Order",
                            style: TextStyle(
                              color: Colors.green[700],
                              fontSize: 14,
                            ),
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(height: 50,),

            ],
          ),
        ),
      ),
    );
  }

  Future confirmOrder() async{
    String updatedName, updatedAddress, updatedPhone;
    String date = DateTime.now().millisecondsSinceEpoch.toString();
    double restUserPoint = roundDouble((users[0]['point'])-(particularCartList[0]['total price']),2);

    int orderQuantity = int.parse("${particularCartList[0]['product quantity']}");
    int productQuantity = int.parse("${particularProduct[0]['available stock']}");
    int restQuantity = productQuantity - orderQuantity;
    String restQtt;
    if(restQuantity.isNegative){
      restQtt = "";
    } else{restQtt = "$restQuantity";}

    if(changedName==null){
      updatedName = users[0]['name'];
    }
    else{
      updatedName = changedName;
    }
    if(changedAddress==null){
      updatedAddress = users[0]['address'];
    }
    else{
      updatedAddress = changedAddress;
    }
    if(changedPhone==null){
      updatedPhone = users[0]['phone'];
    }
    else{
      updatedPhone = changedPhone;
    }

    Firestore.instance.collection(userPhone).document(id).updateData({
      'customer phone': userPhone,
      'customer name': updatedName,
      'customer address': updatedAddress,
      'ordered phone': updatedPhone,
      'delivery report': 'processing',
      'state': 'ordered',
      'ordered date': date,
    }).then((value) {
      Firestore.instance.collection("Users").document(userPhone).updateData({
        'point': restUserPoint,
      }).then((value) {
        Firestore.instance.collection("Customer Order").document(userPhone+date).setData({
          'id': userPhone+date,
          'customer phone': userPhone,
          'customer name': updatedName,
          'customer address': updatedAddress,
          'delivery report': 'processing',
          'customer cartList id': id,

          'ordered phone': updatedPhone,
          'ordered date': date,
          'product size': particularCartList[0]['ordered size'],
          'product id': particularCartList[0]['product id'],
          'product image': particularCartList[0]['product image'],
          'product description': particularCartList[0]['product description'],
          'product name': particularCartList[0]['product name'],
          'product quantity': particularCartList[0]['product quantity'],
          'unit point': particularCartList[0]['unit point'],
          'total point': particularCartList[0]['total price'],
        }).then((value) {
          Firestore.instance.collection("Products").document(particularCartList[0]['product id']).updateData({
            'available stock': "$restQtt",
          });
          setState(() {
            isLoading = false;
          });
          ///Show Alert Dialog....
          showDialog(context: context,
              barrierDismissible: false,
              builder: (context){
                return AlertDialog(
                  title: Text("Order Confirmation Successful",textAlign: TextAlign.center),
                  content: FlatButton(
                    color: Colors.deepOrange,
                    onPressed: (){Navigator.of(context).pop();Navigator.of(context).pop();},
                    splashColor: Colors.deepOrange[300],
                    child: Text("Close",style: TextStyle(color: Colors.white),),
                  ),
                );
              }
          );
        });


      });
    },onError: (errorMgs){
      ///Show Alert Dialog....
      showDialog(context: context,
          barrierDismissible: false,
          builder: (context){
            return AlertDialog(
              title: Text(errorMgs.toString(),textAlign: TextAlign.center),
              content: FlatButton(
                color: Colors.deepOrange,
                onPressed: ()=> Navigator.of(context).pop(),
                splashColor: Colors.deepOrange[300],
                child: Text("Close",style: TextStyle(color: Colors.white),),
              ),
            );
          }
      );
    });
  }

  loadRewardVideo() {
    RewardedVideoAd.instance.load(
        adUnitId: AdMobService().getRewardAdId(),
        targetingInfo: MobileAdTargetingInfo());
  }

  showRewardVideo() {
    //loadRewardVideo();
    RewardedVideoAd.instance..show();
    RewardedVideoAd.instance.listener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      if (event == RewardedVideoAdEvent.rewarded) {
        Navigator.of(context).pop();
      }
    };
  }
}
