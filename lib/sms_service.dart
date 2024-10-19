import 'package:sms_advanced/sms_advanced.dart';
// import 'database_helper.dart';

class SmsService {
  final List<Map<String, dynamic>> transactions = [];
  Future<List<Map<String, dynamic>>> readSms() async {
    SmsQuery query = SmsQuery();
    List<SmsMessage> messages = await query.getAllSms;

    // Process messages to extract UPI transactions
    for (var message in messages) {
      if (message.body != null && isUpiMessage(message.body!)) {
        extractTransaction(message.body!);
      }
    }
    return transactions;
  }

  // Improved UPI keyword detection to match various formats
  bool isUpiMessage(String message) {
    // Match different forms of UPI mentions: "@upi", ".upi", "_upi", etc.
    RegExp upiPattern = RegExp(r'\b\w+[@._]?upi\b', caseSensitive: false);
    return upiPattern.hasMatch(message);
  }

  // Extract transaction details from diverse message formats
  void extractTransaction(String message) {
    String? amount = extractAmount(message);
    if (amount != null) {
      transactions.add({
        'amount': double.parse(amount.replaceAll(',', '')), // Handle comma-separators
        'message': message,
      });
    }
  }

  // Improved amount extraction handling multiple currency formats
  String? extractAmount(String message) {
    // Match different amount formats like Rs, INR, ₹, etc.
    RegExp amountPattern = RegExp(
      r'(?:Rs\.?|INR|₹)\s?([\d,]+\.\d{2}|\d+)', // Supports "1,000.50" or "500"
      caseSensitive: false,
    );

    final match = amountPattern.firstMatch(message);
    return match?.group(1); // Extract the amount part
  }
}

