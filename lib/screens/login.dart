import 'dart:convert';
import 'dart:developer';

import 'package:ecommerce/screens/homePage.dart';
import 'package:ecommerce/screens/register.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? username, password;
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadCounter();
  }

  //! to StoreLocally
  void _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    log("isLoggedIn = " + isLoggedIn.toString());
    if (isLoggedIn) {
       Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
    }
  }

  //!login fn

  logIn(String username, String password) async {
    print("webservices");
    print(username);
    print(password);
    var result;
    final Map<String, dynamic> loginData = {
      'username': username,
      'password': password,
    };

    final response = await http.post(
      Uri.parse("http://bootcamp.cyralearnings.com/login.php"),
      body: loginData,
    );

    print(response.statusCode);
    if (response.statusCode == 200) {
      if (response.body.contains("success")) {
        print("Login successfully completed");

        // Update the isLoggedIn status in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool("isLoggedIn", true);
        prefs.setString("username", username);

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      } else {
        print("login failed");
      }
    } else {
      result = {log(json.decode(response.body)['error'].toString())};
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 200,
              ),
              const Text(
                "Welcome Back!",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              ),
              const Text(
                "Login with your username and password",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 17,
                    fontWeight: FontWeight.w300),
              ),
              const SizedBox(
                height: 50,
              ),
              //! username
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Center(
                      child: TextFormField(
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                        decoration: const InputDecoration.collapsed(
                            hintText: "Username"),
                        onChanged: (text) {
                          setState(() {
                            username = text;
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter your username";
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
              //! password
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Center(
                      child: TextFormField(
                        obscureText: true,
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                        decoration: const InputDecoration.collapsed(
                            hintText: "Password"),
                        onChanged: (text) {
                          setState(() {
                            password = text;
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter your password";
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              //! login Buttom
              _isLoading == true
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        height: 50,
                        //color: Colors.red,
                        child: TextButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              log("Username = " + username.toString());
                              log("Password = " + password.toString());
                              logIn(username.toString(), password.toString());
                            }
                          },
                          style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white),
                          child: const Text(
                            "Login",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
              const SizedBox(
                height: 40,
              ),
              //! Register
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(fontSize: 15),
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const RegistrationPage()));
                      },
                      child: const Text(
                        "Register here",
                        style: TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
