import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mehndiorderwithdetabase/model/data.dart';

class OrderCard extends StatelessWidget {
  final MOrder order;
  // Define a list of light colors
  static  List<Color> lightColors = [
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

  const OrderCard({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Generate a random color for each card
    // final random = Random();
    // final color = Color.fromARGB(
    //   255,
    //   random.nextInt(256),
    //   random.nextInt(256),
    //   random.nextInt(256),
    // );

    // Generate a random index to select a color from the list
    final random = Random();
    final color = lightColors[random.nextInt(lightColors.length)];

    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 17),
      // color: color.withOpacity(0.5),
      color: color, // Set the random light color of the card
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${order.name}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Address: ${order.address}'),
            SizedBox(height: 4),
            Text('City: ${order.city}'),
            SizedBox(height: 4),
            Text('Date: ${order.formattedDate}'),
            SizedBox(height: 4),
            Text('Mobile Number: ${order.mobileno}'),
            SizedBox(height: 4),
            Text('Price: \$${order.price}'),
            SizedBox(height: 4),
            Text('Advance: \$${order.advance}'),
            SizedBox(height: 4),
            Text('Category: ${order.category.displayName}'),
            SizedBox(height: 4),
            Text('Total Persons: ${order.totalPersons}'),
          ],
        ),
      ),
    );
  }
}
