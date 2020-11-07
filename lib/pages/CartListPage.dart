import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gshop/pages/OrderPage.dart';
import 'package:gshop/shared/DatabaseManager.dart';
import 'package:gshop/shared/formDecoration.dart';
import 'package:gshop/shared/AdmobService.dart';

// ignore: must_be_immutable
class CartList extends StatefulWidget {
  String userPhone;
  dynamic userPoint;

  CartList({this.userPhone,this.userPoint});

  @override
  _CartListState createState() => _CartListState(this.userPhone,this.userPoint);
}

class _CartListState extends State<CartList> {
  _CartListState(this.userPhone, this.userPoint);

  String userPhone;
  dynamic userPoint;

  List cartsList = [];
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AdMobService.hideBannerAd();
    fetchCartList();
  }

  Future fetchCartList() async {
    dynamic result = await DatabaseManager().getCartList(userPhone);
    setState(() {
      cartsList = result;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        elevation: 0,
        title: Text('Cart List'),
      ),
      body: isLoading
          ? dualRing()
          : cartsList.length == 0
              ? noDataFoundMgs()
              : cartListBuilder(context),
    );
  }

  Widget noDataFoundMgs() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            color: Colors.grey,
            size: 70.0,
          ),
          Text(
            "Empty Cart",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 20.0),
          ),
        ],
      ),
    );
  }

  Widget cartListBuilder(BuildContext context) {
    fetchCartList();
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: ListView.builder(
          itemCount: cartsList.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.only(bottom: 20, top: 10),
              child: Column(
                children: [

                  ///Product Image....
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                      cartsList[index]['product image'],
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fitHeight,
                    ),
                  ),

                  ///Product Name....
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 10),
                    //alignment: Alignment.topLeft,
                    child: Text(
                      cartsList[index]['product name'],
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.grey[800]),
                    ),
                  ),

                  ///Product Quantity....
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 10),
                    //alignment: Alignment.topLeft,
                    child: Text(
                      "Quantity: ${cartsList[index]['product quantity']}",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700]),
                    ),
                  ),

                  ///Product Unit Point....
                  Container(
                    margin: EdgeInsets.only(top: 5, left: 10),
                    //alignment: Alignment.topLeft,
                    child: Text(
                      "Unit Coin: ${cartsList[index]['unit point']}",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700]),
                    ),
                  ),

                  ///Total Point....
                  Container(
                    margin: EdgeInsets.only(top: 5, left: 10),
                    //alignment: Alignment.topLeft,
                    child: Text(
                      "Total Coin: ${cartsList[index]['total price']}",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700]),
                    ),
                  ),

                  ///Product Size
                  cartsList[index]['ordered size']==null? Container() : Container(
                    margin: EdgeInsets.only(top: 5, left: 10),
                    //alignment: Alignment.topLeft,
                    child: Text(
                      "Ordered size: ${cartsList[index]['ordered size']}",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700]),
                    ),
                  ),
                  SizedBox(height: 10,),

                  ///Buttons....
                  Container(
                    //margin: EdgeInsets.only(top:30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlineButton(
                            onPressed: () {
                              deleteConfirmation(context,cartsList[index]['id']);
                            },
                            highlightedBorderColor: Colors.deepOrange,
                            focusColor: Colors.deepOrange,
                            splashColor: Colors.deepOrange[200],
                            borderSide: BorderSide(
                                color: Colors.deepOrange, width: 2.0),
                            child: Container(
                              child: Text(
                                "Remove",
                                style: TextStyle(
                                  color: Colors.deepOrange[700],
                                  fontSize: 14,
                                ),
                              ),
                            )),
                        SizedBox(width: 20,),

                        OutlineButton(
                            onPressed: () {
                              if(userPoint>= cartsList[index]['total price']){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>Order(userPhone: userPhone, productID: cartsList[index]['product id'],id: cartsList[index]['id'],)));
                              }
                              else{
                                ///Show Alert Dialog....
                                showDialog(context: context,
                                    barrierDismissible: false,
                                    builder: (context){
                                      return AlertDialog(
                                        title: Text("You have not enough point to buy this product."),
                                        content: Container(
                                          height: 110,
                                          child: Column(
                                            children: [
                                              Container(
                                            child: Text("You need ${(cartsList[index]['total price']-userPoint)} more points",style: TextStyle(color: Colors.green,fontWeight: FontWeight.w500),),
                                          ),
                                              SizedBox(height: 20,),
                                              FlatButton(
                                                color: Colors.deepOrange,
                                                onPressed: ()=> Navigator.of(context).pop(),
                                                splashColor: Colors.deepOrange[300],
                                                child: Text("Close",style: TextStyle(color: Colors.white),),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                );
                              }
                            },
                            highlightedBorderColor: Colors.green,
                            focusColor: Colors.green,
                            splashColor: Colors.green[200],
                            borderSide:
                            BorderSide(color: Colors.green, width: 2.0),
                            child: Center(
                              child: Text(
                                "Order",
                                style: TextStyle(
                                  color: Colors.green[700],
                                  fontSize: 14,
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                ],
              ),
            );
          }),
    );
  }

  void deleteConfirmation(BuildContext context, String id) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 110,
            margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 30.0),
            decoration: modalDecoration,
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 5.0),
                  child: Text(
                    "Remove this product from cart?",
                    style:
                    TextStyle(fontSize: MediaQuery.of(context).size.width/20, color: Colors.grey[800]),
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: IconButton(
                        icon: Icon(
                          Icons.check,
                          color: Colors.green,
                          size: MediaQuery.of(context).size.width/11,
                        ),
                        onPressed: () {
                          setState((){isLoading=true;});
                          Navigator.of(context).pop();
                          Firestore.instance.collection(userPhone).document(id).delete().then((value){
                            setState(() {
                              isLoading = false;
                              fetchCartList();
                            });
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 40.0),
                      child: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.red,
                          size: MediaQuery.of(context).size.width/11,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
