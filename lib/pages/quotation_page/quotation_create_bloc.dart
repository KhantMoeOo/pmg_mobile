import 'dart:async';

import 'package:odoo_api/odoo_api_connector.dart';
import 'package:odoo_api/odoo_user_response.dart';
import '../../dbs/sharef.dart';
import '../../obs/response_ob.dart';
import '../../services/odoo.dart';
import '../../utils/app_const.dart';

class QuotationCreateBloc {
  StreamController<ResponseOb> createNewStreamController =
      StreamController<ResponseOb>.broadcast();
  Stream<ResponseOb> getCreateNewStream() => createNewStreamController.stream;

  late Odoo odoo;

  quotationCreate(
      {customerId,
      currencyId,
      // exchangeRate,
      saleType,
      dateOrder,
      priceListId,
      paymentTermId,
      zoneId,
      segmentId,
      regionId,
      locationId,
      customFilter,
      zoneFilter,
      segFilter}) async {
    print('Create Quotation');
    ResponseOb responseOb = ResponseOb(msgState: MsgState.loading);
    createNewStreamController.sink.add(responseOb);
    try {
      print('Try');
      Sharef.getOdooClientInstance().then((value) async {
        odoo = Odoo(BASEURL);
        odoo.setSessionId(value['session_id']);
        OdooResponse res = await odoo.create('sale.order', {
          'partner_id': customerId,
          'currency_id': currencyId,
          // 'exchange_rate': exchangeRate,
          'sale_type': saleType,
          'date_order': dateOrder,
          'pricelist_id': priceListId,
          'payment_term_id': paymentTermId,
          'zone_id': zoneId,
          'segment_id': segmentId,
          // 'region_id': regionId,
          'location_id': locationId,
          'customer_filter': customFilter,
          'zone_filter_id': zoneFilter,
          'seg_filter_id': segFilter,
        });
        if (res.getResult() != null) {
          print('Createresult___________________-');
          print('Quo Create Result: ${res.getResult()}');
          responseOb.msgState = MsgState.data;
          responseOb.data = res.getResult();
          createNewStreamController.sink.add(responseOb);
        } else {
          print('Create error');
          print('GetCreateError:' + res.getErrorMessage().toString());
          responseOb.msgState = MsgState.error;
          responseOb.errState = ErrState.unKnownErr;
          createNewStreamController.sink.add(responseOb);
        }
      });
    } catch (e) {
      print('catch');
      if (e.toString().contains("SocketException")) {
        responseOb.data = "Internet Connection Error";
        responseOb.msgState = MsgState.error;
        responseOb.errState = ErrState.noConnection;
        createNewStreamController.sink.add(responseOb);
      } else {
        responseOb.data = "Unknown Error";
        responseOb.msgState = MsgState.error;
        responseOb.errState = ErrState.unKnownErr;
        createNewStreamController.sink.add(responseOb);
      }
    }
  }

  dispose() {
    createNewStreamController.close();
  }
}
