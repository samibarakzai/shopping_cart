import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/cart_provider.dart';
import 'package:shopping_cart/Cart_model.dart';
import 'package:shopping_cart/db_helper.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DBHelper? dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('My Product'),
        centerTitle: true,
        actions: [
          Center(
            child: Badge(
              badgeContent: Consumer<CartProvider>(
                builder: (context, value, child) {
                  return Text(value.getCounter().toString(),
                      style: TextStyle(color: Colors.white));
                },
              ),
              animationDuration: Duration(milliseconds: 300),
              child: Icon(Icons.shopping_bag_outlined),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            FutureBuilder(
                future: cart.getData(),
                builder: (context, AsyncSnapshot<List<Cart>> snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Image(
                                          height: 100,
                                          width: 100,
                                          image: NetworkImage(snapshot
                                              .data![index].image
                                              .toString()),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    snapshot
                                                        .data![index].productName
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                  InkWell(
                                                      onTap: () {
                                                        dbHelper!.delete(snapshot
                                                            .data![index].id!);
                                                        cart.removeCounter();
                                                        cart.removeTotalPrice(
                                                            double.parse(snapshot
                                                                .data![index]
                                                                .productPrice
                                                                .toString()));
                                                      },
                                                      child: Icon(Icons.delete))
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                snapshot.data![index].unitTag
                                                        .toString() +
                                                    "    " +
                                                    r"$" +
                                                    snapshot
                                                        .data![index].productPrice
                                                        .toString(),
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 7,
                                              ),
                                              Align(
                                                alignment: Alignment.centerRight,
                                                child: InkWell(
                                                 onTap: (){

                                                 },
                                                  child: Container(
                                                    height: 35,
                                                    width: 100,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                5),
                                                        color: Colors.green),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          InkWell(
                                                            onTap: (){
                                                              int quantity = snapshot.data![index].quantity! ;
                                                              int price = snapshot.data![index].initialPrice! ;
                                                              quantity--;
                                                              int? newPrice = price * quantity;

                                                              if(quantity > 0){
                                                                dbHelper!.updateQuantity(
                                                                    Cart(id: snapshot.data![index].id!,
                                                                        productId: snapshot.data![index].id!.toString(),
                                                                        productName: snapshot.data![index].productName!,
                                                                        productPrice: newPrice ,
                                                                        initialPrice: snapshot.data![index].initialPrice!,
                                                                        quantity: quantity,
                                                                        unitTag: snapshot.data![index].unitTag.toString(),
                                                                        image: snapshot.data![index].image.toString())
                                                                ).then((value){
                                                                  newPrice = 0 ;
                                                                  quantity = 0 ;
                                                                  cart.removeTotalPrice(double.parse(snapshot.data![index].initialPrice!.toString()));
                                                                }).onError((error, stackTrace) {
                                                                  print(error.toString());
                                                                });
                                                              }

                                                              dbHelper!.updateQuantity(
                                                                  Cart(id: snapshot.data![index].id!,
                                                                      productId: snapshot.data![index].id!.toString(),
                                                                      productName: snapshot.data![index].productName!,
                                                                      productPrice: newPrice ,
                                                                      initialPrice: snapshot.data![index].initialPrice!,
                                                                      quantity: quantity,
                                                                      unitTag: snapshot.data![index].unitTag.toString(),
                                                                      image: snapshot.data![index].image.toString())
                                                              ).then((value){
                                                                newPrice = 0 ;
                                                                quantity = 0 ;
                                                                cart.removeTotalPrice(double.parse(snapshot.data![index].initialPrice!.toString()));
                                                              }).onError((error, stackTrace) {
                                                                print(error.toString());
                                                              });
                                                            },
                                                              child: Icon(Icons.remove, color: Colors.white,)),
                                                          Text(snapshot.data![index].quantity.toString(), style: TextStyle(color: Colors.white)),
                                                          InkWell(
                                                              onTap: (){
                                                                int quantity = snapshot.data![index].quantity! ;
                                                                int price = snapshot.data![index].initialPrice! ;
                                                                quantity++;
                                                                int? newPrice = price * quantity;

                                                                dbHelper!.updateQuantity(
                                                                  Cart(id: snapshot.data![index].id!,
                                                                      productId: snapshot.data![index].id!.toString(),
                                                                      productName: snapshot.data![index].productName!,
                                                                      productPrice: newPrice ,
                                                                      initialPrice: snapshot.data![index].initialPrice!,
                                                                      quantity: quantity,
                                                                      unitTag: snapshot.data![index].unitTag.toString(),
                                                                      image: snapshot.data![index].image.toString())
                                                                ).then((value){
                                                                  newPrice = 0 ;
                                                                  quantity = 0 ;
                                                                  cart.addTotalPrice(double.parse(snapshot.data![index].initialPrice!.toString()));
                                                                }).onError((error, stackTrace) {
                                                                  print(error.toString());
                                                                });
                                                          },
                                                              child: Icon((Icons.add),color: Colors.white,)),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    );
                  }
                  return Text('');
                }),
            Consumer<CartProvider>(builder: (context, value, child) {
              return Visibility(
                visible: value.getTotalPrice().toStringAsFixed(2) == "0.00"
                    ? false
                    : true,
                child: Column(
                  children: [
                    ReUseAbleWidget(title: 'sub total', value: r'$' + value.getTotalPrice().toStringAsFixed(2),),
                    ReUseAbleWidget(title: 'Discount 5%', value: r'$' + '20',),
                    ReUseAbleWidget(title: 'Total', value: r'$' + value.getTotalPrice().toStringAsFixed(2),)
                  ],
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}

class ReUseAbleWidget extends StatelessWidget {
  final String title, value;

  const ReUseAbleWidget({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.subtitle2,
          ),
          Text(
            value.toString(),
            style: Theme.of(context).textTheme.subtitle2,
          )
        ],
      ),
    );
  }
}
