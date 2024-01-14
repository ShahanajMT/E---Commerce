import 'dart:developer';

import 'package:ecommerce/webservice/webservices.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderDetailsPage extends StatefulWidget {
  const OrderDetailsPage({super.key});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  String? username;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUsername();
  }

  void _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      username = prefs.getString('username');
    });

    log('!!!!!!!!');
    log('isLoggedIn $username');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
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
            'Order Details',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
        body: FutureBuilder(
          future: WebSevices().fetchOrderDeatils(username.toString()),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {

                log(snapshot.data!.length.toString());
                final order_details = snapshot.data![index];
                log(order_details.toString());
                
                //log(order_details as String);
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Card(
                    elevation: 0,
                    color: Colors.grey.shade200,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ExpansionTile(
                      trailing: const Icon(Icons.arrow_drop_down),
                      textColor: Colors.black,
                      collapsedTextColor: Colors.black,
                      iconColor: Colors.red,
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            
                           DateFormat.yMMMEd().format(order_details.date),
                            //'12 - 03 - 2024',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            //'Online',
                             order_details.paymentmethod.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.green,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          const Gap(20),
                          Text(
                             //'20000'+'/-',
                             '${order_details.totalamount} /-',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.red,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      children: [
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(top: 25),
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(
                              height: 10,
                            );
                          },
                          itemCount: order_details.products.length,
                          itemBuilder: (context, index) {
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: SizedBox(
                                height: 100,
                                child: Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.all(10),
                                      height: 80,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.red,
                                        image:  DecorationImage(
                                          image: NetworkImage(
                                            WebSevices.imageUrl + order_details.products[index].image
                                            //'https://imgs.search.brave.com/aJZ9L2gKWhQSFk1eoRJ77386Z90GKSUaIqmMiAGyIDQ/rs:fit:860:0:0/g:ce/aHR0cHM6Ly9pbWFn/ZXMudW5zcGxhc2gu/Y29tL3Bob3RvLTE2/MjQ5MTM1MDMyNzMt/NWY5YzRlOTgwZGJh/P3E9ODAmdz0xMDAw/JmF1dG89Zm9ybWF0/JmZpdD1jcm9wJml4/bGliPXJiLTQuMC4z/Jml4aWQ9TTN3eE1q/QTNmREI4TUh4elpX/RnlZMmg4Tm54OFky/RnRaWEpoYzN4bGJu/d3dmSHd3Zkh4OE1B/PT0',
                                          ),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Wrap(
                                          children: [
                                            Text(
                                              order_details.products[index].productname,
                                              //'Productname',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style:  TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                            
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                
                                                Text(
                                                  order_details.products[index].price.toString(),
                                                  // '2000',
                                                  
                                                  style:  TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red[700],
                                                  ),
                                                ),

                                                Text(
                                                  '${order_details.products[index].quantity}x',
                                                  // '2' + 'x',
                                                  
                                                  style:  TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.green[700],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
            
            } else {

            }
            return const Center(child: CircularProgressIndicator(),);
          },
          
        ),
      ),
    );
  }
}
