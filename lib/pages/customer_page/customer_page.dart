import 'dart:io';

import 'package:flutter/material.dart';

import '../../dbs/database_helper.dart';
import '../../dbs/sharef.dart';
import '../../obs/response_ob.dart';
import '../../widgets/customer_widgets/customer_card_widget.dart';
// import '../../widgets/drawer_widget.dart';
import 'customer_bloc.dart';
import 'customer_create_page.dart';

class CustomerListPage extends StatefulWidget {
  const CustomerListPage({Key? key}) : super(key: key);

  @override
  State<CustomerListPage> createState() => _CustomerListPageState();
}

class _CustomerListPageState extends State<CustomerListPage> {
  final customerBloc = CustomerBloc();
  List<dynamic> customerList = [];
  Map<dynamic, dynamic> customerListClicked = {};
  final customerSearchController = TextEditingController();
  bool isSearch = false;
  bool searchDone = false;
  final databaseHelper = DatabaseHelper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    deleteAllDatabase();
    customerBloc.getCustomerList(name: ['name', 'ilike', '']);
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

  void getCustomerListListen(ResponseOb responseOb) {
    if (responseOb.msgState == MsgState.data) {
      customerList = responseOb.data;
    } else if (responseOb.msgState == MsgState.error) {
      print('Get Customer List Failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<ResponseOb>(
        initialData: customerList.isNotEmpty
            ? null
            : ResponseOb(msgState: MsgState.loading),
        stream: customerBloc.getCustomerListStream(),
        builder: (context, AsyncSnapshot<ResponseOb> snapshot) {
          ResponseOb? responseOb = snapshot.data;
          if (responseOb?.msgState == MsgState.error) {
            return const Center(
              child: Text('Error'),
            );
          } else if (responseOb?.msgState == MsgState.data) {
            customerList = responseOb!.data;
            return Scaffold(
                backgroundColor: Colors.grey[200],
                // drawer: const DrawerWidget(),
                appBar: AppBar(
                  // backgroundColor: const Color.fromARGB(255, 12, 41, 92),
                  title: const Text("Customers"),
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
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      readOnly: searchDone,
                                      controller: customerSearchController,
                                      onChanged: (value) {
                                        if (value.isNotEmpty) {
                                          setState(() {
                                            isSearch = true;
                                          });
                                        } else {
                                          setState(() {
                                            isSearch = false;
                                          });
                                        }
                                      },
                                      decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              if (searchDone == true) {
                                                setState(() {
                                                  customerSearchController
                                                      .clear();
                                                  searchDone = false;
                                                  customerBloc.getCustomerList(
                                                      name: [
                                                        'name',
                                                        'ilike',
                                                        ''
                                                      ]);
                                                });
                                              } else {
                                                setState(() {
                                                  searchDone = true;
                                                  isSearch = false;
                                                  customerBloc.getCustomerList(
                                                      name: [
                                                        'name',
                                                        'ilike',
                                                        customerSearchController
                                                            .text
                                                      ]);
                                                });
                                              }
                                            },
                                            icon: searchDone == true
                                                ? const Icon(Icons.close)
                                                : const Icon(Icons.search),
                                          ),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10))),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.green,
                                      ),
                                      width: 60,
                                      child: const TextButton(
                                        onPressed: null,
                                        // () {
                                        // Navigator.of(context).push(
                                        //     MaterialPageRoute(
                                        //         builder: (context) {
                                        //   return CustomerCreatePage();
                                        // })).then((value) {
                                        //   setState(() {
                                        //     customerBloc
                                        //         .getCustomerList(name: [
                                        //       'name',
                                        //       'ilike',
                                        //       customerSearchController.text
                                        //     ]);
                                        //   });
                                        // });
                                        // },
                                        child: Text("Create",
                                            style: TextStyle(
                                              color: Colors.white,
                                            )),
                                      )),
                                ],
                              ),
                            ),
                          ),
                          customerList.isEmpty
                              ? const Center(
                                  child: Text('No Data'),
                                )
                              : Expanded(
                                  child: Stack(
                                    children: [
                                      ListView.builder(
                                          // controller: customerSearchController,
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          itemCount: customerList.length,
                                          itemBuilder: (context, i) {
                                            return InkWell(
                                              onTap: () {
                                                setState(() =>
                                                    customerListClicked =
                                                        customerList[i]);
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 20),
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  color: Colors.white,
                                                  child: Row(
                                                    children: [
                                                      customerList[i][
                                                                  'company_type'] ==
                                                              'person'
                                                          ? Image.asset(
                                                              "assets/icon/profile_icon.png",
                                                              width: 100,
                                                              height: 100)
                                                          : Image.asset(
                                                              "assets/icon/customer_icon.png",
                                                              width: 100,
                                                              height: 100),
                                                      const SizedBox(width: 10),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              customerList[i]
                                                                  ['name'],
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 20,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(
                                                                customerList[i][
                                                                            'code'] ==
                                                                        false
                                                                    ? ''
                                                                    : customerList[
                                                                            i][
                                                                        'code'],
                                                                style:
                                                                    const TextStyle(
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                  fontSize: 15,
                                                                )),
                                                            Text(
                                                                '${customerList[i]['street'] == false ? '' : customerList[i]['street']}',
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 15,
                                                                ))
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                            // return CustomerCardWidget(
                                            //   customerName: customerList[i]
                                            //       ['name'],
                                            //   code: customerList[i]['code'] ==
                                            //           false
                                            //       ? ''
                                            //       : customerList[i]['code'],
                                            //   address: customerList[i]
                                            //               ['street'] ==
                                            //           false
                                            //       ? ''
                                            //       : customerList[i]['street'],
                                            //   companyType: customerList[i]
                                            //       ['company_type'],
                                            // );
                                          }),
                                      SizedBox(
                                        height: isSearch ? 500 : 0,
                                        child: ListView(
                                          children: [
                                            Visibility(
                                              visible: isSearch,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                margin: const EdgeInsets.only(
                                                    left: 15, right: 15),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
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
                                                                    setState(
                                                                        () {
                                                                      isSearch =
                                                                          false;
                                                                      searchDone =
                                                                          true;
                                                                      customerBloc
                                                                          .getCustomerList(
                                                                              name: [
                                                                            'name',
                                                                            'ilike',
                                                                            customerSearchController.text
                                                                          ]);
                                                                    });
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    height: 50,
                                                                    child: RichText(
                                                                        text: TextSpan(children: [
                                                                      const TextSpan(
                                                                          text:
                                                                              "Search Name for: ",
                                                                          style: TextStyle(
                                                                              fontStyle: FontStyle.italic,
                                                                              color: Colors.black,
                                                                              fontWeight: FontWeight.bold)),
                                                                      TextSpan(
                                                                          text: customerSearchController
                                                                              .text,
                                                                          style:
                                                                              const TextStyle(color: Colors.black))
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
                                                                    setState(
                                                                        () {
                                                                      isSearch =
                                                                          false;
                                                                      searchDone =
                                                                          true;
                                                                      customerBloc
                                                                          .getCustomerList(
                                                                              name: [
                                                                            'email',
                                                                            'ilike',
                                                                            customerSearchController.text
                                                                          ]);
                                                                    });
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    height: 50,
                                                                    child: RichText(
                                                                        text: TextSpan(children: [
                                                                      const TextSpan(
                                                                          text:
                                                                              "Search Email for: ",
                                                                          style: TextStyle(
                                                                              fontStyle: FontStyle.italic,
                                                                              color: Colors.black,
                                                                              fontWeight: FontWeight.bold)),
                                                                      TextSpan(
                                                                          text: customerSearchController
                                                                              .text,
                                                                          style:
                                                                              const TextStyle(color: Colors.black))
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
                                                                    customerBloc
                                                                        .getCustomerList(
                                                                      name: [
                                                                        'phone',
                                                                        'ilike',
                                                                        customerSearchController
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
                                                                    child: RichText(
                                                                        text: TextSpan(children: [
                                                                      const TextSpan(
                                                                          text:
                                                                              "Search Phone for: ",
                                                                          style: TextStyle(
                                                                              fontStyle: FontStyle.italic,
                                                                              color: Colors.black,
                                                                              fontWeight: FontWeight.bold)),
                                                                      TextSpan(
                                                                          text: customerSearchController
                                                                              .text,
                                                                          style:
                                                                              const TextStyle(color: Colors.black))
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
                                                                    customerBloc
                                                                        .getCustomerList(
                                                                            name: [
                                                                          'category_id',
                                                                          'ilike',
                                                                          customerSearchController
                                                                              .text
                                                                        ]);
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    height: 50,
                                                                    child: RichText(
                                                                        text: TextSpan(children: [
                                                                      const TextSpan(
                                                                          text:
                                                                              "Search Tags for: ",
                                                                          style: TextStyle(
                                                                              fontStyle: FontStyle.italic,
                                                                              color: Colors.black,
                                                                              fontWeight: FontWeight.bold)),
                                                                      TextSpan(
                                                                          text: customerSearchController
                                                                              .text,
                                                                          style:
                                                                              const TextStyle(color: Colors.black))
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
                                                                    customerBloc
                                                                        .getCustomerList(
                                                                            name: [
                                                                          'user_id',
                                                                          'ilike',
                                                                          customerSearchController
                                                                              .text
                                                                        ]);
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    height: 50,
                                                                    child: RichText(
                                                                        text: TextSpan(children: [
                                                                      const TextSpan(
                                                                          text:
                                                                              "Search Sale Person for: ",
                                                                          style: TextStyle(
                                                                              fontStyle: FontStyle.italic,
                                                                              color: Colors.black,
                                                                              fontWeight: FontWeight.bold)),
                                                                      TextSpan(
                                                                          text: customerSearchController
                                                                              .text,
                                                                          style:
                                                                              const TextStyle(color: Colors.black))
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
                                      )
                                    ],
                                  ),
                                ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: customerListClicked.isEmpty
                          ? const SizedBox()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 30),
                                    child: Text(
                                      customerListClicked['name'],
                                      style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Text(
                                        'Code : ',
                                        style: label,
                                      ),
                                    ),
                                    Expanded(
                                        flex: 4,
                                        child: Text(customerListClicked['code']
                                            .toString())),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Text(
                                        'Address : ',
                                        style: label,
                                      ),
                                    ),
                                    Expanded(
                                        flex: 4,
                                        child: Text(
                                            customerListClicked['street'] ==
                                                    false
                                                ? ''
                                                : customerListClicked['street']
                                                    .toString())),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Text(
                                        'Segment : ',
                                        style: label,
                                      ),
                                    ),
                                    Expanded(
                                        flex: 4,
                                        child: Text(customerListClicked[
                                                    'segment_id'] ==
                                                false
                                            ? ''
                                            : customerListClicked['segment_id']
                                                .toString())),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Text(
                                        'Zone : ',
                                        style: label,
                                      ),
                                    ),
                                    Expanded(
                                        flex: 4,
                                        child: Text(
                                            customerListClicked['zone_id'] ==
                                                    false
                                                ? ''
                                                : customerListClicked['zone_id']
                                                    .toString())),
                                  ],
                                ),
                              ],
                            ),
                    ),
                  ],
                ));
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
