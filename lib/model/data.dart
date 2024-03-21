import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

final formatter = DateFormat.yMd();

enum Categore { party, bride, sider, babyShower, engagement }
extension CategoreExtension on Categore {
  String get displayName {
    // Convert enum value to string and capitalize the first letter
    return this.toString().split('.').last.capitalizeFirstLetter();
  }
}

extension StringExtension on String {
  String capitalizeFirstLetter() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
const uuid = Uuid();
class MOrder {
  MOrder({
    //required this.id,
    required this.address,
    required this.advance,
    required this.date,
    required this.name,
    required this.mobileno,
    required this.price,
    required this.category,
    required this.city,
    required this.totalPersons,
  });

  //final String id; // Add id field
  final String address;
  final String name;
  final String city;
  final double mobileno;
  final double price;
  final double advance;
  final DateTime date;
  final Categore category;
  final int totalPersons;

  String get formattedDate {
    return formatter.format(date);
  }

  Map<String, dynamic> toJson() {
    return {
     // 'id': id, // Include id in JSON representation
      'address': address,
      'name': name,
      'city': city,
      'mobileno': mobileno,
      'price': price,
      'advance': advance,
      'date': date.toIso8601String(),
      'category': category.index,
      'totalPersons': totalPersons,
    };
  }

  factory MOrder.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MOrder(
     // id: doc.id, // Assign Firestore document id to id field
      name: data['name'] ?? '',
      address: data['address'] ?? '',
      advance: (data['advance'] ?? 0).toDouble(),
      date: (data['date'] as Timestamp).toDate(),
      mobileno: data['mobileNo'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      category: Categore.values.firstWhere(
            (element) => element.toString() == data['category'],
        orElse: () => Categore.babyShower,
      ),
      city: data['city'] ?? '',
      totalPersons: data['totalPersons'] ?? 0,
    );
  }
}
  // factory MOrder.fromJson(Map<String, dynamic> json) {
  //   return MOrder(
  //     address: json['address'],
  //     name: json['name'],
  //     city: json['city'],
  //     mobileno: json['mobileno'],
  //     price: json['price'],
  //     advance: json['advance'],
  //     date: DateTime.parse(json['date']),
  //     category: Categore.values[json['category']],
  //     totalPersons: json['totalPersons']?.toInt() ?? 0,
  //   );
  // }

  // factory MOrder.fromFirestore(DocumentSnapshot doc) {
  //   final data = doc.data() as Map<String, dynamic>;
  //   return MOrder(
  //     name: data['name'] ?? '',
  //     address: data['address'] ?? '',
  //     advance: (data['advance'] ?? 0).toDouble(),
  //     date: (data['date'] as Timestamp).toDate(),
  //     mobileno: data['mobileNo'] ?? '',
  //     price: (data['price'] ?? 0).toDouble(),
  //     category: Categore.values.firstWhere(
  //           (element) => element.toString() == data['category'],
  //       orElse: () => Categore.babyShower,
  //     ),
  //     city: data['city'] ?? '',
  //     totalPersons: data['totalPersons'] ?? 0,
  //   );
  // }

