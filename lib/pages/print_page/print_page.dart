// // import 'package:bluetooth_print/bluetooth_print.dart';
// // import 'package:bluetooth_print/bluetooth_print_model.dart';
// // import 'package:flutter/material.dart';
// // import 'package:smc_mobile/obs/sale_order_line_ob.dart';

// // class PrintPage extends StatefulWidget {
// //   List<SaleOrderLineOb> productlineList;
// //   String orderId;
// //   String customerName;
// //   PrintPage({
// //     Key? key,
// //     required this.productlineList,
// //     required this.orderId,
// //     required this.customerName,
// //   }) : super(key: key);

// //   @override
// //   State<PrintPage> createState() => _PrintPageState();
// // }

// // class _PrintPageState extends State<PrintPage> {
// //   BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
// //   List<BluetoothDevice> _devices = [];
// //   String _deviceMsg = '';

// //   @override
// //   void initState() {
// //     // TODO: implement initState
// //     super.initState();
// //     WidgetsBinding.instance!.addPostFrameCallback((_) => iniPrinter());
// //   }

// //   Future<void> iniPrinter() async {
// //     bluetoothPrint.startScan(timeout: const Duration(seconds: 2));
// //     if (!mounted) return;
// //     bluetoothPrint.scanResults.listen((val) {
// //       if (!mounted) return;
// //       setState(() {
// //         _devices = val;
// //       });
// //       if (_devices.isEmpty) {
// //         setState(() {
// //           _deviceMsg = 'No Devices';
// //         });
// //       }
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Select Printer'),
// //       ),
// //       body: _devices.isEmpty
// //           ? Center(
// //               child: Text(_deviceMsg),
// //             )
// //           : ListView.builder(
// //               itemCount: _devices.length,
// //               itemBuilder: (c, i) {
// //                 return ListTile(
// //                   leading: const Icon(Icons.print),
// //                   title: Text(_devices[i].name!),
// //                   subtitle: Text(_devices[i].address!),
// //                   onTap: () {
// //                     _startPrint(_devices[i]);
// //                   },
// //                 );
// //               }),
// //     );
// //   }

// //   Future<void> _startPrint(BluetoothDevice device) async {
// //     if (device.address != null) {
// //       await bluetoothPrint.connect(device);
// //       List<LineText> list = [];

// //       list.add(LineText(
// //           type: LineText.TYPE_TEXT,
// //           content: 'Quotation Order',
// //           weight: 2,
// //           width: 2,
// //           height: 2,
// //           align: LineText.ALIGN_CENTER,
// //           linefeed: 1));

// //       for (var i = 0; i < widget.productlineList.length; i++) {
// //         list.add(LineText(
// //             type: LineText.TYPE_TEXT,
// //             content: widget.productlineList[i].description,
// //             weight: 0,
// //             align: LineText.ALIGN_LEFT));
// //       }
// //     }
// //   }
// // }
import 'dart:math';
import 'dart:typed_data';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'dart:io' show Platform;
import 'package:image/image.dart';
import '../../dbs/database_helper.dart';
import '../../obs/invoice_line_ob.dart';
import '../../obs/sale_order_line_ob.dart';
import '../../utils/app_const.dart';

class Print extends StatefulWidget {
  String orderId;
  String customerName;
  String address;
  String vrno;
  String terms;
  String saleperson;
  String invoicedate;
  String total;
  Uint8List customerSign;
  Uint8List authorSign;
  Print({
    Key? key,
    required this.orderId,
    required this.customerName,
    required this.address,
    required this.vrno,
    required this.terms,
    required this.saleperson,
    required this.invoicedate,
    required this.customerSign,
    required this.authorSign,
    required this.total,
  }) : super(key: key);
  @override
  _PrintState createState() => _PrintState();
}

class _PrintState extends State<Print> {
  List<InvoiceLineOb>? invoiceLineListDB = [];
  final databaseHelper = DatabaseHelper();
  final PrinterBluetoothManager _printerManager = PrinterBluetoothManager();
  List<PrinterBluetooth> _devices = [];
  String _devicesMsg = '';
  BluetoothManager bluetoothManager = BluetoothManager.instance;

  @override
  void initState() {
    getInvoiceLineListDB();
    if (Platform.isAndroid) {
      bluetoothManager.state.listen((val) {
        print('state =========================== $val');
        if (!mounted) return;
        if (val == 12) {
          print('on========================');
          initPrinter();
        } else if (val == 10) {
          print('off=========================');
          setState(() => _devicesMsg = 'Bluetooth Disconnect!');
        }
      });
    } else {
      initPrinter();
    }
    super.initState();
  }

  Future<void> getInvoiceLineListDB() async {
    invoiceLineListDB = await databaseHelper.getAccountMoveLineListUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        // backgroundColor: AppColors.appBarColor,
        title: const Text('Print'),
      ),
      body: _devices.isEmpty
          ? Center(child: Text(_devicesMsg))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _devices.length,
                    itemBuilder: (c, i) {
                      return ListTile(
                        leading: const Icon(Icons.print),
                        title: Text(_devices[i].name!),
                        subtitle: Text(_devices[i].address!),
                        onTap: () {
                          _startPrint(_devices[i]);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  void initPrinter() {
    _printerManager.startScan(Duration(seconds: 2));
    _printerManager.scanResults.listen((val) {
      if (!mounted) return;
      setState(() => _devices = val);
      if (_devices.isEmpty) setState(() => _devicesMsg = 'No Devices');
    });
  }

  Future<void> _startPrint(PrinterBluetooth printer) async {
    _printerManager.selectPrinter(printer);
    final result =
        await _printerManager.printTicket(await _ticket(PaperSize.mm80));
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Text(result.msg),
      ),
    );
  }

  Future<Ticket> _ticket(PaperSize paper) async {
    final ticket = Ticket(paper);
    int total = 0;
    // Image _customerSign = decodeImage(widget.customerSign);
    // Image _authorSign = decodeImage(widget.authorSign);
    // final mergetdImage = Image(_customerSign.width + _authorSign.width,
    //     max(_customerSign.height, _authorSign.height));
    // Image assets
    // final ByteData data = await rootBundle.load('assets/store.png');
    // final Uint8List bytes = data.buffer.asUint8List();
    // final Image image = decodeImage(bytes);
    // ticket.image(image);
    ticket.text(
      'PEACE MYANMAR GROUP CO.,LTD.',
      styles: const PosStyles(
        height: PosTextSize.size2,
        bold: true,
        align: PosAlign.center,
      ),
      linesAfter: 2,
    );
    ticket.text(
      'No(1), Corner of Zawtika Lane \n & \n Bayint Naung Main Road',
      styles: const PosStyles(
        align: PosAlign.center,
      ),
    );
    // ticket.text(
    //   'Shwe Lin Pan Industrial Zone',
    //   styles: const PosStyles(
    //     align: PosAlign.center,
    //   ),
    // );
    ticket.text(
      'Kamayut Township, Yangon, Myanmar',
      styles: const PosStyles(
        align: PosAlign.center,
      ),
    );
    ticket.text(
      '(+95-1)538 412, 526 196',
      styles: const PosStyles(
        align: PosAlign.center,
      ),
    );
    ticket.hr(ch: '_');
    ticket.text(
      'SALES INVOICE',
      styles: const PosStyles(
          bold: true,
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1),
      linesAfter: 1,
    );
    ticket.row([
      PosColumn(
          text: 'Customer Name',
          width: 4,
          styles: const PosStyles(
            bold: true,
          )),
      PosColumn(text: ':', width: 1),
      PosColumn(text: widget.customerName, width: 7),
    ]);
    ticket.row([
      PosColumn(
          text: 'Invoice Number',
          width: 4,
          styles: const PosStyles(
            bold: true,
          )),
      PosColumn(text: ':', width: 1),
      PosColumn(text: widget.vrno, width: 7),
      // PosColumn(text: '', width: 6),
      // PosColumn(
      //     text: 'Vr. No.  :',
      //     width: 2,
      //     styles: const PosStyles(
      //       bold: true,
      //     )),
      // PosColumn(text: widget.vrno, width: 4),
    ]);
    ticket.row([
      PosColumn(
          text: 'Address',
          width: 4,
          styles: const PosStyles(
            bold: true,
          )),
      PosColumn(text: ':', width: 1),
      PosColumn(text: widget.address, width: 7),
      // PosColumn(
      //     text: 'Address',
      //     width: 4,
      //     styles: const PosStyles(
      //       bold: true,
      //     )),
      // PosColumn(text: ':', width: 1),
      // PosColumn(text: '', width: 7),
    ]);
    ticket.row([
      PosColumn(
          text: 'Date',
          width: 4,
          styles: const PosStyles(
            bold: true,
          )),
      PosColumn(text: ':', width: 1),
      PosColumn(text: widget.invoicedate, width: 7),
      // PosColumn(text: '', width: 4),
      // PosColumn(
      //     text: 'Date',
      //     width: 3,
      //     styles: const PosStyles(
      //       bold: true,
      //     )),
      // PosColumn(text: ':', width: 1),
      // PosColumn(text: widget.invoicedate, width: 4),
    ]);
    // ticket.row([
    //   PosColumn(text: '', width: 4),
    //   PosColumn(
    //       text: 'PO No.',
    //       width: 3,
    //       styles: const PosStyles(
    //         bold: true,
    //       )),
    //   PosColumn(text: ':', width: 1),
    //   PosColumn(text: '', width: 4),
    // ]);
    // ticket.row([
    //   PosColumn(text: '', width: 4),
    //   PosColumn(
    //       text: 'Our DO No.',
    //       width: 3,
    //       styles: const PosStyles(
    //         bold: true,
    //       )),
    //   PosColumn(text: ':', width: 1),
    //   PosColumn(text: '', width: 4),
    // ]);
    // ticket.row([
    //   PosColumn(text: '', width: 4),
    //   PosColumn(
    //       text: 'Terms',
    //       width: 3,
    //       styles: const PosStyles(
    //         bold: true,
    //       )),
    //   PosColumn(text: ':', width: 1),
    //   PosColumn(text: widget.terms, width: 4),
    // ]);
    ticket.row([
      PosColumn(
          text: 'Sales Person',
          width: 4,
          styles: const PosStyles(
            bold: true,
          )),
      PosColumn(text: ':', width: 1),
      PosColumn(text: widget.saleperson, width: 7),
      // PosColumn(text: '', width: 4),
      // PosColumn(
      //     text: 'Sales Person',
      //     width: 3,
      //     styles: const PosStyles(
      //       bold: true,
      //     )),
      // PosColumn(text: ':', width: 1),
      // PosColumn(text: widget.saleperson, width: 4),
    ]);
    ticket.row([
      PosColumn(
          text: 'Terms',
          width: 4,
          styles: const PosStyles(
            bold: true,
          )),
      PosColumn(text: ':', width: 1),
      PosColumn(text: widget.terms, width: 7),
      // PosColumn(text: '', width: 4),
      // PosColumn(
      //     text: 'Page',
      //     width: 3,
      //     styles: const PosStyles(
      //       bold: true,
      //     )),
      // PosColumn(text: ':', width: 1),
      // PosColumn(text: '', width: 4),
    ]);
    // ticket.row([
    //   PosColumn(text: 'Myanmar', width: 6),
    //   PosColumn(
    //       text: 'ORDER DATE: ${widget.invoicedate.toString().split(' ')[0]}',
    //       width: 6),
    // ]);
    ticket.hr(ch: '_');
    ticket.row([
      PosColumn(
        text: 'Product Name',
        width: 6,
        styles: const PosStyles(
          bold: true,
        ),
      ),
      PosColumn(
        text: 'Qty',
        width: 1,
        styles: const PosStyles(
          bold: true,
        ),
      ),
      PosColumn(
        text: 'Price',
        width: 2,
        styles: const PosStyles(
          bold: true,
        ),
      ),
      PosColumn(
        text: 'Amount(ks)',
        width: 3,
        styles: const PosStyles(
          bold: true,
        ),
      ),
    ]);
    ticket.hr(ch: '_');
    for (var i = 0; i < invoiceLineListDB!.length; i++) {
      String productName = invoiceLineListDB![i].label.toString();
      String productNameExtra = '';
      int count = 0;
      if (productName.length > 18) {
        count += 1;
        productName = invoiceLineListDB![i].label.toString().substring(0, 18);
        productNameExtra = invoiceLineListDB![i].label.toString().substring(18);
      }
      // total += widget.data[i]['total_price'];
      // ticket.text('Purchase Order');
      // .length > 18
      //         ? invoiceLineListDB![i].label.toString().substring(0, 18) +
      //             '\n' +
      //             invoiceLineListDB![i].label.toString().substring(18)
      //         : invoiceLineListDB![i].label
      if (count == 0) {
        ticket.row([
          PosColumn(
            text: invoiceLineListDB![i].label.toString(),
            width: 6,
          ),
          PosColumn(
              text: (invoiceLineListDB![i].quantity).toString().substring(
                  0, invoiceLineListDB![i].quantity.toString().indexOf('.')),
              width: 1),
          PosColumn(
              text: (invoiceLineListDB![i].unitPrice).toString().substring(
                  0, invoiceLineListDB![i].unitPrice.toString().indexOf('.')),
              width: 2),
          PosColumn(
              text: (invoiceLineListDB![i].subTotal).toString().substring(
                  0, invoiceLineListDB![i].subTotal.toString().indexOf('.')),
              width: 3),
        ]);
      } else {
        ticket.row([
          PosColumn(
            text: productName,
            width: 6,
          ),
          PosColumn(
              text: (invoiceLineListDB![i].quantity).toString().substring(
                  0, invoiceLineListDB![i].quantity.toString().indexOf('.')),
              width: 1),
          PosColumn(
              text: (invoiceLineListDB![i].unitPrice).toString().substring(
                  0, invoiceLineListDB![i].unitPrice.toString().indexOf('.')),
              width: 2),
          PosColumn(
              text: (invoiceLineListDB![i].subTotal).toString().substring(
                  0, invoiceLineListDB![i].subTotal.toString().indexOf('.')),
              width: 3),
        ]);
        ticket.row([
          PosColumn(
            text: productNameExtra,
            width: 9,
          ),
          PosColumn(
            text: '',
            width: 3,
          ),
        ]);
      }
    }
    ticket.hr(ch: '_');
    // ticket.row([
    //   PosColumn(text: '', width: 6),
    //   PosColumn(text: 'Sub. Total', width: 4),
    //   PosColumn(text: '', width: 2),
    // ]);
    // ticket.row([
    //   PosColumn(text: '', width: 6),
    //   PosColumn(text: 'Tax@0%on', width: 4),
    //   PosColumn(text: '', width: 2),
    // ]);
    // ticket.row([
    //   PosColumn(text: '', width: 6),
    //   PosColumn(text: 'Advance', width: 4),
    //   PosColumn(text: '', width: 2),
    // ]);
    // ticket.row([
    //   PosColumn(text: '', width: 6),
    //   PosColumn(text: 'Discount', width: 4),
    //   PosColumn(text: '', width: 2),
    // ]);
    // ticket.row([
    //   PosColumn(text: '', width: 6),
    //   PosColumn(text: 'FOC Amount', width: 4),
    //   PosColumn(text: '', width: 2),
    // ]);
    ticket.row([
      PosColumn(text: '', width: 6),
      PosColumn(text: 'Total', width: 4),
      PosColumn(text: widget.total, width: 2),
    ]);
    // ticket.hr(ch: '_');
    // ticket.row([
    //   PosColumn(
    //       text: 'Description',
    //       width: 5,
    //       styles: const PosStyles(
    //         bold: true,
    //       )),
    //   PosColumn(
    //       text: 'Qty',
    //       width: 1,
    //       styles: const PosStyles(
    //         bold: true,
    //       )),
    //   PosColumn(
    //       text: 'U/M',
    //       width: 1,
    //       styles: const PosStyles(
    //         bold: true,
    //       )),
    //   PosColumn(
    //       text: 'Price(Ks)',
    //       width: 2,
    //       styles: const PosStyles(
    //         bold: true,
    //       )),
    //   PosColumn(
    //       text: 'Amount(Ks)',
    //       width: 3,
    //       styles: const PosStyles(
    //         bold: true,
    //       )),
    // ]);
    // ticket.hr(ch: '_');
    // for (var i = 0; i < invoiceLineListDB!.length; i++) {
    //   // total += widget.data[i]['total_price'];
    //   // ticket.text('Purchase Order');
    //   ticket.row([
    //     PosColumn(text: invoiceLineListDB![i].label, width: 5),
    //     PosColumn(text: invoiceLineListDB![i].quantity, width: 1),
    //     PosColumn(text: invoiceLineListDB![i].uomName, width: 1),
    //     PosColumn(text: invoiceLineListDB![i].unitPrice, width: 2),
    //     PosColumn(text: invoiceLineListDB![i].subTotal, width: 3),
    //   ]);
    // }
    // ticket.hr(ch: '_');
    // ticket.row([
    //   PosColumn(text: '', width: 4),
    //   PosColumn(text: 'Sub. Total', width: 4),
    //   PosColumn(text: '', width: 4),
    // ]);
    // ticket.row([
    //   PosColumn(text: '', width: 4),
    //   PosColumn(text: 'Tax@0%on', width: 4),
    //   PosColumn(text: '', width: 4),
    // ]);
    // ticket.row([
    //   PosColumn(text: '', width: 4),
    //   PosColumn(text: 'Advance', width: 4),
    //   PosColumn(text: '', width: 4),
    // ]);
    // ticket.row([
    //   PosColumn(text: '', width: 4),
    //   PosColumn(text: 'Discount', width: 4),
    //   PosColumn(text: '', width: 4),
    // ]);
    // ticket.row([
    //   PosColumn(text: '', width: 4),
    //   PosColumn(text: 'FOC Amount', width: 4),
    //   PosColumn(text: '', width: 4),
    // ]);
    // ticket.row([
    //   PosColumn(text: '', width: 4),
    //   PosColumn(text: 'Net Due Amount', width: 4),
    //   PosColumn(text: '', width: 4),
    // ]);
    // ticket.hr(ch: '_');
    // ticket.row([
    //   PosColumn(
    //       text: 'Notes:',
    //       width: 2,
    //       styles: const PosStyles(
    //         bold: true,
    //       )),
    //   PosColumn(
    //       text: 'Goods sold are neither returnable nor refundable.',
    //       width: 10,
    //       styles: const PosStyles(
    //         bold: true,
    //       )),
    // ]);
    // ticket.row([
    //   PosColumn(
    //       text: '',
    //       width: 2,
    //       styles: const PosStyles(
    //         bold: true,
    //       )),
    //   PosColumn(
    //       text:
    //           'Otherwise a cancelation fee of 20% on purchase price will be imposed.',
    //       width: 10,
    //       styles: const PosStyles(
    //         bold: true,
    //       )),
    // ]);
    ticket.feed(1);
    // ticket.image(_customerSign, align: PosAlign.left);
    // ticket.image(_authorSign, align: PosAlign.left);
    // ticket.image(mergetdImage);
    ticket.cut();

    return ticket;
  }

  @override
  void dispose() {
    _printerManager.stopScan();
    super.dispose();
  }
}
