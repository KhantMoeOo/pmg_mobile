import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../../../obs/response_ob.dart';
import '../../../utils/app_const.dart';
import '../invoice_bloc.dart';

class RegisterPaymentPage extends StatefulWidget {
  const RegisterPaymentPage({Key? key}) : super(key: key);

  @override
  State<RegisterPaymentPage> createState() => _RegisterPaymentPageState();
}

class _RegisterPaymentPageState extends State<RegisterPaymentPage> {
  final invoiceBloc = InvoiceBloc();
  List<dynamic> accountjournalList = [];
  List<dynamic> accountjournalListUpdate = [];
  bool hasAccountJournalData = false;
  bool hasNotAccountJournal = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    invoiceBloc.getAccountJournalData(['id', 'ilike', '']);
    invoiceBloc.getAccountJournalStream().listen(getAccountJournalListen);
  }

  void getAccountJournalListen(ResponseOb responseOb) {
    if (responseOb.msgState == MsgState.data) {
      setState(() {
        accountjournalList = responseOb.data;
        hasAccountJournalData = true;
        if (accountjournalList.isNotEmpty) {
          for (var ajL in accountjournalList) {
            if (ajL['type'] == 'bank' || ajL['type'] == 'cash') {
              accountjournalListUpdate.add(ajL);
            }
          }
        }
        print('accountjournalListUpdate: $accountjournalListUpdate');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
            backgroundColor: AppColors.appBarColor,
            title: const Text('Register Payment')),
        body: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Type:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Container(
                          color: Colors.white,
                          height: 40,
                          child: StreamBuilder<ResponseOb>(
                              initialData: hasAccountJournalData == false
                                  ? ResponseOb(msgState: MsgState.loading)
                                  : null,
                              stream: invoiceBloc.getAccountJournalStream(),
                              builder: (context,
                                  AsyncSnapshot<ResponseOb> snapshot) {
                                ResponseOb? responseOb = snapshot.data;
                                if (responseOb?.msgState == MsgState.loading) {
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
                                } else if (responseOb?.msgState ==
                                    MsgState.error) {
                                  return const Center(
                                    child: Text("Something went Wrong!"),
                                  );
                                } else {
                                  return DropdownSearch<String>(
                                    popupItemBuilder:
                                        (context, item, isSelected) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(item.toString().split(',')[1]),
                                            const Divider(),
                                          ],
                                        ),
                                      );
                                    },
                                    autoValidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please select Customer Name';
                                      }
                                      return null;
                                    },
                                    //showSearchBox: true,
                                    showSelectedItems: true,
                                    //showClearButton: !hasNotAccountJournal,
                                    items: accountjournalListUpdate.map((e) {
                                      return '${e['id']},${e['name']} (MMK)';
                                    }).toList(),
                                    //onChanged: getCustomerId,
                                    //selectedItem: customerName,
                                  );
                                }
                              }),
                        ),
                      ]),
                ),
              ],
            )
          ],
        ));
  }
}
