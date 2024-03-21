import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mehndiorderwithdetabase/api/apis.dart';
import 'package:mehndiorderwithdetabase/model/data.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class NewOrder extends StatefulWidget {
  const NewOrder({super.key, required this.onAddOrder});

  final void Function(MOrder order) onAddOrder;

  @override
  State<NewOrder> createState() => _NewOrderState();
}

class _NewOrderState extends State<NewOrder> {
  final _cityController = TextEditingController();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _advanceController = TextEditingController();
  DateTime? _selectedDate;
  final _priceController = TextEditingController();
  final _personController = TextEditingController();
  final _mobileController = TextEditingController();
  var _selectCategories = Categore.babyShower;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(2050),
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  Future<void> _submitOrderData() async {
    final enteredAdvanceAmount = double.tryParse(_advanceController
        .text); // tryParse("helo")=> null or tryparse(1.21)=>1.21
    final price = double.tryParse(_priceController.text);
    final mobileNo = double.tryParse(_mobileController.text);
    final person = double.tryParse(_personController.text);
    final advanceisinvalid =
        enteredAdvanceAmount == null || enteredAdvanceAmount < 0;
    final priceisinvalid = price == null || price <= 0;
    final personisinvalid = person == null || person <= 0;
    final mobileisinvalid = mobileNo == null;
    if (_nameController.text.trim().isEmpty ||
        _addressController.text.trim().isEmpty ||
        personisinvalid ||
        advanceisinvalid ||
        priceisinvalid ||
        mobileisinvalid ||
        _selectedDate == null) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text("Invalid input"),
                content: const Text(
                    "Please make sure a valid tittle , amount, date and category was entered"),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                      child: const Text("Okay"))
                ],
              ));
      return;
    }
    widget.onAddOrder(MOrder(
      address: _addressController.text,
      advance: enteredAdvanceAmount,
      date: _selectedDate!,
      name: _nameController.text,
      mobileno: mobileNo,
      price: price,
      category: _selectCategories,
      city: _cityController.text,
      totalPersons: person.toInt(),
      //totalPerson:totalperson
    ));
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order saved successfully')));

    Navigator.pop(context);
    // Add the following lines to save data to Firestore
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        await FirebaseFirestore.instance.collection('orders').add({
          'userId': currentUser.uid,
          'name': _nameController.text,
          'address': _addressController.text,
          'advance': enteredAdvanceAmount,
          'date': _selectedDate,
          'price': price,
          'mobileNo': mobileNo,
          'category': _selectCategories.toString(),
          // You might want to adjust how you store this data
          'city': _cityController.text,
          'totalPersons': person.toInt(),
        });
        // Clear the text controllers after saving the order
        _nameController.clear();
        _addressController.clear();
        _advanceController.clear();
        _priceController.clear();
        _mobileController.clear();
        _cityController.clear();
        _personController.clear();
        setState(() {
          _selectedDate = null;
          _selectCategories =
              Categore.babyShower; // Assuming you have a default category
        });
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save order: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 243, 228, 243),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.flutter_dash),
                        label: Text("Name")),
                  ),
                  box(),
                  TextField(
                    controller: _addressController,
                    maxLength: 100,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.location_city),
                        label: Text("address")),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _advanceController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixText: '\$',
                            label: Text("Advance"),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _priceController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              prefixText: '\$', label: Text("Price")),
                        ),
                      ),
                    ],
                  ),
                  box(),
                  IntlPhoneField(
                    controller: _mobileController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(label: Text("mobileNo")),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _cityController,
                          keyboardType: TextInputType.name,
                          maxLength: 15,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.location_city_rounded),
                              label: Text("City")),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: DropdownButton(
                          value: _selectCategories,
                          items: Categore
                              .values // enum no use karyo che atle .value lakhvu pade jo ana badle apne list lidhi hot to .value no lakhvu pade
                              .map(
                                (categore) => DropdownMenuItem(
                                  value: categore,
                                  child: Text(
                                    categore.name.toUpperCase(),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              _selectCategories = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _personController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              //prefixIcon: Icon(Icons.location_city_rounded),
                              label: Text("person")),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              onPressed: _presentDatePicker,
                              icon: const Icon(
                                Icons.calendar_month,
                              ),
                            ),
                            Text(
                              _selectedDate == null
                                  ? 'No date selected'
                                  : formatter.format(_selectedDate!),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  box(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: _submitOrderData,
                        child: const Text('Save Order'),
                      )
                    ],
                  ),
                ],
              )),
        ),
      ),
    );
  }
}

Widget box() {
  return const SizedBox(
    height: 25,
  );
}
