import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gshop/shared/AdmobService.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AdMobService.showHomeBannerAd();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    AdMobService.hideBannerAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Contact US"),
        elevation: 0,
      ),
      
      body: bodyUI(context),
    );
  }

  bodyUI(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.orange[100],
          ),
          margin: EdgeInsets.symmetric(horizontal: size.height / 30),
          padding: EdgeInsets.symmetric(horizontal: size.height / 30),
          height: size.height / 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Container(
                child: Text(
                  "Contact Us By Following",
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                    fontSize: size.height/35,
                  ),
                ),
              ),
              Divider(color: Colors.orange,thickness: 1,),
              SizedBox(height: size.height/20),

              Container(
                //padding: EdgeInsets.only(left: size.width/43),
                alignment: Alignment.topLeft,
                child: Text(
                  "Hot Line:",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                    fontSize: size.height/50,
                  ),
                ),
              ),
              Container(
                //padding: EdgeInsets.only(left: size.width/43),
                alignment: Alignment.topLeft,
                child: Text(
                  "+8801830200087",
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.w500,
                    fontSize: size.height/40,
                  ),
                ),
              ),
              SizedBox(height: size.height/50),

              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  "Email:",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                    fontSize: size.height/50,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  "support@glamworlditltd.com",
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.w500,
                    fontSize: size.height/40,
                  ),
                ),
              ),
              SizedBox(height: size.height/50),

              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  "Website:",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                    fontSize: size.height/50,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  "www.glamworlditltd.com",
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.w500,
                    fontSize: size.height/40,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

