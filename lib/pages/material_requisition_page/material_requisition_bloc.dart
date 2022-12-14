import 'dart:async';

import 'package:odoo_api/odoo_api_connector.dart';
import '../../dbs/sharef.dart';
import '../../obs/response_ob.dart';
import '../../services/odoo.dart';
import '../../utils/app_const.dart';

class MaterialRequisitionBloc {
  StreamController<ResponseOb> materialrequisitionListStreamController =
      StreamController<ResponseOb>.broadcast();
  Stream<ResponseOb> getMaterialRequisitionListStream() =>
      materialrequisitionListStreamController
          .stream; // Material Requisiton List Stream Controller

  StreamController<ResponseOb> materialrequisitionListWithIdStreamController =
      StreamController<ResponseOb>.broadcast();
  Stream<ResponseOb> getMaterialRequisitionListWithIdStream() =>
      materialrequisitionListWithIdStreamController
          .stream; // Material Requisiton List With Id Stream Controller

  StreamController<ResponseOb> stocklocationStreamController =
      StreamController<ResponseOb>.broadcast();
  Stream<ResponseOb> getStockLocationListStream() =>
      stocklocationStreamController
          .stream; // Stock Location List With Id Stream Controller

  late Odoo odoo;

  getMaterialRequisitionListData(name, filter) {
    print('EntergetMaterialRequisitionListData');
    ResponseOb responseOb = ResponseOb(msgState: MsgState.loading);
    materialrequisitionListStreamController.sink.add(responseOb);
    List<dynamic>? data;

    try {
      print('Try');
      Sharef.getOdooClientInstance().then((value) async {
        odoo = Odoo(BASEURL);
        odoo.setSessionId(value['session_id']);
        OdooResponse res = await odoo.searchRead(
            'purchase.requisition',
            [
              // name,
              filter,
              // ['multi_config', '=', 'sale']
            ],
            [
              'id',
              // 'name',
              // 'zone_id',
              'state',
              // 'multi_config',
              'request_person_id',
              'department_id',
              'order_date',
              'required_date',
              // 'desc',
            ],
            order: 'id desc');
        if (res.getResult() != null) {
          print('result');
          print('MaterialRequisitionResult:' +
              res.getResult()['records'].toString());
          data = res.getResult()['records'];
          responseOb.msgState = MsgState.data;
          responseOb.data = data;
          materialrequisitionListStreamController.sink.add(responseOb);
        } else {
          print('error');
          data = null;
          print('GetMaterialRequisitionError:' +
              res.getErrorMessage().toString());
          responseOb.msgState = MsgState.error;
          responseOb.errState = ErrState.unKnownErr;
          materialrequisitionListStreamController.sink.add(responseOb);
        }
      });
    } catch (e) {
      print('catch');
      if (e.toString().contains("SocketException")) {
        responseOb.data = "Internet Connection Error";
        responseOb.msgState = MsgState.error;
        responseOb.errState = ErrState.noConnection;
        materialrequisitionListStreamController.sink.add(responseOb);
      } else {
        responseOb.data = "Unknown Error";
        responseOb.msgState = MsgState.error;
        responseOb.errState = ErrState.unKnownErr;
        materialrequisitionListStreamController.sink.add(responseOb);
      }
    }
  }

  getMaterialRequisitionListWithIdData(id) {
    print('EntergetMaterialRequisitionListWithidData');
    ResponseOb responseOb = ResponseOb(msgState: MsgState.loading);
    materialrequisitionListWithIdStreamController.sink.add(responseOb);
    List<dynamic>? data;

    try {
      print('Try');
      Sharef.getOdooClientInstance().then((value) async {
        odoo = Odoo(BASEURL);
        odoo.setSessionId(value['session_id']);
        OdooResponse res = await odoo.searchRead(
            'purchase.requisition',
            [
              id,
            ],
            [
              'id',
              // 'name',
              // 'ref_no',
              // 'mr_count',
              // 'zone_id',
              // 'multi_config',
              'request_person_id',
              'department_id',
              'location_id',
              // 'invoice_id',
              'priority',
              'order_date',
              'required_date',
              'state',
              // 'desc',
            ],
            order: 'id desc');
        if (res.getResult() != null) {
          print('result');
          print('MaterialRequisitionWithIdResult:' +
              res.getResult()['records'].toString());
          data = res.getResult()['records'];
          responseOb.msgState = MsgState.data;
          responseOb.data = data;
          materialrequisitionListWithIdStreamController.sink.add(responseOb);
        } else {
          print('error');
          data = null;
          print('GetMaterialRequisitionWithIdError:' +
              res.getErrorMessage().toString());
          responseOb.msgState = MsgState.error;
          responseOb.errState = ErrState.unKnownErr;
          materialrequisitionListWithIdStreamController.sink.add(responseOb);
        }
      });
    } catch (e) {
      print('catch');
      if (e.toString().contains("SocketException")) {
        responseOb.data = "Internet Connection Error";
        responseOb.msgState = MsgState.error;
        responseOb.errState = ErrState.noConnection;
        materialrequisitionListWithIdStreamController.sink.add(responseOb);
      } else {
        responseOb.data = "Unknown Error";
        responseOb.msgState = MsgState.error;
        responseOb.errState = ErrState.unKnownErr;
        materialrequisitionListWithIdStreamController.sink.add(responseOb);
      }
    }
  } // materialrequisitionListWithId

  getStockLocationList() {
    print('EntergetStockLocation');
    ResponseOb responseOb = ResponseOb(msgState: MsgState.loading);
    stocklocationStreamController.sink.add(responseOb);
    List<dynamic>? data;

    try {
      print('Try');
      Sharef.getOdooClientInstance().then((value) async {
        odoo = Odoo(BASEURL);
        odoo.setSessionId(value['session_id']);
        OdooResponse res = await odoo.searchRead(
            'stock.location',
            [],
            [
              'id',
              'name',
            ],
            order: 'name asc');
        if (res.getResult() != null) {
          print('result');
          print('StockLocationResult:' + res.getResult()['records'].toString());
          data = res.getResult()['records'];
          responseOb.msgState = MsgState.data;
          responseOb.data = data;
          stocklocationStreamController.sink.add(responseOb);
        } else {
          print('error');
          data = null;
          print('GetStockLocationError:' + res.getErrorMessage().toString());
          responseOb.msgState = MsgState.error;
          responseOb.errState = ErrState.unKnownErr;
          stocklocationStreamController.sink.add(responseOb);
        }
      });
    } catch (e) {
      print('catch');
      if (e.toString().contains("SocketException")) {
        responseOb.data = "Internet Connection Error";
        responseOb.msgState = MsgState.error;
        responseOb.errState = ErrState.noConnection;
        stocklocationStreamController.sink.add(responseOb);
      } else {
        responseOb.data = "Unknown Error";
        responseOb.msgState = MsgState.error;
        responseOb.errState = ErrState.unKnownErr;
        stocklocationStreamController.sink.add(responseOb);
      }
    }
  } // StockLocation

  dispose() {
    materialrequisitionListStreamController.close();
    materialrequisitionListWithIdStreamController.close();
    stocklocationStreamController.close();
  }
}
