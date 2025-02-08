import 'package:ecoplates_web/src/blocs/login_page_cubit.dart';
import 'package:ecoplates_web/src/presentation/pages/admin_option_page.dart';
import 'package:ecoplates_web/src/presentation/pages/main_dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const AdminPage());
}

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => LoginPageCubit(),
          )
        ],
        child: MaterialApp(
          routes: {
            '/': (context) => AdminOptionPage(),
            '/dashboard': (context) => MainDashboardPage(),
          },
        )
    );
  }
}