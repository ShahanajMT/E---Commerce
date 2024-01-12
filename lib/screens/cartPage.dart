import 'package:ecommerce/provider/cart_provider.dart';
import 'package:ecommerce/screens/checkoutPage.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    //! tostore
    List<CartProduct> cartList = [];
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
              size: 20,
            ),
          ),
          title: const Text(
            'Cart',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 23,
            ),
          ),
          actions: [
            context.watch<Cart>().getItems.isEmpty
                ? const SizedBox()
                : IconButton(
                    onPressed: () {
                      context.read<Cart>().clearCart();
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 30,
                    ),
                  ),
          ],
        ),
        body: context.watch<Cart>().getItems.isEmpty
            ? const Center(
                child: Text('Cart Is Empty'),
              )
            : Consumer<Cart>(
                builder: (context, cart, child) {
                  cartList = cart.getItems;
                  print(cartList);
                  return Container(
                    margin: const EdgeInsets.all(10),
                    child: ListView.builder(
                      itemCount: cart.count,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Container(
                            height: 120,
                            // color: Colors.yellow,
                            child: Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(10),
                                  //color: Colors.black,
                                  height: 80,
                                  width: 100,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          cartList[index].imageUrl!,
                                          // 'https://imgs.search.brave.com/ltJxRVJA0FGir3sC3gvVHUkKmVEFrp4Hh2FD-P0rt5o/rs:fit:860:0:0/g:ce/aHR0cHM6Ly9pLmV0/c3lzdGF0aWMuY29t/LzQ1MDg1OTU1L3Iv/aWwvZDgwNTYzLzU0/NTc3MDM5OTMvaWxf/NjAweDYwMC41NDU3/NzAzOTkzX2R2bmgu/anBn',
                                        ),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                                //!
                                Flexible(
                                  child: Container(
                                    //color: Colors.cyan,
                                    margin: const EdgeInsets.only(
                                      top: 20,
                                      left: 10,
                                    ),
                                    child: Wrap(
                                      children: [
                                        Text(
                                          cartList[index].name!,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        //Gap(10),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 7,
                                            //left: 7,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                cartList[index]
                                                    .price
                                                    .toString(),
                                                // maxLines: 2,
                                                // overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red,
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    right: 5),
                                                height: 35,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color: Colors.grey.shade300,
                                                ),
                                                child: Row(
                                                  children: [
                                                    IconButton(
                                                      onPressed: () {
                                                        cartList[index].qty == 1
                                                            ? cart.removeItem(
                                                                cartList[index])
                                                            : cart.reduceByOne(
                                                                cartList[
                                                                    index]);
                                                      },
                                                      icon: cartList[index]
                                                                  .qty ==
                                                              1
                                                          ? const Icon(
                                                              Icons.delete,
                                                              size: 18,
                                                              color:
                                                                  Colors.black,
                                                            )
                                                          : const Icon(
                                                              Icons
                                                                  .minimize_rounded,
                                                              size: 18,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                    ),
                                                    const Gap(6),
                                                    Text(
                                                      cartList[index]
                                                          .qty
                                                          .toString(),
                                                      style: const TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    IconButton(
                                                      onPressed: () {
                                                        cart.increment(
                                                            cartList[index]);
                                                      },
                                                      icon: const Icon(
                                                        Icons.add,
                                                        size: 18,
                                                        color: Colors.black,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
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
                  );
                },
              ),
        bottomSheet: Padding(
          padding: const EdgeInsets.all(10),
          //height: 70,
          //color: Colors.yellow,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total : ${context.watch<Cart>().totalPrice.toString()}',
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              InkWell(
                onTap: () {
                  context.read<Cart>().getItems.isEmpty
                      ? ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            duration: Duration(seconds: 3),
                            behavior: SnackBarBehavior.fixed,
                            padding: EdgeInsets.all(15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                            content: Text('Cart Is Empty!', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, color: Colors.white),),
                          ),
                        )
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>  CheckOutPage(cart: cartList,)),);
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width / 2.2,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.indigo),
                  child: const Center(
                    child: Text(
                      'Order Now',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
