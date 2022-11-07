import 'dart:async';

import 'package:odoo_api/odoo_api_connector.dart';
import '../../dbs/sharef.dart';
import '../../obs/response_ob.dart';
import '../../services/odoo.dart';
import '../../utils/app_const.dart';

class ProductBloc {
  StreamController<ResponseOb> productListStreamController =
      StreamController<ResponseOb>.broadcast();
  Stream<ResponseOb> getProductListStream() =>
      productListStreamController.stream; // ProductList Stream Controller

  late Odoo odoo;
  getProductListData({name}) {
    print('Enter get product list ===========>');
    ResponseOb responseOb = ResponseOb(msgState: MsgState.loading);
    productListStreamController.sink.add(responseOb);
    List<dynamic>? data;

    try {
      print('Try ==========>');
      Sharef.getOdooClientInstance().then((value) async {
        odoo = Odoo(BASEURL);
        odoo.setSessionId(value['session_id']);
        OdooResponse res = await odoo.searchRead(
            'product.template',
            [
              name,
              ['sale_ok', '=', true]
            ],
            [
              'id',
              'name',
              'product_code',
              'sale_ok',
              'purchase_ok',
              'image_1920',
              'list_price',
              'qty_available',
              'uom_id',
              'custom_category_id',
              'categ_id'
            ],
            order: 'name asc');
        if (res.getResult() != null) {
          print('ProductList Result:' + res.getResult()['records'].toString());
          data = res.getResult()['records'];
          responseOb.msgState = MsgState.data;
          responseOb.data = data;
          productListStreamController.sink.add(responseOb);
        } else {
          data = null;
          print('Get Product List Error:' + res.getErrorMessage().toString());
          responseOb.msgState = MsgState.error;
          responseOb.errState = ErrState.unKnownErr;
          productListStreamController.sink.add(responseOb);
        }
      });
    } catch (e) {
      print('catch =======>');
      if (e.toString().contains("SocketException")) {
        responseOb.data = "Internet Connection Error";
        responseOb.msgState = MsgState.error;
        responseOb.errState = ErrState.noConnection;
        productListStreamController.sink.add(responseOb);
      } else {
        responseOb.data = "Unknown Error";
        responseOb.msgState = MsgState.error;
        responseOb.errState = ErrState.unKnownErr;
        productListStreamController.sink.add(responseOb);
      }
    }
  }

  dispose() {
    productListStreamController.close();
  }
}
