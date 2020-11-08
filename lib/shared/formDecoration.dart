import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


const textInputDecoration = InputDecoration(
    hintText: 'Phone Number',
    fillColor:Colors.black12,
    filled: true,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(50)),
        borderSide: BorderSide(
        color: Colors.transparent,
        width: 1.0,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(50)),
      borderSide: BorderSide(
        color: Colors.transparent,
        width: 1.0,
      ),
    ),
    errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(50)),
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 1.0,
        )),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(50)),
      borderSide: BorderSide(
        color: Colors.transparent,
        width: 1.0,
      ),
    ),
    prefixIcon: Icon(Icons.phone));

const updateDecoration = InputDecoration(
  hintText: 'Phone Number',
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
    //borderRadius: BorderRadius.all(Radius.circular(50)),
    borderSide: BorderSide(
      color: Colors.transparent,
      width: 1.0,
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.transparent,
      width: 1.0,
    ),
  ),
  errorBorder: OutlineInputBorder(
      borderSide: BorderSide(
    color: Colors.transparent,
    width: 1.0,
  )),
  focusedErrorBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.transparent,
      width: 1.0,
    ),
  ),
);

// dualRing(){
//   return Container(
//     alignment: Alignment.center,
//     child: SpinKitHourGlass(
//       color: Colors.deepOrange,
//       size: 40.0,
//     ),
//   );
// }

dualRing() {
  return Center(
    child: Container(
      color: Colors.transparent,
      child: Image.asset(
        "assets/gif/corki.gif",
        height: 50,
        width: 50,
      ),
    ),
  );
}

const modalDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(50.0),
    topRight: Radius.circular(50.0),
    bottomLeft: Radius.circular(50.0),
    bottomRight: Radius.circular(50.0),
  ),
);
