import 'dart:async';

import 'package:flutter/material.dart';
import 'package:odoo_api/odoo_api_connector.dart';
import '../../dbs/sharef.dart';
import '../../obs/response_ob.dart';
import '../../services/odoo.dart';
import '../../utils/app_const.dart';

class InvoiceEditBloc {
  StreamController<ResponseOb> updateInvoiceStatusStreamController =
      StreamController<ResponseOb>.broadcast();
  Stream<ResponseOb> getUpdateQuotationStatusStream() =>
      updateInvoiceStatusStreamController
          .stream; //updateQuotationStatusStreamController

  StreamController<ResponseOb> callactionpostStreamController =
      StreamController<ResponseOb>.broadcast();
  Stream<ResponseOb> getCallActionPostStream() =>
      callactionpostStreamController.stream; //callactionpostStreamController

  StreamController<ResponseOb> uploadSignatureStreamController =
      StreamController<ResponseOb>.broadcast();
  Stream<ResponseOb> getUploadSignatureStream() =>
      uploadSignatureStreamController.stream; //uploadSignatureStreamController

  late Odoo odoo;

  updateInvoiceStatusData(ids, state) {
    print('EnterupdatInvoiceStatusData');
    ResponseOb responseOb = ResponseOb(msgState: MsgState.loading);
    updateInvoiceStatusStreamController.sink.add(responseOb);

    try {
      print('Try');
      Sharef.getOdooClientInstance().then((value) async {
        odoo = Odoo(BASEURL);
        odoo.setSessionId(value['session_id']);
        OdooResponse res =
            await odoo.write('account.move', [ids], {'state': state});
        if (res.getResult() != null) {
          print('result');
          responseOb.msgState = MsgState.data;
          responseOb.data = res.getResult();
          updateInvoiceStatusStreamController.sink.add(responseOb);
        } else {
          print('updatInvoiceStatusError:' + res.getErrorMessage().toString());
          responseOb.msgState = MsgState.error;
          responseOb.errState = ErrState.unKnownErr;
          updateInvoiceStatusStreamController.sink.add(responseOb);
        }
      });
    } catch (e) {
      print('catch');
      if (e.toString().contains("SocketException")) {
        responseOb.data = "Internet Connection Error";
        responseOb.msgState = MsgState.error;
        responseOb.errState = ErrState.noConnection;
        updateInvoiceStatusStreamController.sink.add(responseOb);
      } else {
        responseOb.data = "Unknown Error";
        responseOb.msgState = MsgState.error;
        responseOb.errState = ErrState.unKnownErr;
        updateInvoiceStatusStreamController.sink.add(responseOb);
      }
    }
  } // updatInvoiceStatus Data

  callactionpost(ids, signature) {
    print('Entercallactionpost');
    ResponseOb responseOb = ResponseOb(msgState: MsgState.loading);
    callactionpostStreamController.sink.add(responseOb);

    try {
      print('Try');
      Sharef.getOdooClientInstance().then((value) async {
        odoo = Odoo(BASEURL);
        odoo.setSessionId(value['session_id']);
        OdooResponse res =
            await odoo.callKW('account.move', 'action_post', [ids]);
        // OdooResponse image =
        //     await odoo.write('sale.order', [ids], {'signature': signature});
        // print('Write Image to ________________ ${image.getResult()}');
        if (res.getResult() != null) {
          print('callactionpostresult');
          responseOb.msgState = MsgState.data;
          responseOb.data = res.getResult();
          callactionpostStreamController.sink.add(responseOb);
        } else {
          print('callactionpostError:' + res.getErrorMessage().toString());
          responseOb.msgState = MsgState.error;
          responseOb.errState = ErrState.unKnownErr;
          callactionpostStreamController.sink.add(responseOb);
        }
      });
    } catch (e) {
      print('catch');
      if (e.toString().contains("SocketException")) {
        responseOb.data = "Internet Connection Error";
        responseOb.msgState = MsgState.error;
        responseOb.errState = ErrState.noConnection;
        callactionpostStreamController.sink.add(responseOb);
      } else {
        responseOb.data = "Unknown Error";
        responseOb.msgState = MsgState.error;
        responseOb.errState = ErrState.unKnownErr;
        callactionpostStreamController.sink.add(responseOb);
      }
    }
  } // callactionpost

  uploadSignature(ids, signature) {
    print('Upload Signature Image');
    ResponseOb responseOb = ResponseOb(msgState: MsgState.loading);
    uploadSignatureStreamController.sink.add(responseOb);

    try {
      print('Try');
      Sharef.getOdooClientInstance().then((value) async {
        odoo = Odoo(BASEURL);
        odoo.setSessionId(value['session_id']);
        OdooResponse res =
            await odoo.write('sale.order', [ids], {'signature': signature});
        print('Write Image to ________________ ${res.getResult()}');
        if (res.getResult() != null) {
          print('upload image');
          responseOb.msgState = MsgState.data;
          responseOb.data = res.getResult();
          uploadSignatureStreamController.sink.add(responseOb);
        } else {
          print('upload image error :' + res.getErrorMessage().toString());
          responseOb.msgState = MsgState.error;
          responseOb.errState = ErrState.unKnownErr;
          uploadSignatureStreamController.sink.add(responseOb);
        }
      });
    } catch (e) {
      print('catch');
      if (e.toString().contains("SocketException")) {
        responseOb.data = "Internet Connection Error";
        responseOb.msgState = MsgState.error;
        responseOb.errState = ErrState.noConnection;
        uploadSignatureStreamController.sink.add(responseOb);
      } else {
        responseOb.data = "Unknown Error";
        responseOb.msgState = MsgState.error;
        responseOb.errState = ErrState.unKnownErr;
        uploadSignatureStreamController.sink.add(responseOb);
      }
    }
  }

  dispose() {
    updateInvoiceStatusStreamController.close();
    callactionpostStreamController.close();
    uploadSignatureStreamController.close();
  }
}
