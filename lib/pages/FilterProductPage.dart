
import 'package:flutter/material.dart';
import 'package:gshop/pages/ProductDetailsPage.dart';
import 'package:gshop/shared/DatabaseManager.dart';
import 'package:gshop/shared/formDecoration.dart';

// ignore: must_be_immutable
class FilterProduct extends StatefulWidget {
  String userPhone;
  dynamic userPoint;

  FilterProduct({this.userPhone, this.userPoint});

  @override
  _FilterProductState createState() =>
      _FilterProductState(this.userPhone, this.userPoint);
}

class _FilterProductState extends State<FilterProduct> {
  String userPhone;
  dynamic userPoint;

  _FilterProductState(this.userPhone, this.userPoint);

  String minCoin = "", maxCoin = "";
  List products = [];
  List searchedProducts = [];
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchProducts();
  }

  Future fetchProducts() async {
    dynamic result = await DatabaseManager().getProducts();
    if (result != null) {
      setState(() {
        products = result;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: customAppBer(),
      body: isLoading ? dualRing() : bodyUI(),
    );
  }

  Widget customAppBer() {
    Size size = MediaQuery.of(context).size;
    return AppBar(
      iconTheme: IconThemeData(
        color: Colors.deepOrange,
      ),
      backgroundColor: Colors.white,
      title:
          ///Search Bar Container....
          Container(
        // color: Colors.grey[200],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: size.width / 3.5,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        hintText: "min coin",
                        hintStyle: TextStyle(color: Colors.grey)),
                    onChanged: (min) => minCoin = min,
                  ),
                ),
                SizedBox(
                  width: size.width / 25,
                ),
                Container(
                  width: size.width / 3.5,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        hintText: "max coin",
                        hintStyle: TextStyle(color: Colors.grey)),
                    onChanged: (max) => maxCoin = max,
                  ),
                ),
              ],
            ),
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border.all(color: Colors.transparent, width: 1),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {
                  if (maxCoin != "" && minCoin != "") {
                    setState(() => isLoading = true);
                    getSearchedProduct();
                  } else {
                    setState(() => isLoading = false);
                    ///Show Alert Dialog....
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Search field can't be empty !",
                                style: TextStyle(color: Colors.redAccent),
                                textAlign: TextAlign.center),
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
                },
                splashColor: Colors.deepOrange[400],
                splashRadius: 25,
                color: Colors.blue,
                icon: Icon(
                  Icons.search,
                  size: 25,
                  color: Colors.deepOrange,
                ),
              ),
            ),
          ],
        ),
      ),
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
        ],
      ),
    );
  }

  void getSearchedProduct(){
    searchedProducts.clear();
    int min = int.parse(minCoin);
    int max = int.parse(maxCoin);

    for(int i=0; i<products.length; i++){
      if(products[i]['price']>=min && products[i]['price']<=max){
        setState(() {
          searchedProducts.add(products[i]);
        });
      }
    }
    setState(()=> isLoading=false);
  }

  Widget bodyUI() {
    Size size = MediaQuery.of(context).size;
    return searchedProducts.length == 0
        ? noDataFoundMgs()
        : Container(
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            color: Colors.grey[200],
            height: size.height,
            width: size.width,
            child: GridView.builder(
              itemCount: searchedProducts.length,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: size.width / 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.7),
              //reverse: true,
              //scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => Card(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductDetails(
                                  userPhone: userPhone,
                                  userPoint: userPoint,
                                  productId: searchedProducts[index]['id'],
                                  productName: searchedProducts[index]['name'],
                                  productImage: searchedProducts[index]
                                      ['image'],
                                  productDesc: searchedProducts[index]
                                      ['description'],
                                  productPoint: searchedProducts[index]
                                      ['price'],
                                  productSize: searchedProducts[index]['size'],
                                )));
                  },
                  splashColor: Colors.deepOrange[200],
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: Image.network(
                          searchedProducts[index]['image'],
                          width: MediaQuery.of(context).size.width,
                          height: size.height / 7,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      Container(
                          child: ListTile(
                        contentPadding: EdgeInsets.all(5),
                        title: Text(
                          searchedProducts[index]['name'],
                          style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: size.width / 27),
                          maxLines: 3,
                        ),
                        subtitle: Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "${searchedProducts[index]['price']} Coin",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colors.deepOrange,
                                      fontSize: size.width / 21,
                                      fontWeight: FontWeight.w500),
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
