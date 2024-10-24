import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idmall/models/payment_history_detail.dart';
import 'package:idmall/models/payment_method.dart';
import 'package:idmall/models/payment_transaction.dart';
import 'package:idmall/pages/invoice_testing.dart';
import 'package:idmall/service/payment.dart';

class PaymentController extends GetxController {
  final PaymentService paymentService = Get.put(PaymentService());

  //transaction detail
  Rx<PaymentTransaction> paymentDetail = PaymentTransaction(
    taskId: "",
    customerSubName: "",
    monthlyPrice: 0,
    subProduct: "",
    services: "",
    installation: 0,
    vat: 0,
    total: 0,
    payment: 0,
    arRemain: 0,
    arVal: 0,
    arPaid: 0,
    dueDate: "",
    invDate: "",
    ptp: "",
    bankAcc: "",
    subtotal: 0,
    materai: 0,
    ppn: 0,
    grandTotal: 0,
  ).obs;

  //payment history detail
  Rx<PaymentHistoryDetail> paymentHistoryDetail = PaymentHistoryDetail(
          taskId: "",
          customerSubName: "",
          monthlyPrice: 0,
          subProduct: "",
          services: "",
          installation: 0,
          caStatus: "",
          vat: 0,
          total: 0,
          payment: 0,
          arRemain: 0,
          arVal: 0,
          dueDate: "",
          invDate: "",
          arStatus: "",
          paymentDate: "",
          paymentMethod: "",
          subtotal: 0,
          materai: 0,
          ppn: 0,
          finalTotal: 0)
      .obs;

  //payment method bank
  RxList<PaymentMethodModel> paymentMethodBank = <PaymentMethodModel>[].obs;

  //loading indicator
  RxBool isLoading = false.obs;

  //get payment method
  Future<void> getPaymentMethod() async {
    try {
      isLoading(true);
      var result = await paymentService.getPaymentMethod();
      paymentMethodBank.value = result;
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch payment method");
    } finally {
      isLoading(false);
    }
  }

  //get payment detail transcation
  Future<void> getPaymentDetailTransaction(String taskid) async {
    try {
      isLoading(true);
      var result = await paymentService.getCart(taskid);
      paymentDetail.value = result;
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch payment detail");
    } finally {
      isLoading(false);
    }
  }

  //get detail payment history
  Future<void> getPaymentHistoryDetail(
    String taskid,
    String periode,
  ) async {
    try {
      isLoading(true);
      var result =
          await paymentService.getPaymentHistoryDetail(taskid, periode);
      paymentHistoryDetail.value = result;
    } catch (e) {
      Get.snackbar("Error", "Failed to get history payment detail");
    } finally {
      isLoading(false);
    }
  }

  //create transaction
  Future<void> createNewTransaction(
    String taskid,
    String bankCode,
    String paymentType,
    int total,
  ) async {
    try {
      isLoading(true);
      Get.defaultDialog(
        title: "Pembayaran",
        content: Text("Apakah Anda yakin untuk memilih metode pembayaran ini?"),
        confirm: ElevatedButton(
          onPressed: () async {
            var result = await paymentService.createTransaction(
              taskid,
              bankCode,
              paymentType,
              total,
            );

            if (result['status'] == 'success') {
              Get.to(
                () => InvoicePage(
                  taskid: taskid,
                  bankName: bankCode,
                  total: total.toString(),
                  typePayment: paymentType,
                  paymentCode: result['payment_code'],
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[400],
          ),
          child: Text("OK"),
        ),
        cancel: ElevatedButton(
          onPressed: () {
            Get.back();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red[300],
          ),
          child: Text("Cancel"),
        ),
        contentPadding: EdgeInsets.all(10.0),
        backgroundColor: Colors.white,
      );
    } catch (e) {
      Get.snackbar("Error", "Failed to create new transaction");
    } finally {
      isLoading(false);
    }
  }
}
