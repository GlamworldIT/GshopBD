import 'package:flutter/material.dart';
import 'package:gshop/shared/AdmobService.dart';
import 'package:gshop/shared/DatabaseManager.dart';
import 'package:gshop/shared/formDecoration.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class OrderList extends StatefulWidget {
  String userPhone;

  OrderList({this.userPhone});

  @override
  _OrderListState createState() => _OrderListState(this.userPhone);
}

class _OrderListState extends State<OrderList> {
  _OrderListState(this.userPhone);

  String userPhone;
  List orderList = [];
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AdMobService.hideBannerAd();
    fetchOrder();
  }


  Future fetchOrder() async {
    dynamic result = await DatabaseManager().getOrderList(userPhone);
    setState(() {
      orderList = result;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Order List"),
        elevation: 0,
      ),
      body: isLoading
          ? dualRing()
          : orderList.length == 0
              ? noDataFoundMgs()
              : orderListBuilder(context),
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
            "Empty Order",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 20.0),
          ),
        ],
      ),
    );
  }

  Widget orderListBuilder(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    fetchOrder();
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: ListView.builder(
          itemCount: orderList.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.only(bottom: 5, top: 5),
              child: Column(
                children: [
                  ///Product Image....
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                      orderList[index]['product image'],
                      height: size.height/5.5,
                      fit: BoxFit.fitHeight,
                    ),
                  ),

                  ///Product Name....
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 10),
                    alignment: Alignment.topLeft,
                    child: Text(
                      orderList[index]['product name'],
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: size.width / 27,
                          color: Colors.grey[800]),
                    ),
                  ),

                  ///Product Quantity....
                  Container(
                    margin: EdgeInsets.only(top: 5, left: 10),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Quantity: ${orderList[index]['product quantity']}",
                      style: TextStyle(fontSize: size.width / 27, color: Colors.grey[700]),
                    ),
                  ),

                  ///Product Unit Point....
                  Container(
                    margin: EdgeInsets.only(top: 5, left: 10),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Unit Coin: ${orderList[index]['unit point']}",
                      style: TextStyle(fontSize: size.width / 27, color: Colors.grey[700]),
                    ),
                  ),

                  ///Total Point....
                  Container(
                    margin: EdgeInsets.only(top: 5, left: 10),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Total Coin: ${orderList[index]['total price']}",
                      style: TextStyle(fontSize: size.width / 27, color: Colors.grey[700]),
                    ),
                  ),

                  ///Product Size
                  orderList[index]['ordered size'] == null
                      ? Container()
                      : Container(
                          margin: EdgeInsets.only(top: 5, left: 10),
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Ordered size: ${orderList[index]['ordered size']}",
                            style: TextStyle(
                                fontSize: size.width / 27, color: Colors.grey[700]),
                          ),
                        ),

                  ///Ordered Time....
                  Container(
                    margin: EdgeInsets.only(top: 5, left: 10),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Order date: ${DateFormat("dd/MMM/yy - hh:mm:aa").format(DateTime.fromMillisecondsSinceEpoch(int.parse(orderList[index]['ordered date'])))}",
                      style: TextStyle(fontSize: size.width / 27, color: Colors.grey[700]),
                    ),
                  ),

                  ///Delivery Report....
                  Container(
                    margin: EdgeInsets.only(top: 5, left: 10),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Delivery Report: ${orderList[index]['delivery report']}",
                      style: TextStyle(
                          fontSize: size.width / 27, color: Colors.grey[700]),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            );
          }),
    );
  }
}
