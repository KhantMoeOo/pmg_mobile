import 'dart:convert';

import 'package:flutter/material.dart';

import '../../dbs/database_helper.dart';
import '../../dbs/sharef.dart';
import '../../obs/response_ob.dart';
import 'product_list_bloc.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({Key? key}) : super(key: key);

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final databaseHelper = DatabaseHelper();
  final productListBloc = ProductBloc();
  List<dynamic> productList = [];
  ScrollController scrollController = ScrollController();
  bool isScroll = false;
  final productSearchController = TextEditingController();
  bool searchDone = false;
  bool isSearch = false;
  int _productId = 0;
  String productName = '';
  String productCode = '';
  String canBeSold = '';
  String quantity = '';
  String unit = '';
  String price = '';

  @override
  void initState() {
    super.initState();
    deleteAllDatabase();
    productListBloc.getProductListData(name: ['name', 'ilike', '']);
  }

  void deleteAllDatabase() async {
    await databaseHelper.deleteAllHrEmployeeLine();
    await databaseHelper.deleteAllHrEmployeeLineUpdate();
    await databaseHelper.deleteAllSaleOrderLine();
    await databaseHelper.deleteAllSaleOrderLineUpdate();
    await databaseHelper.deleteAllMaterialProductLine();
    await databaseHelper.deleteAllMaterialProductLineUpdate();
    await databaseHelper.deleteAllSaleOrderLineMultiSelect();
    await databaseHelper.deleteAllTripPlanDelivery();
    await databaseHelper.deleteAllTripPlanDeliveryUpdate();
    await databaseHelper.deleteAllTripPlanSchedule();
    await databaseHelper.deleteAllTripPlanScheduleUpdate();
    await databaseHelper.deleteAllAccountMoveLine();
    await databaseHelper.deleteAllAccountMoveLineUpdate();
    await databaseHelper.deleteAllTaxIds();
    await SharefCount.clearCount();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<ResponseOb>(
        initialData: productList.isNotEmpty
            ? null
            : ResponseOb(msgState: MsgState.loading),
        stream: productListBloc.getProductListStream(),
        builder: (context, AsyncSnapshot<ResponseOb> snapshot) {
          ResponseOb? responseOb = snapshot.data;
          if (responseOb?.msgState == MsgState.error) {
            return const Center(
              child: Text('Error'),
            );
          } else if (responseOb?.msgState == MsgState.data) {
            productList = responseOb!.data;
            return Scaffold(
              resizeToAvoidBottomInset: false, //for overflow pixel
              backgroundColor: const Color(0xFFE9E9E9),
              appBar: AppBar(
                title: const Text('Product Lists'),
              ),
              body: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 10, bottom: 10),
                          child: SizedBox(
                            height: 50,
                            child: TextField(
                              controller: productSearchController,
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  setState(() => isSearch = true);
                                } else {
                                  setState(() => isSearch = false);
                                }
                              },
                              readOnly: searchDone,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    if (searchDone == true) {
                                      setState(() {
                                        productSearchController.clear();
                                        searchDone = false;
                                        productListBloc.getProductListData(
                                            name: ['name', 'ilike', '']);
                                      });
                                    } else {
                                      setState(() {
                                        searchDone = true;
                                        isSearch = false;
                                        productListBloc.getProductListData(
                                            name: [
                                              'name',
                                              'ilike',
                                              productSearchController.text
                                            ]);
                                      });
                                    }
                                  },
                                  icon: searchDone == true
                                      ? const Icon(Icons.close)
                                      : const Icon(Icons.search),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "Total Products: " +
                                    productList.length.toString(),
                                style: const TextStyle(fontSize: 15),
                              )),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        productList.isEmpty
                            ? const Center(
                                child: Text('No Data'),
                              )
                            : Expanded(
                                child: Stack(
                                  children: [
                                    ListView.builder(
                                      controller: scrollController,
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      itemCount: productList.length,
                                      itemBuilder: (context, i) {
                                        return InkWell(
                                          onTap: () {
                                            setState(() {
                                              productName = productList[i]
                                                      ['name']
                                                  .toString();
                                              productCode = productList[i]
                                                      ['product_code']
                                                  .toString();
                                              canBeSold = productList[i]
                                                      ['sale_ok']
                                                  .toString();
                                              quantity = productList[i]
                                                      ['qty_available']
                                                  .toString();
                                              unit = productList[i]['uom_id'][1]
                                                  .toString();
                                              price = productList[i]
                                                      ['list_price']
                                                  .toString();
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8),
                                            child: Container(
                                              padding: const EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      color: Colors.black,
                                                      offset: Offset(0, 0),
                                                      blurRadius: 2,
                                                    )
                                                  ]),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    flex: 2,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          productList[i]
                                                              ['name'],
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(productList[i]
                                                            ['product_code']),
                                                        RichText(
                                                            text: TextSpan(
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                                children: [
                                                              const TextSpan(
                                                                  text:
                                                                      "Price: "),
                                                              TextSpan(
                                                                  text:
                                                                      "${productList[i]['list_price']}"),
                                                              const TextSpan(
                                                                  text: "K")
                                                            ])),
                                                        RichText(
                                                            text: TextSpan(
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                                children: [
                                                              const TextSpan(
                                                                  text:
                                                                      "On hand: "),
                                                              TextSpan(
                                                                text:
                                                                    "${productList[i]['qty_available']}",
                                                              ),
                                                              TextSpan(
                                                                  text:
                                                                      "${productList[i]['uom_id']}")
                                                            ]))
                                                      ],
                                                    ),
                                                  ),
                                                  // productList[i]
                                                  //             ['image_1920'] ==
                                                  //         false
                                                  //     ? Container()
                                                  //     : Expanded(
                                                  //         child: CircleAvatar(
                                                  //           radius: 40,
                                                  //           backgroundImage:
                                                  //               MemoryImage(
                                                  //             base64Decode(
                                                  //                 productList[i]
                                                  //                     [
                                                  //                     'image_1920']),
                                                  //           ),
                                                  //         ),
                                                  //       ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                        // ProductCardWidget(
                                        //   productid: productList[i]['id'],
                                        //   productName: productList[i]['name'],
                                        //   productCode: productList[i]
                                        //               ['product_code'] ==
                                        //           false
                                        //       ? ''
                                        //       : productList[i]['product_code'],
                                        //   saleOk: productList[i]['sale_ok'],
                                        //   purchaseOk: productList[i]
                                        //       ['purchase_ok'],
                                        //   listPrice: productList[i]
                                        //               ['list_price'] ==
                                        //           false
                                        //       ? 0.0
                                        //       : productList[i]['list_price'],
                                        //   qtyAvailable: productList[i]
                                        //               ['qty_available'] ==
                                        //           false
                                        //       ? 0.0
                                        //       : productList[i]['qty_available'],
                                        //   uomId:
                                        //       productList[i]['uom_id'] == false
                                        //           ? []
                                        //           : productList[i]['uom_id'],
                                        // );
                                      },
                                    ),
                                    SizedBox(
                                      height: isSearch ? 500 : 0,
                                      child: ListView(
                                        children: [
                                          Visibility(
                                            visible: isSearch,
                                            child: Container(
                                              padding: const EdgeInsets.all(5),
                                              margin: const EdgeInsets.only(
                                                  left: 15, right: 15),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.grey[200],
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      color: Colors.black,
                                                      blurRadius: 2,
                                                      offset: Offset(0, 0),
                                                    )
                                                  ]),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Expanded(
                                                              child: InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    isSearch =
                                                                        false;
                                                                    searchDone =
                                                                        true;
                                                                    productListBloc
                                                                        .getProductListData(
                                                                            name: [
                                                                          'name',
                                                                          'ilike',
                                                                          productSearchController
                                                                              .text
                                                                        ]);
                                                                  });
                                                                },
                                                                child:
                                                                    Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  height: 50,
                                                                  child:
                                                                      RichText(
                                                                          text: TextSpan(
                                                                              children: [
                                                                        const TextSpan(
                                                                            text:
                                                                                "Search Product for: ",
                                                                            style: TextStyle(
                                                                                fontStyle: FontStyle.italic,
                                                                                color: Colors.black,
                                                                                fontWeight: FontWeight.bold)),
                                                                        TextSpan(
                                                                            text:
                                                                                productSearchController.text,
                                                                            style: const TextStyle(color: Colors.black))
                                                                      ])),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const Divider(
                                                          thickness: 1.5,
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    isSearch =
                                                                        false;
                                                                    searchDone =
                                                                        true;
                                                                    productListBloc
                                                                        .getProductListData(
                                                                            name: [
                                                                          'product_code',
                                                                          'ilike',
                                                                          productSearchController
                                                                              .text
                                                                        ]);
                                                                  });
                                                                },
                                                                child:
                                                                    Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  height: 50,
                                                                  child:
                                                                      RichText(
                                                                          text: TextSpan(
                                                                              children: [
                                                                        const TextSpan(
                                                                            text:
                                                                                "Search Code for: ",
                                                                            style: TextStyle(
                                                                                fontStyle: FontStyle.italic,
                                                                                color: Colors.black,
                                                                                fontWeight: FontWeight.bold)),
                                                                        TextSpan(
                                                                            text:
                                                                                productSearchController.text,
                                                                            style: const TextStyle(color: Colors.black))
                                                                      ])),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const Divider(
                                                          thickness: 1.5,
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: InkWell(
                                                                onTap: () {
                                                                  isSearch =
                                                                      false;
                                                                  searchDone =
                                                                      true;
                                                                  productListBloc
                                                                      .getProductListData(
                                                                          name: [
                                                                        'categ_id',
                                                                        'ilike',
                                                                        productSearchController
                                                                            .text
                                                                      ]);
                                                                },
                                                                child:
                                                                    Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  height: 50,
                                                                  child:
                                                                      RichText(
                                                                          text: TextSpan(
                                                                              children: [
                                                                        const TextSpan(
                                                                            text:
                                                                                "Search Product Category for: ",
                                                                            style: TextStyle(
                                                                                fontStyle: FontStyle.italic,
                                                                                color: Colors.black,
                                                                                fontWeight: FontWeight.bold)),
                                                                        TextSpan(
                                                                            text:
                                                                                productSearchController.text,
                                                                            style: const TextStyle(color: Colors.black))
                                                                      ])),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const Divider(
                                                          thickness: 1.5,
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: InkWell(
                                                                onTap: () {
                                                                  isSearch =
                                                                      false;
                                                                  searchDone =
                                                                      true;
                                                                  productListBloc
                                                                      .getProductListData(
                                                                          name: [
                                                                        'custom_category_id',
                                                                        'ilike',
                                                                        productSearchController
                                                                            .text
                                                                      ]);
                                                                },
                                                                child:
                                                                    Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  height: 50,
                                                                  child:
                                                                      RichText(
                                                                          text: TextSpan(
                                                                              children: [
                                                                        const TextSpan(
                                                                            text:
                                                                                "Search Main Category for: ",
                                                                            style: TextStyle(
                                                                                fontStyle: FontStyle.italic,
                                                                                color: Colors.black,
                                                                                fontWeight: FontWeight.bold)),
                                                                        TextSpan(
                                                                            text:
                                                                                productSearchController.text,
                                                                            style: const TextStyle(color: Colors.black))
                                                                      ])),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const Divider(
                                                          thickness: 1.5,
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: InkWell(
                                                                onTap: () {
                                                                  isSearch =
                                                                      false;
                                                                  searchDone =
                                                                      true;
                                                                  productListBloc
                                                                      .getProductListData(
                                                                    name: [
                                                                      'list_price',
                                                                      'ilike',
                                                                      productSearchController
                                                                          .text
                                                                    ],
                                                                  );
                                                                },
                                                                child:
                                                                    Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  height: 50,
                                                                  child:
                                                                      RichText(
                                                                          text: TextSpan(
                                                                              children: [
                                                                        const TextSpan(
                                                                            text:
                                                                                "Search Pricelist for: ",
                                                                            style: TextStyle(
                                                                                fontStyle: FontStyle.italic,
                                                                                color: Colors.black,
                                                                                fontWeight: FontWeight.bold)),
                                                                        TextSpan(
                                                                            text:
                                                                                productSearchController.text,
                                                                            style: const TextStyle(color: Colors.black))
                                                                      ])),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: productName.isEmpty &&
                            productCode.isEmpty &&
                            canBeSold.isEmpty &&
                            quantity.isEmpty &&
                            unit.isEmpty &&
                            price.isEmpty
                        ? const SizedBox()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 30),
                                  child: Text(
                                    productName,
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      'Product Code : ',
                                      style: label,
                                    ),
                                  ),
                                  Expanded(flex: 4, child: Text(productCode)),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      'Can Be Sold : ',
                                      style: label,
                                    ),
                                  ),
                                  Expanded(flex: 4, child: Text(canBeSold)),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      'Price of Product : ',
                                      style: label,
                                    ),
                                  ),
                                  Expanded(flex: 4, child: Text(price + ' K')),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      'On Hand Quantity : ',
                                      style: label,
                                    ),
                                  ),
                                  Expanded(flex: 4, child: Text(quantity)),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      'Unit of Measurement : ',
                                      style: label,
                                    ),
                                  ),
                                  Expanded(flex: 4, child: Text(unit)),
                                ],
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            );
          } else {
            return Container(
              color: Colors.white,
              child: Center(
                child: Image.asset(
                  'assets/gifs/loading.gif',
                  width: 50,
                  height: 50,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  final label = const TextStyle(fontSize: 18, fontWeight: FontWeight.w600);
}
