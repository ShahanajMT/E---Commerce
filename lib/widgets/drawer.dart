import 'package:ecommerce/core/constants.dart';
import 'package:ecommerce/screens/cartPage.dart';
import 'package:ecommerce/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(
              height: 50,
            ),
            const Text(
              "E COMMERCE",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: mainColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Divider(
              color: Colors.grey.shade200,
            ),
            const SizedBox(
              height: 20,
            ),

            const ListTile(
              leading:  Icon(Icons.home),
              title: Text("Home", style: TextStyle(fontSize: 17),),
              trailing: Icon(Icons.arrow_forward_ios_rounded, size: 15,),
            ),

            const ListTile(
              leading:  Icon(Icons.book_online),
              title: Text("Order Details", style: TextStyle(fontSize: 17),),
              trailing: Icon(Icons.arrow_forward_ios_rounded, size: 15,),
            ),

            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CartPage()));
              },
              child: const ListTile(
                leading:  Icon(Icons.local_grocery_store),
                title: Text("Cart", style: TextStyle(fontSize: 17),),
                trailing: Icon(Icons.arrow_forward_ios_rounded, size: 15,),
              ),
            ),

            const Divider(),
             ListTile(
              leading:  const Icon(Icons.exit_to_app),
              title: const Text("LogOut", style: TextStyle(fontSize: 17),),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 15,),
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();

                prefs.setBool("isLoggedIn", false);
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
