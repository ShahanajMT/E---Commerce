// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';

import 'package:ecommerce/screens/homePage.dart';
import 'package:flutter/material.dart';

import 'package:ecommerce/provider/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'package:http/http.dart' as http;
import '../webservice/webservices.dart';
import 'package:fluttertoast/fluttertoast.dart';

// ignore: must_be_immutable
class PaymentScreen extends StatefulWidget {
  List<CartProduct> cart;
  String amount;
  String paymentmethod;
  String date;
  String name;
  String address;
  String phone;

  PaymentScreen({
    Key? key,
    required this.cart,
    required this.amount,
    required this.paymentmethod,
    required this.date,
    required this.name,
    required this.address,
    required this.phone,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Razorpay? razorpay;
  String? paymentmethod = 'Cash on delivery';
  TextEditingController textEditingController = TextEditingController();

  //! initialize
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUsername();
    razorpay = Razorpay();
    razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    //razorpay!.on(event, handler)
    flutterpayment('payment', 10);
  }

  //! dipose
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    razorpay!.clear();
  }

  //! to get username

  String? username;
  void _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      username = prefs.getString('username');
    });

    log('isLoggedIn $username');
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
      Uri.parse('${WebSevices.mainUrl}order.php'),
      body: {
        'username': username,
        'amount': amount,
        'paymentmethod': paymentmethod,
        'date': date,
        'quantity': vm.count.toString(),
        'cart': jsondata,
        'name': name,
        'address': address,
        'phone': phone,
      },
    );

    try {
      if (response.statusCode == 200) {
        log('00000000');
        log(response.body);
        log('1010101');
        if (response.body.contains('Success')) {
          log('1111111');
          vm.clearCart();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
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
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void flutterpayment(String orderId, int t) {
    var options = {
      "key": "rzp_test_hK5pjpV6NRQzdi",
      "amount": t * 10,
      'name': 'Shanu',
      'currency': 'INR',
      'description': 'maligai',
      'external': {
        'walets': ['paytm']
      },
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      "prefill": {
        "contact": "9061252930",
        "email": "mhmmdshahanaj3123@gmail.com"
      },
    };
    try {
      razorpay!.open(options);
    } catch (e) {
      debugPrint('Error : e');
    }
  }

  //! Success
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    response.orderId;

    sucessmethod(response.paymentId.toString());

    // Fluttertoast.showToast(msg: 'SUCCSESS${response.paymentId!}', toastLength: Toast.LENGTH_SHORT);
    
  }

  //! Error
  void _handlePaymentError(PaymentFailureResponse response) {
    log("Errors : ${response.message}");
    // ignore: prefer_interpolation_to_compose_strings
    //Fluttertoast.showToast(msg: 'ERROR' + response.code.toString() + " - " + response.message!, toastLength: Toast.LENGTH_SHORT);
  }

  //! External Walet
  void _handleExternalWallet(ExternalWalletResponse response) {
    log("Wallet");
    //Fluttertoast.showToast(msg: 'EXTERNAL WALLET${response.walletName!}', toastLength: Toast.LENGTH_SHORT);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(),
    );
  }

  void sucessmethod(String paymentid) {
    orderplace(widget.cart, widget.amount.toString(), widget.paymentmethod,
        widget.date, widget.name, widget.address, widget.phone);
  }
}
