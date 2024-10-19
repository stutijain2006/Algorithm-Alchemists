import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:readsms/readsms.dart';
import 'sms_service.dart';

void main() {
  runApp(FinanceTrackerApp());
}

class FinanceTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SmsSummaryScreen(),
    );
  }
}

class SmsSummaryScreen extends StatefulWidget {
  @override
  _SmsSummaryScreenState createState() => _SmsSummaryScreenState();
}

class _SmsSummaryScreenState extends State<SmsSummaryScreen> {
  final SmsService _smsService = SmsService();
  List<Map<String, dynamic>> _transactions = [];

  Future<void> _loadTransactions() async {
    var transactions = await _smsService.readSms();
    setState(() {
      _transactions = transactions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Finance Tracker'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _loadTransactions,
            child: Text('Read SMS'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                final transaction = _transactions[index];
                return ListTile(
                  title: Text('Amount: Rs. ${transaction['amount']}'),
                  subtitle: Text(transaction['message']),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
