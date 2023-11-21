import 'package:flutter/material.dart';
import 'package:schrodinger_client/payment_methods.dart';
import 'package:schrodinger_client/spending_records.dart';
import 'package:schrodinger_client/income_category.dart';
import 'package:schrodinger_client/income_records.dart';
import 'package:schrodinger_client/expense_category_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/expenseCategory',
      routes: {
        '/expenseCategory': (context) => const ExpenseCategoryPage(),
        '/paymentMethods': (context) => const PaymentMethods(),
        '/spendingRecords': (context) => const SpendingRecords(),
        '/incomeCategory': (context) => const IncomeCategory(),
        '/incomeRecords': (context) => const IncomeRecords()
      },
    );
  }
}