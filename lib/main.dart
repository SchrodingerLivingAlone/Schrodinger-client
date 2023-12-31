import 'package:flutter/material.dart';
import 'package:schrodinger_client/account/accountbank.dart';

import 'package:schrodinger_client/account/budgetpage.dart';
import 'package:schrodinger_client/account/expense_category_page.dart';
import 'package:schrodinger_client/account/expensepage.dart';
import 'package:schrodinger_client/account/income_category.dart';
import 'package:schrodinger_client/account/income_page.dart';
import 'package:schrodinger_client/account/income_records.dart';
import 'package:schrodinger_client/account/payment_methods.dart';
import 'package:schrodinger_client/account/spending_records.dart';
import 'package:schrodinger_client/home.dart';
import 'package:schrodinger_client/login/join_page.dart';
import 'package:schrodinger_client/login/auth_page.dart';
import 'package:schrodinger_client/login/login_page.dart';
import 'package:schrodinger_client/login/splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schrodinger_client/mypage/manage_profile.dart';
import 'package:schrodinger_client/mypage/written_page.dart';
import 'package:schrodinger_client/post/post_page.dart';
import 'package:schrodinger_client/post/post_info.dart';
import 'package:schrodinger_client/style.dart';
import 'package:schrodinger_client/login/town_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:schrodinger_client/town_info/town_page.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:schrodinger_client/town_info/town_search.dart';

import 'mypage/Comment_Page.dart';
import 'mypage/Like_page.dart';
import 'mypage/mypage_town_auth.dart';

Future main() async {
  await dotenv.load(fileName: '.env');
  await initializeDateFormatting();
  runApp(
    const ProviderScope(
        child: MyApp()
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
        '/town/auth': (context) => const TownAuthPage(),
        '/town': (context) => const TownPage(),
        '/join': (context) => const JoinPage(),
        '/home': (context) => const HomePage(),
        '/town/search': (context) => const TownSearchPage(),
        '/ManageProfiles': (context) => const ManageProfiles(),
        '/WrittenPage': (context) => const WrittenPage(),
        '/LikePage': (context) => const LikePage(),
        '/CommentPage': (context) => const CommentPage(),
        '/Mypagetownauth' : (context) => const Mypagetownauth(),
      },
      home: const Splash(),
    );
  }
}