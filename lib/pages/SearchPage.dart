import 'package:flutter/material.dart';
import 'package:gshop/shared/AdmobService.dart';
import 'package:gshop/shared/DatabaseManager.dart';
import 'ProductDetailsPage.dart';

// ignore: must_be_immutable
class Search extends StatefulWidget {

  String userPhone;
  dynamic userPoint;
  Search({this.userPhone,this.userPoint});

  @override
  _SearchState createState() => _SearchState(this.userPhone,this.userPoint);
}

class _SearchState extends State<Search> {
  String userPhone;
  dynamic userPoint;
  _SearchState(this.userPhone,this.userPoint);

  TextEditingController searchEditingController = TextEditingController();
  bool isSearch = false;
  String searchQuery;
  List searchedProducts = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AdMobService.hideBannerAd();
  }

  Future fetchSearchProducts() async {
    dynamic results = await DatabaseManager().getSearchedProducts(searchQuery);
    setState(() {
      searchedProducts = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: customAppBar(),
      body: isSearch ? customSearch(context) : noDataFoundMgs(),
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
            "No Products",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 20.0),
          ),
        ],
      ),
    );
  }

  Widget customSearch(BuildContext context) {
    Size size= MediaQuery.of(context).size;
    fetchSearchProducts();
    return searchedProducts.length == 0
        ? noDataFoundMgs()
        : Container(
            padding: EdgeInsets.all(10),
            color: Colors.grey[200],
            child: GridView.builder(
              itemCount: searchedProducts.length,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: size.width/2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.7),
              //reverse: true,
              //scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => Card(
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> ProductDetails(
                      userPhone: userPhone,
                      userPoint: userPoint,
                      productId: searchedProducts[index]['id'],
                      productName: searchedProducts[index]['name'],
                      productImage: searchedProducts[index]['image'],
                      productDesc: searchedProducts[index]['description'],
                      productPoint: searchedProducts[index]['price'],
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
                          height: 100,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      Container(
                          child: ListTile(
                        contentPadding: EdgeInsets.all(5),
                        title: Text(
                          searchedProducts[index]['name'],
                          style: TextStyle(color: Colors.grey[800]),
                          maxLines: 3,
                        ),
                        subtitle: Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "৳: ${searchedProducts[index]['price']} Coin",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(color: Colors.deepOrange),
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

  customAppBar() {
    return AppBar(
      iconTheme: IconThemeData(
        color: Colors.deepOrange,
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      title: Container(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
        child: TextFormField(
          textCapitalization: TextCapitalization.words,
          keyboardType: TextInputType.text,
          //cursorColor: Colors.grey[700],
          style: TextStyle(fontSize: 17, color: Colors.deepOrange[800]),
          controller: searchEditingController,
          decoration: InputDecoration(
            hintText: 'Search products...',
            hintStyle: TextStyle(color: Colors.grey[400]),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(5),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(5),
            ),
            filled: false,
            suffixIcon: IconButton(
              splashRadius: 25,
              icon: Icon(
                Icons.clear,
                color: Colors.grey,
              ),
              onPressed: () {
                searchEditingController.clear();
                setState(() {
                  isSearch = false;
                });
              },
            ),
          ),
          onChanged: (value) {
            setState(() {
              searchQuery = value;
              if (searchQuery == "") {
                isSearch = false;
              } else {
                isSearch = true;
              }
            });
          },
        ),
      ),
    );
  }
}
