import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../pages/quotation_page/quotation_bloc.dart';
import '../../pages/quotation_page/quotation_detail_page.dart';
import '../../utils/app_const.dart';

class QuotationCardWidget extends StatefulWidget {
  String name;
  String userid;
  List<dynamic> customerId;
  String amountTotal;
  String state;
  String createTime;
  String expectedDate;
  String dateOrder;
  String validityDate;
  List<dynamic> currencyId;
  // String exchangeRate;
  List<dynamic> pricelistId;
  List<dynamic> paymentTermId;
  List<dynamic> zoneId;
  List<dynamic> segmentId;
  List<dynamic> regionId;
  String filterBy;
  List<dynamic> zoneFilterId;
  List<dynamic> segmentFilterId;
  int quotationId;
  String saleType;
  QuotationCardWidget({
    Key? key,
    required this.quotationId,
    required this.name,
    required this.userid,
    required this.customerId,
    required this.amountTotal,
    required this.state,
    required this.createTime,
    required this.expectedDate,
    required this.dateOrder,
    required this.validityDate,
    required this.currencyId,
    // required this.exchangeRate,
    required this.pricelistId,
    required this.paymentTermId,
    required this.zoneId,
    required this.segmentId,
    required this.regionId,
    required this.filterBy,
    required this.zoneFilterId,
    required this.segmentFilterId,
    required this.saleType,
  }) : super(key: key);

  @override
  State<QuotationCardWidget> createState() => _QuotationCardWidgetState();
}

class _QuotationCardWidgetState extends State<QuotationCardWidget> {
  final quotationBloc = QuotationBloc();
  final slidableController = SlidableController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Slidable(
        controller: slidableController,
        actionPane: const SlidableBehindActionPane(),
        secondaryActions: [
          IconSlideAction(
            color: AppColors.appBarColor,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return QuotationRecordDetailPage(
                    saleType: widget.saleType,
                    quotationId: widget.quotationId,
                    name: widget.name,
                    userid: widget.userid,
                    customerId: widget.customerId,
                    amountTotal: widget.amountTotal,
                    state: widget.state,
                    createTime: widget.createTime,
                    expectedDate: widget.expectedDate,
                    dateOrder: widget.dateOrder,
                    validityDate: widget.validityDate,
                    currencyId: widget.currencyId,
                    // exchangeRate: widget.exchangeRate,
                    pricelistId: widget.pricelistId,
                    paymentTermId: widget.paymentTermId,
                    zoneId: widget.zoneId,
                    // zoneId: [],
                    segmentId: widget.segmentId,
                    // segmentId: [],
                    regionId: widget.regionId,
                    // regionId: [],
                    filterBy: widget.filterBy,
                    zoneFilterId: widget.zoneFilterId,
                    // zoneFilterId: [],
                    segmentFilterId: widget.segmentFilterId);
                // segmentFilterId: [],
                // );
              })).then((value) {
                setState(() {
                  quotationBloc.getQuotationData();
                });
              });
            },
            iconWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.read_more,
                  size: 25,
                  color: Colors.white,
                ),
                Text(
                  "View Details",
                  style: TextStyle(
                      fontSize:
                          MediaQuery.of(context).size.width > 400.0 ? 18 : 12,
                      color: Colors.white),
                ),
              ],
            ),
          )
        ],
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: const BoxDecoration(
            color: Colors.white,
            // borderRadius: BorderRadius.circular(10),
            // boxShadow: const [
            //   BoxShadow(
            //     color: Colors.black,
            //     offset: Offset(0, 0),
            //     blurRadius: 3,
            //   )]
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '', //widget.customerId[1]
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(widget.name),
                    Row(
                      children: [
                        Text(widget.createTime),
                        const SizedBox(
                          width: 5,
                        ),
                        const Icon(
                          Icons.access_time,
                          size: 15,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      ' K',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Container(
                      color: Colors.cyan,
                      child: Text(''),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
