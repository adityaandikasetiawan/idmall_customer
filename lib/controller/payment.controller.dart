import 'package:get/get.dart';
import 'package:idmall/models/payment_method.dart';
import 'package:idmall/models/payment_transaction.dart';
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
          grandTotal: 0)
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

  //create transaction
  Future<void> createNewTransaction(
    String taskid,
    String bankCode,
    String paymentType,
    int total,
  ) async {
    try {
      isLoading(true);
      var result = await paymentService.createTransaction(
        taskid,
        bankCode,
        paymentType,
        total,
      );
    } catch (e) {
      Get.snackbar("Erro", "Failed to create new transaction");
    } finally {
      isLoading(false);
    }
  }
}
