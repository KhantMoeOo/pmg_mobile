import 'package:flutter/material.dart';

class ProductCardWidget extends StatefulWidget {
  int productid;
  String productName;
  String productCode;
  bool saleOk;
  bool purchaseOk;
  double listPrice;
  double qtyAvailable;
  List<dynamic> uomId;
  ProductCardWidget({
    Key? key,
    required this.productid,
    required this.productName,
    required this.productCode,
    required this.saleOk,
    required this.purchaseOk,
    required this.listPrice,
    required this.qtyAvailable,
    required this.uomId,
  }) : super(key: key);

  @override
  State<ProductCardWidget> createState() => _ProductCardWidgetState();
}

class _ProductCardWidgetState extends State<ProductCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.productName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(widget.productCode),
                  RichText(
                      text: TextSpan(
                          style: const TextStyle(color: Colors.black),
                          children: [
                        const TextSpan(text: "Price: "),
                        TextSpan(text: "${widget.listPrice}"),
                        const TextSpan(text: "K")
                      ])),
                  RichText(
                      text: TextSpan(
                          style: const TextStyle(color: Colors.black),
                          children: [
                        const TextSpan(text: "On hand: "),
                        TextSpan(
                          text: "${widget.qtyAvailable}",
                        ),
                        TextSpan(
                            text:
                                "${widget.uomId.isEmpty ? '' : widget.uomId[1]}")
                      ]))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
