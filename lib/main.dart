import 'package:flutter/material.dart';
import 'package:schrodinger_client/accountbank.dart';
import 'package:schrodinger_client/budgetpage.dart';
import 'package:schrodinger_client/expensepage.dart';
import 'package:schrodinger_client/payment_methods.dart';
import 'package:schrodinger_client/spending_records.dart';
import 'package:schrodinger_client/income_category.dart';
import 'package:schrodinger_client/income_records.dart';
import 'package:schrodinger_client/expense_category_page.dart';
import 'package:schrodinger_client/income_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'main',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      initialRoute: '/',
      routes: {
        '/AccountBank': (context) => const AccountBank(),
        '/BudgetPage': (context)=> const BudgetPage(),
        '/ExpensePage': (context)=> const ExpensePage(),
        '/IncomePage': (context)=> const IncomePage(),
        '/expenseCategory' : (context) => const ExpenseCategoryPage(),
        '/paymentMethods' : (context) => const PaymentMethods(),
        '/spendingRecords' : (context) => const SpendingRecords(),
        '/incomeCategory': (context) => const IncomeCategory(),
        '/incomeRecords' : (context) => const IncomeRecords(),
      },
      home: AccountBank(),
    );
  }
}