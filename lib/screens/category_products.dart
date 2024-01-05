// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:ecommerce/screens/details_page.dart';
import 'package:ecommerce/webservice/webservices.dart';
import 'package:flutter/material.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

// ignore: must_be_immutable
class CategoryProductPage extends StatefulWidget {
  //! co
  String catname;
  int catid;
  CategoryProductPage({
    Key? key,
    required this.catname,
    required this.catid,
  }) : super(key: key);

  @override
  State<CategoryProductPage> createState() => _CategoryProductPageState();
}

class _CategoryProductPageState extends State<CategoryProductPage> {
  @override
  Widget build(BuildContext context) {
    log('CatId : ${widget.catid.toString()}');
    log('Catname : ${widget.catname.toString()}');
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey.shade100,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
        title: Text(
          widget.catname,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: FutureBuilder(
        future: WebSevices().fetchCatProducts(widget.catid),
        builder: (context, snapshot) {
          log("length :${snapshot.data!.length}");

          if (snapshot.connectionState == ConnectionState.waiting) {
            // Loading state
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            // Error state
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data != null) {
            // Data available state
            log("length: ${snapshot.data!.length}");

            return StaggeredGridView.countBuilder(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                //!
                final product = snapshot.data![index];
                return InkWell(
                  onTap: () {
                    log("clicked");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return DetailsPage(id: product.id, name: product.productname, price: product.price, image: WebSevices.imageUrl + product.image, description: product.description);
                        },
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                            child: Container(
                              constraints: const BoxConstraints(
                                  minHeight: 100, maxHeight: 250),
                              child: Image(
                                image: NetworkImage(
                                  WebSevices.imageUrl + product.image,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    textAlign: TextAlign.start,
                                    product.productname,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
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
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
              staggeredTileBuilder: (context) => const StaggeredTile.fit(1),
            );
          } else {
            // No data state
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
