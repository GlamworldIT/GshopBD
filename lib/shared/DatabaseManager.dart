import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseManager {
  final CollectionReference users = Firestore.instance.collection("Users");

  final CollectionReference searchProducts =
      Firestore.instance.collection("Products");

  Future getUsers(String searchQuery) async {
    List userList = [];
    try {
      await users
          .where("phone", isEqualTo: searchQuery)
          .getDocuments()
          .then((querySnapshot) {
        querySnapshot.documents.forEach((element) {
          userList.add(element.data);
        });
      });
      return userList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future getSearchedProducts(String searchQuery) async {
    List searchList = [];
    try {
      await searchProducts
          .where("name", isGreaterThanOrEqualTo: searchQuery)
          .getDocuments()
          .then((querySnapshot) {
        querySnapshot.documents.forEach((element) {
          searchList.add(element.data);
        });
      });
      return searchList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  ///.where('available stock', isGreaterThan: '')
  ///.limit(10)
  Future getProducts() async {
    List searchList = [];
    try {
      await searchProducts
          .where('available stock', isGreaterThan: '')
          .getDocuments()
          .then((querySnapshot) {
        querySnapshot.documents.forEach((element) {
          searchList.add(element.data);
        });
      });
      return searchList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future getCartList(String phoneNumber) async {
    final CollectionReference cartProducts =
        Firestore.instance.collection(phoneNumber);

    List cartList = [];
    try {
      await cartProducts
          .where("state", isEqualTo: 'carted')
          .getDocuments()
          .then((querySnapshot) {
        querySnapshot.documents.forEach((element) {
          cartList.add(element.data);
        });
      });
      return cartList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future getOrderList(String phoneNumber) async {
    final CollectionReference orderedProducts =
        Firestore.instance.collection(phoneNumber);

    List cartList = [];
    try {
      await orderedProducts
          .where("state", isEqualTo: 'ordered')
          .getDocuments()
          .then((querySnapshot) {
        querySnapshot.documents.forEach((element) {
          cartList.add(element.data);
        });
      });
      return cartList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
