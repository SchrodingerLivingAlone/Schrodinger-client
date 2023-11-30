import 'package:flutter/material.dart';
import 'package:schrodinger_client/accountbank.dart';
import 'package:schrodinger_client/budgetpage.dart';
import 'package:schrodinger_client/expensepage.dart';
import 'package:schrodinger_client/login/join_page.dart';
import 'package:schrodinger_client/payment_methods.dart';
import 'package:schrodinger_client/spending_records.dart';
import 'package:schrodinger_client/income_category.dart';
import 'package:schrodinger_client/income_records.dart';
import 'package:schrodinger_client/expense_category_page.dart';
import 'package:schrodinger_client/income_page.dart';
import 'package:schrodinger_client/login/auth_page.dart';
import 'package:schrodinger_client/login/login_page.dart';
import 'package:schrodinger_client/login/splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schrodinger_client/town_info/facility_info.dart';
import 'package:schrodinger_client/town_info/food_info.dart';
import 'package:schrodinger_client/town_info/home_info.dart';
import 'package:schrodinger_client/post/post_page.dart';
import 'package:schrodinger_client/post/post_info.dart';
import 'package:schrodinger_client/style.dart';
import 'package:schrodinger_client/login/town_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:schrodinger_client/town_info/town_page.dart';

Future main() async {
  await dotenv.load(fileName: '.env');
  runApp(
    ProviderScope(
        child: const MyApp()
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'main',
      theme: ThemeData(
        primaryColor: AppColor.main,
        primarySwatch: Colors.deepPurple,
      ),
      initialRoute: '/',
      routes: {
        '/AccountBank': (context) => const AccountBank(),
        '/BudgetPage': (context) => const BudgetPage(),
        '/ExpensePage': (context) => const ExpensePage(),
        '/IncomePage': (context) => const IncomePage(),
        '/expenseCategory': (context) => const ExpenseCategoryPage(),
        '/paymentMethods': (context) => const PaymentMethods(),
        '/spendingRecords': (context) => const SpendingRecords(),
        '/incomeCategory': (context) => const IncomeCategory(),
        '/incomeRecords': (context) => const IncomeRecords(),
        '/authPage': (context) => const AuthPage(),
        '/loginPage': (context) => const LoginPage(),
        '/splash': (context) => const Splash(),
        '/post': (context) => const PostPage(),
        '/post_info': (context) => const PostInfo(),
        '/town/auth': (context) => const TownAuthPage(),
        '/town': (context) => const TownPage(),
        '/join': (context) => const JoinPage()
      },
      home: Splash(),
    );
  }
}
