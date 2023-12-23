import 'dart:convert';
import 'dart:developer';

import 'package:ecommerce/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  String? name, phone, address, username, password;
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //! DB
  registration(String name, phone, address, username, password) async {
    print("Webservices");
    print(username);
    print(password);
    var result;

    final Map<String, dynamic> loginData = {
      'name': name,
      'phone': phone,
      'address': address,
      'username': username,
      'password': password,
    };

    final response = await http.post(
      Uri.parse("http://bootcamp.cyralearnings.com/registration.php"),
      body: loginData,
    );

    print(response.statusCode);
    if (response.statusCode == 200) {
      if (response.body.contains("success")) {
        print("registration successfully completed");

        Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
      } else {
        print("registration Failed");
      }
    } else {
      result = {log(json.decode(response.body)['error'].toString())};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 130,
            ),
            const Text(
              "Register Account",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Please complete your details",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 17,
                  fontWeight: FontWeight.w300),
            ),
            const SizedBox(
              height: 50,
            ),
            //! name
            Form(
              key: _formKey,
              child: Column(
                children: [
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
                                hintText: "Name"),
                            onChanged: (text) {
                              setState(() {
                                name = text;
                              });
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter your name";
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //! phoneNo.
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
                      decoration:
                          const InputDecoration.collapsed(hintText: "Phone"),
                      onChanged: (text) {
                        setState(() {
                          phone = text;
                        });
                      },
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter your MobileNo.";
                        } else if (value.length > 10 || value.length < 10) {
                          return "Please enter valid mobile no.";
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),

            //! Address

            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                height: 100,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Center(
                    child: TextFormField(
                      maxLines: 4,
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                      decoration: const InputDecoration.collapsed(
                        hintText: "Address",
                        //filled: true,
                        //floatingLabelAlignment: FloatingLabelAlignment.center
                      ),
                      onChanged: (text) {
                        setState(() {
                          address = text;
                        });
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter your Address.";
                        }
                      },
                    ),
                  ),
                ),
              ),
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
                      decoration:
                          const InputDecoration.collapsed(hintText: "Username"),
                      onChanged: (text) {
                        setState(() {
                          username = text;
                        });
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter your Username.";
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
                      decoration:
                          const InputDecoration.collapsed(hintText: "Password"),
                      onChanged: (text) {
                        setState(() {
                          password = text;
                        });
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter your Password.";
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
                      color: Colors.red,
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
                            
                            log("Name = " + name.toString());
                            log("Phone = " + phone.toString());
                            log("Address = " + address.toString());
                            log("Username = " + username.toString());
                            log("Password = " + password.toString());
                            registration(name!, phone, address, username, password);
                          }
                        },
                        style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white),
                        child: const Text(
                          "Register",
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
                  "Already have an account? ",
                  style: TextStyle(fontSize: 15),
                ),
                InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()));
                    },
                    child: const Text(
                      "Login here",
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
    );
  }
}
