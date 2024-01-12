// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:ecommerce/screens/homePage.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../provider/cart_provider.dart';
import 'cartPage.dart';

// ignore: must_be_immutable
class DetailsPage extends StatelessWidget {
  int id;
  String name;
  double price;
  String image;
  String description;
  DetailsPage({
    Key? key,
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.width * 0.7,
                    width: MediaQuery.of(context).size.height,
                    //color: Colors.red,
                    child: Image(image: NetworkImage(image)),
                  ),
                  //Gap(200),
                  Positioned(
                    left: 15,
                    top: 20,
                    child: CircleAvatar(
                      backgroundColor: Colors.grey.withOpacity(0.5),
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()));
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    margin: const EdgeInsets.only(
                        top: 270, left: 10, right: 10, bottom: 0),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                      color: Colors.grey.shade200,
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 10,
                            ),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                name,
                                style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              // ignore: prefer_interpolation_to_compose_strings
                              'Rs. ' + price.toString(),
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Flexible(
                            child: Text(
                              description,
                              textAlign: TextAlign.justify,
                              textScaleFactor: 1.1,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const Gap(50),
                          InkWell(
                            onTap: () {
                              //log('Price : ${double.parse(price as String)}');
                              // ignore: prefer_interpolation_to_compose_strings
                              log('Price' + price.toString());
                              var existingItemCart = context
                                  .read<Cart>()
                                  .getItems
                                  .firstWhereOrNull(
                                      (element) => element.id == id);
                              log('existingItemCart -----$existingItemCart');
                              if (existingItemCart != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    duration: Duration(seconds: 3),
                                    behavior: SnackBarBehavior.floating,
                                    padding: EdgeInsets.all(15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    content: Text(
                                      'This item already in cart',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                context
                                    .read<Cart>()
                                    .addItem(id, name, price, 1, image);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    duration: Duration(seconds: 3),
                                    behavior: SnackBarBehavior.floating,
                                    padding: EdgeInsets.all(15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    content: Text(
                                      'Added to cart !!!',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.indigo),
                              child: const Center(
                                child: Text(
                                  'Add to cart',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
