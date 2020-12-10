import 'package:flutter/material.dart';
import 'package:gshop/main.dart';
import 'package:gshop/pages/CartListPage.dart';
import 'package:gshop/pages/FilterProductPage.dart';
import 'package:gshop/pages/VerifyReferralPage.dart';
import 'package:gshop/pages/GetRewardPointPage.dart';
import 'package:gshop/pages/OrderListPage.dart';
import 'package:gshop/pages/ProductDetailsPage.dart';
import 'package:gshop/pages/SearchPage.dart';
import 'package:gshop/pages/MyReferralCodePage.dart';
import 'package:gshop/pages/UpdateAccountPage.dart';
import 'package:gshop/shared/AdmobService.dart';
import 'package:gshop/shared/DatabaseManager.dart';
import 'package:gshop/pages/LoginPage.dart';
import 'package:gshop/pages/ContactUsPage.dart';
import 'package:gshop/shared/formDecoration.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  final String userPhone;

  Home({this.userPhone});

  @override
  _HomeState createState() => _HomeState(this.userPhone);
}

class _HomeState extends State<Home> {
  String userPhone;

  _HomeState(this.userPhone);

  List users = [];
  List products = [];
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //AdMobService.hideBannerAd();
    fetchProducts();
  }

  Future fetchProducts() async {
    dynamic result = await DatabaseManager().getProducts();
    if (result != null) {
      setState(() {
        products = result;
      });
    }
    fetchUser();
  }

  Future fetchUser() async {
    dynamic result = await DatabaseManager().getUsers(userPhone);
    if (result != null) {
      setState(() {
        users = result;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    fetchProducts();
    fetchUser();
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "GShop BD",
          style: TextStyle(fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Search(
                            userPhone: userPhone,
                            userPoint: users[0]['point'],
                          )));
            },
            icon: Icon(
              Icons.search_rounded,
              color: Colors.white,
            ),
            splashColor: Colors.white,
            splashRadius: 20,
            enableFeedback: true,
          ),
        ],
      ),
      body: isLoading
          ? dualRing()
          : products.length == 0
              ? noDataFoundMgs(context)
              : mainList(context),
      drawer: NavigationDrawer(
        userPhone: userPhone,
        users: users,
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.shopping_cart_rounded,
          color: Colors.white,
        ),
        backgroundColor: Colors.deepOrange,
        tooltip: "Cart List",
        splashColor: Colors.white,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CartList(
                        userPhone: userPhone,
                        userPoint: users[0]['point'],
                      )));
        },
      ),
    );
  }

  Widget noDataFoundMgs(BuildContext context) {
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

  Widget mainList(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    fetchProducts();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      color: Colors.grey[200],
      child: GridView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: size.width / 2, //200,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.7),
        itemBuilder: (context, index) => Card(
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductDetails(
                            userPhone: userPhone,
                            userPoint: users[0]['point'],
                            productId: products[index]['id'],
                            productName: products[index]['name'],
                            productImage: products[index]['image'],
                            productDesc: products[index]['description'],
                            productPoint: products[index]['price'],
                            productSize: products[index]['size'],
                          )));
            },
            splashColor: Colors.deepOrange[200],
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: Image.network(
                    products[index]['image'],
                    width: MediaQuery.of(context).size.width,
                    height: size.height / 7,
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Container(
                    child: ListTile(
                  contentPadding: EdgeInsets.all(5),
                  title: Text(
                    "${products[index]['name']}",
                    style: TextStyle(
                        color: Colors.grey[800], fontSize: size.width / 27),
                    maxLines: 3,
                  ),
                  subtitle: Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "${products[index]['price']} Coin",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.deepOrange,
                                fontSize: size.width / 21,
                              fontWeight: FontWeight.w500
                            ),
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
        //reverse: true,
        //scrollDirection: Axis.horizontal,
      ),
    );
  }
}

// ignore: must_be_immutable
class NavigationDrawer extends StatelessWidget {
  NavigationDrawer({this.userPhone, this.users});
  String userPhone;
  List users;

  @override
  Widget build(BuildContext context) {
    //fetchUser();
    return new Drawer(
      child: new Container(
        //padding: EdgeInsets.only(top: 30),
        color: Colors.grey[200],
        child: new ListView(
          //physics: ClampingScrollPhysics(),
          children: [
            new UserAccountsDrawerHeader(
              accountName: users[0]['name'] == null
                  ? Text(
                      "Your Name Here",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                          color: Colors.white),
                    )
                  : Text(
                      "${users[0]['name']}",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                          color: Colors.white),
                    ),
              accountEmail: Text(
                "Coin: ${users[0]['point']}",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.yellowAccent,
                    fontSize: 15),
              ),
              currentAccountPicture: CircleAvatar(
                child: Image.asset(
                  "assets/image/profile.png",
                  height: 60,
                  width: 60,
                ),
                backgroundColor: Colors.white,
              ),
            ),
            //SizedBox(height: 20,),

            ///Update Account...
            Card(
              elevation: 0,
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UpdateAccount(
                                userPhone: userPhone,
                                userName: users[0]['name'],
                                userPoint: users[0]['point'],
                                userAddress: users[0]['address'],
                              )));
                },
                leading: Icon(
                  Icons.person,
                  color: Colors.deepOrange,
                  size: 30,
                ),
                title: Text(
                  "Update Account",
                  style: TextStyle(color: Colors.grey[800], fontSize: 15),
                ),
                trailing: Icon(
                  Icons.arrow_right,
                  size: 30,
                  color: Colors.deepOrange[200],
                ),
              ),
            ),

            ///Search Product....
            Card(
              elevation: 0,
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Search(
                                userPhone: userPhone,
                              )));
                },
                leading: Icon(
                  Icons.search_rounded,
                  color: Colors.deepOrange,
                  size: 30,
                ),
                title: Text(
                  "Search Product",
                  style: TextStyle(color: Colors.grey[800], fontSize: 15),
                ),
                trailing: Icon(
                  Icons.arrow_right,
                  size: 30,
                  color: Colors.deepOrange[200],
                ),
              ),
            ),

            ///Filter....
            Card(
              elevation: 0,
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FilterProduct(
                            userPhone: userPhone,userPoint: users[0]['point'],
                          )));
                },
                leading: Icon(
                  Icons.filter_alt_rounded,
                  color: Colors.deepOrange,
                  size: 30,
                ),
                title: Text(
                  "Filter Product",
                  style: TextStyle(color: Colors.grey[800], fontSize: 15),
                ),
                trailing: Icon(
                  Icons.arrow_right,
                  size: 30,
                  color: Colors.deepOrange[200],
                ),
              ),
            ),

            ///Cart List....
            Card(
              elevation: 0,
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CartList(
                                userPhone: userPhone,
                                userPoint: users[0]['point'],
                              )));
                },
                leading: Icon(
                  Icons.shopping_cart_rounded,
                  color: Colors.deepOrange,
                  size: 30,
                ),
                title: Text(
                  "Cart List",
                  style: TextStyle(color: Colors.grey[800], fontSize: 15),
                ),
                trailing: Icon(
                  Icons.arrow_right,
                  size: 30,
                  color: Colors.deepOrange[200],
                ),
              ),
            ),

            ///Order List....
            Card(
              elevation: 0,
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OrderList(
                                userPhone: userPhone,
                              )));
                },
                leading: Icon(
                  Icons.playlist_add_check_rounded,
                  color: Colors.deepOrange,
                  size: 30,
                ),
                title: Text(
                  "Order List",
                  style: TextStyle(color: Colors.grey[800], fontSize: 15),
                ),
                trailing: Icon(
                  Icons.arrow_right,
                  size: 30,
                  color: Colors.deepOrange[200],
                ),
              ),
            ),

            ///Get Reward Coin...
            Card(
              elevation: 0,
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GetRewardPoint(
                                userPhone: userPhone,
                              )));
                },
                leading: Icon(
                  Icons.widgets_rounded,
                  color: Colors.deepOrange,
                  size: 30,
                ),
                title: Text(
                  "Get Free Coin",
                  style: TextStyle(color: Colors.grey[800], fontSize: 15),
                ),
                trailing: Icon(
                  Icons.arrow_right,
                  size: 30,
                  color: Colors.deepOrange[200],
                ),
              ),
            ),

            ///My Referral Code...
            Card(
              elevation: 0,
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyReferralCode(referralCode: users[0]['phone'],)));
                },
                leading: Icon(
                  Icons.link,
                  color: Colors.deepOrange,
                  size: 30,
                ),
                title: Text(
                  "My Referral Code",
                  style: TextStyle(color: Colors.grey[800], fontSize: 15),
                ),
                trailing: Icon(
                  Icons.arrow_right,
                  size: 30,
                  color: Colors.deepOrange[200],
                ),
              ),
            ),

            ///Verify Referral Code....
            users[0]['verify referral']=='false'?
            Card(
              elevation: 0,
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VerifyReferral(userPhone: userPhone,)));
                },
                leading: Icon(
                  Icons.link,
                  color: Colors.deepOrange,
                  size: 30,
                ),
                title: Text(
                  "Verify Referral Code",
                  style: TextStyle(color: Colors.grey[800], fontSize: 15),
                ),
                trailing: Icon(
                  Icons.arrow_right,
                  size: 30,
                  color: Colors.deepOrange[200],
                ),
              ),
            ): Container(),

            ///Contact with us...
            Card(
              elevation: 0,
              child: ListTile(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ContactUs()));
                },
                leading: Icon(
                  Icons.quick_contacts_dialer_outlined,
                  color: Colors.deepOrange,
                  size: 30,
                ),
                title: Text(
                  "Contact Us",
                  style: TextStyle(color: Colors.grey[800], fontSize: 15),
                ),
                trailing: Icon(
                  Icons.arrow_right,
                  size: 30,
                  color: Colors.deepOrange[200],
                ),
              ),
            ),

            ///Logout....
            Card(
              elevation: 0,
              child: ListTile(
                onTap: () async {
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  preferences.clear().then((value) {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => MyApp()),
                        (route) => false);
                  });
                },
                leading: Icon(
                  Icons.logout,
                  color: Colors.deepOrange,
                  size: 30,
                ),
                title: Text(
                  "Logout",
                  style: TextStyle(color: Colors.grey[800], fontSize: 15),
                ),
                trailing: Icon(
                  Icons.arrow_right,
                  size: 30,
                  color: Colors.deepOrange[200],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
