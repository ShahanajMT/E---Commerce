import 'dart:developer';

import 'package:ecommerce/core/constants.dart';
import 'package:ecommerce/screens/category_products.dart';
import 'package:ecommerce/screens/details_page.dart';
import 'package:ecommerce/webservice/webservices.dart';
import 'package:ecommerce/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          toolbarHeight: 60,
          elevation: 0,
          centerTitle: true,
          backgroundColor: mainColor,
          title: const Text(
            "E- COMMERCE",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        drawer: const DrawerWidget(),
        body: Container(
          //color: Colors.red,
          margin: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Category",
                style: TextStyle(
                    color: mainColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              FutureBuilder(
                future: WebSevices().fetchCategory(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      //color: const Color.fromARGB(255, 29, 12, 11),
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8),
                            child: InkWell(
                              onTap: () {
                                log("clicked");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CategoryProductPage(
                                      catid: snapshot.data![index].id,
                                      catname: snapshot.data![index].category,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                height: 30,
                                //width: 40,
                                //color: Colors.red,
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey[300],
                                ),
                                child: Center(
                                  child: Text(
                                    snapshot.data![index].category,
                                    style: const TextStyle(
                                        color: mainColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
              const Gap(20),
              const Text(
                "Most Search Products",
                style: TextStyle(
                    color: mainColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const Gap(20),

              //! viewProducts
              Expanded(
                child: FutureBuilder(
                  future: WebSevices().fetchProducts(),
                  builder: (context, snapshot) {
                    // log("Product legnth == ${snapshot.data!.length}");
                    if (snapshot.hasData) {
                      return Container(
                        child: StaggeredGridView.countBuilder(
                          scrollDirection: Axis.vertical,
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final product = snapshot.data![index];
                            log(product.image);
                            return InkWell(
                              onTap: () {
                                log("clicked");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return DetailsPage(
                                        id: product.id,
                                        name: product.productname,
                                        price: product.price,
                                        image:
                                            WebSevices.imageUrl + product.image,
                                        description: product.description,
                                      );
                                    },
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15),
                                        ),
                                        child: Container(
                                          constraints: const BoxConstraints(
                                              minHeight: 100, maxWidth: 250),
                                          child: Image(
                                            image: NetworkImage(
                                                WebSevices.imageUrl +
                                                    product.image),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          children: [
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                product.productname,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: Colors.grey.shade600,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "Rs. ${product.price}",
                                                style: const TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          staggeredTileBuilder: (context) =>
                              const StaggeredTile.fit(1),
                        ),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
