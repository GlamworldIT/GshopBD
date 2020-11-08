import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gshop/pages/OrderPage.dart';
import 'package:gshop/shared/AdmobService.dart';
import 'package:gshop/shared/RoundDoubleValue.dart';
import 'package:gshop/shared/formDecoration.dart';

// ignore: must_be_immutable
class ProductDetails extends StatefulWidget {
  String userPhone;
  dynamic userPoint;
  String productId;
  String productImage;
  String productName;
  dynamic productPoint;
  String productDesc;
  String productSize;

  ProductDetails(
      {this.userPhone,
      this.userPoint,
      this.productId,
      this.productImage,
      this.productName,
      this.productPoint,
      this.productDesc,
      this.productSize});

  @override
  _ProductDetailsState createState() => _ProductDetailsState(
      this.userPhone,
      this.userPoint,
      this.productId,
      this.productImage,
      this.productName,
      this.productPoint,
      this.productDesc,
      this.productSize);
}

class _ProductDetailsState extends State<ProductDetails> {
  _ProductDetailsState(
      this.userPhone,
      this.userPoint,
      this.productId,
      this.productImage,
      this.productName,
      this.productPoint,
      this.productDesc,
      this.productSize);

  String userPhone;
  dynamic userPoint;

  String productId;
  String productImage;
  String productName;
  dynamic productPoint;
  String productDesc;
  String productSize;

  bool isLoading = false;
  dynamic purchasedAmount = 1;
  dynamic totalAmount;

  final _formKey = GlobalKey<FormState>();
  String orderedSize;
  bool needSize = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAdMob.instance.initialize(appId: AdMobService().getAdMobAppId());
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
        elevation: 0,
        title: Text("Product Details"),
      ),
      body: bodyUI(),
    );
  }

  Widget bodyUI() {
    Size size = MediaQuery.of(context).size;
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
                    "Please wait",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          )
        : Container(
            child: Stack(
              children: [
                SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Container(
                    margin: EdgeInsets.only(
                        top: 0, bottom: 20, left: 10, right: 10),
                    child: Column(
                      children: [
                        ///Product Image....
                        Container(
                          color: Colors.white,
                          child: Image.network(
                            productImage,
                            width: MediaQuery.of(context).size.width,
                            height: size.height / 2.5,
                            fit: BoxFit.fitHeight,
                          ),
                        ),

                        ///Product Point....
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          alignment: Alignment.topLeft,
                          child: Text(
                            "৳: $productPoint Coin",
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              color: Colors.deepOrange,
                              fontSize: size.width / 18,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                        ),

                        ///Product Name....
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          alignment: Alignment.topLeft,
                          child: Text(
                            productName,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: size.width / 23,
                                color: Colors.grey[800]),
                          ),
                        ),

                        ///Product Size....
                        productSize == null
                            ? Container()
                            : Container(
                                margin: EdgeInsets.only(top: 10),
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Available Size: $productSize",
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                              ),

                        ///Product Description....
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          alignment: Alignment.topLeft,
                          child: Text(
                            productDesc,
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),

                        ///Quantity Button....
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                height: 45,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.deepOrange, width: 1),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      "Quantity: ",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[800]),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.remove),
                                      onPressed: () {
                                        if (purchasedAmount > 1) {
                                          setState(() {
                                            purchasedAmount--;
                                          });
                                        }
                                      },
                                      splashRadius: 20,
                                      splashColor: Colors.deepOrange[300],
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      //color: Colors.white,
                                      width: 50,
                                      child: Text(
                                        "$purchasedAmount",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () {
                                        setState(() {
                                          purchasedAmount++;
                                        });
                                      },
                                      splashRadius: 20,
                                      splashColor: Colors.deepOrange[300],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),

                        ///Ordered Size....
                        productSize == null
                            ? Container()
                            : Container(
                                margin: EdgeInsets.only(top: 20),
                                width: 230,
                                child: Form(
                                  key: _formKey,
                                  child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    decoration: updateDecoration.copyWith(
                                        hintText: 'Product size'),
                                    validator: (value) =>
                                        value.isEmpty ? "Enter size" : null,
                                    onChanged: (value) {
                                      setState(() => orderedSize = value);
                                    },
                                  ),
                                ),
                              ),

                        ///Buttons....
                        Container(
                          margin: EdgeInsets.only(top: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ///Add to cart....
                              OutlineButton(
                                  onPressed: () {
                                    if (productSize == null) {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      addProductToCart();
                                    } else {
                                      if (_formKey.currentState.validate()) {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        addProductToCart();
                                      }
                                    }
                                  },
                                  highlightedBorderColor: Colors.deepOrange,
                                  focusColor: Colors.deepOrange,
                                  splashColor: Colors.deepOrange[200],
                                  borderSide: BorderSide(
                                      color: Colors.deepOrange, width: 2.0),
                                  child: Container(
                                    child: Text(
                                      "Add to Cart",
                                      style: TextStyle(
                                        color: Colors.deepOrange[700],
                                        fontSize: 16,
                                      ),
                                    ),
                                  )),
                              SizedBox(
                                width: 10,
                              ),

                              ///Direct Order....
                              OutlineButton(
                                  onPressed: () {
                                    if (productSize == null) {
                                      directOrder();
                                    } else {
                                      if (_formKey.currentState.validate()) {
                                        directOrder();
                                      }
                                    }
                                  },
                                  highlightedBorderColor: Colors.green,
                                  focusColor: Colors.green,
                                  splashColor: Colors.green[200],
                                  borderSide: BorderSide(
                                      color: Colors.green, width: 2.0),
                                  child: Container(
                                    child: Text(
                                      "Order Now",
                                      style: TextStyle(
                                        color: Colors.green[700],
                                        fontSize: 16,
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
  }

  Future<void> addProductToCart() async {
    totalAmount = (productPoint * purchasedAmount);
    String date = DateTime.now().millisecondsSinceEpoch.toString();

    Firestore.instance
        .collection(userPhone)
        .document(userPhone + date)
        .setData({
      'id': userPhone + date,
      'product id': productId,
      'product name': productName,
      'product image': productImage,
      'total price': totalAmount,
      'product quantity': purchasedAmount,
      'product description': productDesc,
      'unit point': productPoint,
      'ordered size': orderedSize,
      'state': 'carted',
      'delivery report': "",
    }).then((value) {
      ///Show Alert Dialog....
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text("Product added to cart",textAlign: TextAlign.center),
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

      setState(() {
        isLoading = false;
      });
    }, onError: (errorMgs) {
      print(errorMgs.toString());
    });
  }

  Future<void> directOrder() async {
    totalAmount = (productPoint * purchasedAmount);

    var needPoint = roundDouble((totalAmount - userPoint), 2);

    if (userPoint >= totalAmount) {
      setState(() {
        isLoading = true;
      });
      String date = DateTime.now().millisecondsSinceEpoch.toString();
      String id = userPhone + date;

      Firestore.instance
          .collection(userPhone)
          .document(userPhone + date)
          .setData({
        'id': id,
        'product id': productId,
        'product name': productName,
        'product image': productImage,
        'total price': totalAmount,
        'product quantity': purchasedAmount,
        'product description': productDesc,
        'unit point': productPoint,
        'ordered size': orderedSize,
        'state': 'carted',
        'delivery report': "",
      }).then((value) {
        setState(() {
          isLoading = false;
        });
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Order(
                      userPhone: userPhone,
                      productID: productId,
                      id: id,
                    )));
      });
    } else {
      ///Show Alert Dialog....
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text("You have not enough coin",textAlign: TextAlign.center),
              content: Container(
                height: 110,
                child: Column(
                  children: [
                    Container(
                      child: Text(
                        "You need $needPoint more coin",textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FlatButton(
                      color: Colors.deepOrange,
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          isLoading = false;
                        });
                      },
                      splashColor: Colors.deepOrange[300],
                      child: Text(
                        "Close",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    }
  }
}
