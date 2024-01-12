// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';


import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ecommerce/screens/homePage.dart';
import 'package:ecommerce/webservice/webservices.dart';

import '../provider/cart_provider.dart';

// ignore: must_be_immutable
class CheckOutPage extends StatefulWidget {
  List<CartProduct> cart;
   CheckOutPage({
    Key? key,
    required this.cart,
  }) : super(key: key);
  
  //List<CartProduct> get cart => null;

  

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  
  int selectedValue = 1;
  String? name;
  String? phone;
  String? address;
  String? paymentmethod = 'Cash on delivery';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // to get the user details
    _loadUsername();
  }

  String? username;
  void _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      username = prefs.getString('username');
    });

    log('isLoggedIn$username');
  }

  //! orderPlace details with user
  orderplace(
    List<CartProduct> cart,
    String? amount,
    String? paymentMethod,
    String? date,
    String? name,
    String? address,
    String? phone,
  ) async {
    String jsondata = jsonEncode(cart);
    log('jsonData $jsondata');

    final vm = Provider.of<Cart>(context, listen: false);

    final response = await http.post(
      Uri.parse('${WebSevices.mainUrl}get_orderdetails.php'),
      body: {
        'username': username,
        'amount': amount,
        'paymentmethod': paymentmethod,
        'date': date,
        'quantity': vm.count.toString(),
        'cart': cart,
        'name': name,
        'address': address,
        'phone': phone,
      },
    );

    if (response.statusCode == 200) {
      log(response.body);
      if (response.body.contains("Success")) {
        vm.clearCart();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: const Text(
              'YOUR ORDER SUCCESSFULLY COMPLETED',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
          
        );
        // ignore: use_build_context_synchronously
        Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<Cart>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.grey.shade100,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          title: const Text(
            'CheckOut',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder(
                  future: WebSevices().fetchUser(username.toString()),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      name = snapshot.data!.name;
                      phone = snapshot.data!.phone;
                      address = snapshot.data!.address;

                      return Card(
                        // color: Colors.red,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'Name : ',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    name.toString(),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const Gap(10),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'Phone No. : ',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    phone.toString(),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const Gap(10),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'Address : ',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    //color: Colors.yellow,
                                    width:
                                        MediaQuery.of(context).size.width / 1.5,
                                    child: Text(
                                      address.toString(),
                                      overflow: TextOverflow.clip,
                                      maxLines: 8,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  const Gap(10),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
              const Gap(20),
              RadioListTile(
                activeColor: Colors.blue,
                value: 1,
                groupValue: selectedValue,
                onChanged: (int? value) {
                  setState(
                    () {
                      selectedValue = value!;
                      paymentmethod = 'Cash on deleivery';
                    },
                  );
                },
                title: const Text(
                  'Cash On Delivery',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                subtitle: const Text('Pay cash at home'),
              ),
              Gap(14),
              RadioListTile(
                activeColor: Colors.blue,
                value: 2,
                groupValue: selectedValue,
                onChanged: (int? value) {
                  setState(
                    () {
                      selectedValue = value!;
                      paymentmethod = 'Online';
                    },
                  );
                },
                title: const Text(
                  'Pay Now',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                subtitle: const Text('Online Payment'),
              ),
            ],
          ),
        ),
        bottomSheet: Padding(
          padding: const EdgeInsets.all(8),
          child: InkWell(
            onTap: () {
              String datetime = DateTime.now().toString();
              log(datetime.toString());
               orderplace(widget.cart, vm.totalPrice.toString(), paymentmethod, datetime, name, address, phone);
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.circular(15)),
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: const Center(
                child: Text(
                  'CheckOut',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
          ),
        ));
  }
}
