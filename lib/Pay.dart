import 'package:upi_pay/upi_pay.dart';

class Pay {
  String response = "";

  void payment(
      String upiid, String amount, String username, String upiPlatform) async {
    // Directly pass details to UpiPay.initiateTransaction
    try {
      Future<UpiTransactionResponse> initiateTransaction;
      (
        // Transaction,
        // final UpiResponse response = await UpiPay.initiateTransaction(
        app: upiPlatform,
        payeeAddress: upiid,
        payeeName: username,
        transactionRefId: '9e543J979m9',
        paymentNote: 'Paid with Voice Coin',
        // currency: UpiCurrency.INR,
        // Other optional parameters like merchant code if applicable
      );
      this.response = response.toString();
      print("Response = " + response.toString());
    } catch (e) {
      // Handle errors appropriately
      print("Error: $e");
    }
  }
}
