import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mehndiorderwithdetabase/model/data.dart';
import 'package:mehndiorderwithdetabase/provider/getx_provider.dart';
import 'package:mehndiorderwithdetabase/screen/new_order.dart';
import 'package:mehndiorderwithdetabase/widget/order_card.dart';
//
// class OrderScreen extends StatefulWidget {
//   const OrderScreen({super.key});
//
//   @override
//   State<OrderScreen> createState() => _OrderScreenState();
// }
//
// class _OrderScreenState extends State<OrderScreen> {
//   void addorder(MOrder order) {
//     setState(() {
//       _registeredOrder.add(order);
//     });
//   }
//
//   void _removeOrder(MOrder mOrder) async {
//     final orderIndex = _registeredOrder.indexOf(mOrder);
//     setState(() {
//       _registeredOrder.removeAt(orderIndex);
//     });
//
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text("Order deleted"),
//       duration: Duration(seconds: 3),
//       // action: SnackBarAction(
//       //   label: "Undo",
//       //   onPressed: () {
//       //     setState(() {
//       //       _registeredOrder.insert(orderIndex, mOrder);
//       //     });
//       //   },
//       // ),
//     ));
//   }
//
//   void openAddOrder() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       useSafeArea: true,
//       builder: (context) {
//         return NewOrder(onAddOrder: addorder);
//       },
//     );
//   }
//
//   void signout() {
//     FirebaseAuth.instance.signOut();
//   }
//
//   List<MOrder> _registeredOrder = [];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(centerTitle: true,
//         backgroundColor: Color(0xff430A5D),
//         title: Text("Orders",style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),),
//         actions: [
//           IconButton(
//             onPressed: () => Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => NewOrder(onAddOrder: addorder)),
//             ),
//             icon: Icon(Icons.add,color: Colors.green,),
//           ),
//           IconButton(
//             onPressed: signout,
//             icon: Icon(Icons.logout,color: Colors.red,),
//           ),
//         ],
//       ),backgroundColor: Color(0xffFFE6E6),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('orders')
//             .where('userId',
//                 isEqualTo: FirebaseAuth.instance.currentUser
//                     ?.uid) // Filter orders by current user ID
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//           final List<DocumentSnapshot> documents = snapshot.data!.docs;
//           if (documents.isEmpty) {
//             return Center(child: Text('No orders found.'));
//           }
//           return ListView.builder(
//             itemCount: documents.length,
//             itemBuilder: (context, index) {
//               final order = MOrder.fromFirestore(documents[index]);
//               return Dismissible(
//                 key: Key(documents[index].id), // Unique key for each order
//                 onDismissed: (direction) {
//                   _removeOrder(order);
//                   // Remove order document from Firestore
//                   FirebaseFirestore.instance
//                       .collection('orders')
//                       .doc(documents[index].id)
//                       .delete();
//                 },
//                 background: Container(
//                   color: Colors.red,
//                   alignment: Alignment.centerRight,
//                   padding: EdgeInsets.symmetric(horizontal: 20),
//                   child: Icon(Icons.delete, color: Colors.white),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: OrderCard(order: order),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
//
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mehndiorderwithdetabase/model/data.dart';
import 'package:mehndiorderwithdetabase/screen/new_order.dart';
import 'package:mehndiorderwithdetabase/widget/order_card.dart';

class OrderScreen extends StatelessWidget {
  OrderScreen({Key? key}) : super(key: key);
  OrderController _orderController = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    log("build");
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(0xff430A5D),
          title: Text(
            "Orders",
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewOrder(onAddOrder: _orderController.addOrder),
                ),
              ),
              icon: Icon(Icons.add, color: Colors.green),
            ),
            IconButton(
              onPressed: () => FirebaseAuth.instance.signOut(),
              icon: Icon(Icons.logout, color: Colors.red),
            ),
          ],
        ),
        backgroundColor: Color(0xffFFE6E6),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: _orderController.searchOrder,
                decoration: InputDecoration(
                  labelText: 'Search Order',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: _orderController.filteredOrders.length,
                  itemBuilder: (context, index) {
                    final order = _orderController.filteredOrders[index];
                    return Dismissible(
                      key: Key(index.toString()),
                      onDismissed: (direction) {
                        _orderController.removeOrder(order);
                      },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OrderCard(order: order),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
