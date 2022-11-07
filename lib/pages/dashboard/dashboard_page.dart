import 'package:flutter/material.dart';

import '../../dbs/database_helper.dart';
import '../../dbs/sharef.dart';
import '../customer_page/customer_page.dart';
import '../logout_page/logout_page.dart';
import '../product_page/product_list_page.dart';
import '../quotation_page/quotation_page.dart';
import '../way_planning_page/way_planning_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final databaseHelper = DatabaseHelper();
  @override
  void initState() {
    super.initState();
    deleteAllDatabase();
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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false, //for overflow pixel
        backgroundColor: const Color(0xFFE9E9E9),
        appBar: AppBar(
          title: const Text('PMG Tablet Sale'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) {
                  return const LogoutPage();
                }), (route) => false);
              },
              icon: const Icon(Icons.exit_to_app),
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return const ProductListPage();
                        },
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      SizedBox(
                        height: height * 0.16,
                        child: Image.asset(
                          'assets/icon/pd_icon.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Center(
                        child: Text(
                          'Product',
                          style: TextStyle(
                            fontSize: 18,
                            // fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return const CustomerListPage();
                      },
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: height * 0.16,
                        child: Image.asset(
                          'assets/icon/shop_icon.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Center(
                        child: Text(
                          'Customer',
                          style: TextStyle(
                            fontSize: 18,
                            // fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return const WayPlanningListPage();
                      },
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: height * 0.16,
                        child: Image.asset(
                          'assets/icon/way_icon.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Center(
                        child: Text(
                          'Way Plan',
                          style: TextStyle(
                            fontSize: 18,
                            // fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return QuotationListPage(
                          saleType: 'direct_sale',
                        );
                      },
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: height * 0.16,
                        child: Image.asset(
                          'assets/icon/cash_sale_icon.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Center(
                        child: Text(
                          'Direct Sale',
                          style: TextStyle(
                            fontSize: 18,
                            // fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return QuotationListPage(
                          saleType: 'credit_sale',
                        );
                      },
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: height * 0.16,
                        child: Image.asset(
                          'assets/icon/order_sale_icon.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Center(
                        child: Text(
                          'Credit Sale',
                          style: TextStyle(
                            fontSize: 18,
                            // fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: height * 0.16,
                      child: Image.asset(
                        'assets/icon/pf_icon.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Center(
                      child: Text(
                        'Inventory',
                        style: TextStyle(
                          fontSize: 18,
                          // fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            //second part
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     Column(
            //       children: [
            //         SizedBox(
            //           height: height * 0.16,
            //           child: Image.asset(
            //             'assets/icon/product_icon.png',
            //             fit: BoxFit.fill,
            //           ),
            //         ),
            //         const SizedBox(height: 10),
            //         const Center(
            //           child: Text(
            //             'Product',
            //             style: TextStyle(
            //               fontSize: 18,
            //               // fontWeight: FontWeight.w700,
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //     Column(
            //       children: [
            //         SizedBox(
            //           height: height * 0.16,
            //           child: Image.asset(
            //             'assets/icon/customer_icon.png',
            //             fit: BoxFit.fill,
            //           ),
            //         ),
            //         const SizedBox(height: 10),
            //         const Center(
            //           child: Text(
            //             'Customer',
            //             style: TextStyle(
            //               fontSize: 18,
            //               // fontWeight: FontWeight.w700,
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //     Column(
            //       children: [
            //         SizedBox(
            //           height: height * 0.16,
            //           child: Image.asset(
            //             'assets/icon/quotation_icon.png',
            //             fit: BoxFit.fill,
            //           ),
            //         ),
            //         const SizedBox(height: 10),
            //         const Center(
            //           child: Text(
            //             'Quotation',
            //             style: TextStyle(
            //               fontSize: 18,
            //               // fontWeight: FontWeight.w700,
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //     Column(
            //       children: [
            //         SizedBox(
            //           height: height * 0.16,
            //           child: Image.asset(
            //             'assets/icon/way_plan_icon.png',
            //             fit: BoxFit.fill,
            //           ),
            //         ),
            //         const SizedBox(height: 10),
            //         const Center(
            //           child: Text(
            //             'Way Plan',
            //             style: TextStyle(
            //               fontSize: 18,
            //               // fontWeight: FontWeight.w700,
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //     Column(
            //       children: [
            //         SizedBox(
            //           height: height * 0.16,
            //           child: Image.asset(
            //             'assets/icon/profile_icon.png',
            //             fit: BoxFit.fill,
            //           ),
            //         ),
            //         const SizedBox(height: 10),
            //         const Center(
            //           child: Text(
            //             'Profile',
            //             style: TextStyle(
            //               fontSize: 18,
            //               // fontWeight: FontWeight.w700,
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
