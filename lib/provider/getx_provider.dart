import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mehndiorderwithdetabase/model/data.dart';

class OrderController extends GetxController {
  late RxList<MOrder> registeredOrder;
  late RxList<MOrder> filteredOrders;
  late RxString searchQuery;
  @override
  void onInit() {
    super.onInit();
    registeredOrder = <MOrder>[].obs;
    filteredOrders = <MOrder>[].obs;
    searchQuery = ''.obs;
    fetchOrders();
  }
  void fetchOrders() {
    FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .snapshots()
        .listen((snapshot) {
      registeredOrder.assignAll(snapshot.docs
          .map((doc) => MOrder.fromFirestore(doc))
          .toList());
      filteredOrders.assignAll(registeredOrder);
    });
  }
  void addOrder(MOrder order) {
    registeredOrder.add(order);
    if (isMatchSearchQuery(order)) {
      filteredOrders.add(order);
    }
  }

  void removeOrder(MOrder mOrder) async {
    filteredOrders.remove(mOrder);
    Get.snackbar(
      "Order deleted",
      "",
      duration: Duration(seconds: 3),
      snackPosition: SnackPosition.BOTTOM,
      mainButton: TextButton(
        onPressed: () {
          filteredOrders.add(mOrder);
          Get.back();
        },
        child: Text("Undo"),
      ),
    );
  }

  bool isMatchSearchQuery(MOrder order) {
    final searchQueryLower = searchQuery.value.toLowerCase();
    final formattedDateString =
        '${order.date.month}/${order.date.day}/${order.date.year}';
    final dateOnlyString =
    order.date.toLocal().toString().split(' ')[0].toLowerCase();
    return order.name.toLowerCase().contains(searchQueryLower) ||
        order.address.toLowerCase().contains(searchQueryLower) ||
        formattedDateString.contains(searchQueryLower) ||
        dateOnlyString.contains(searchQueryLower);
  }

  void searchOrder(String query) {
    searchQuery.value = query;
    filteredOrders.assignAll(registeredOrder
        .where((order) => isMatchSearchQuery(order))
        .toList());
  }
  // Define a list of light colors
  static List<Color> lightColors = [
    Colors.blue[100]!,
    Colors.green[100]!,
    Colors.orange[100]!,
    Colors.pink[100]!,
    Colors.purple[100]!,
    Colors.red[100]!,
    Colors.yellow[100]!,
    Colors.teal[100]!,
    Colors.cyan[100]!,
    Colors.indigo[100]!,
    Colors.lime[100]!,
    Colors.amber[100]!,
    Colors.deepOrange[100]!,
    Colors.lightGreen[100]!,
    Colors.deepPurple[100]!,
    Colors.lightBlue[100]!,
    Colors.cyanAccent[100]!,
    Colors.deepOrangeAccent[100]!,
    Colors.greenAccent[100]!,
    Colors.redAccent[100]!,
  ];

  // Generate a random color from the list
  Color getRandomColor() {
    final random = Random();
    return lightColors[random.nextInt(lightColors.length)];
  }
}



