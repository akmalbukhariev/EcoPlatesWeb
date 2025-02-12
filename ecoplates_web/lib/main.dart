import 'package:ecoplates_web/src/blocs/login_page_cubit.dart';
import 'package:ecoplates_web/src/blocs/main_page_cubit.dart';
import 'package:ecoplates_web/src/presentation/pages/admin_option_page.dart';
import 'package:ecoplates_web/src/presentation/pages/main_dashboard_page.dart';
import 'package:ecoplates_web/src/services/data_provider/http_service_admin.dart';
import 'package:ecoplates_web/src/services/data_provider/http_service_company.dart';
import 'package:ecoplates_web/src/services/data_provider/http_service_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const AdminPage());
}

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers:[
          RepositoryProvider<HttpServiceAdmin>(
              create: (context) => HttpServiceAdmin(),
          ),
          RepositoryProvider<HttpServiceUser>(
            create: (context) => HttpServiceUser(),
          ),
          RepositoryProvider<HttpServiceCompany>(
            create: (context) => HttpServiceCompany(),
          )
        ],
        child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => LoginPageCubit(
                  httpServiceAdmin: context.read<HttpServiceAdmin>(),
                ),
              ),
              BlocProvider(
                create: (context) => MainPageCubit(
                  httpServiceAdmin: context.read<HttpServiceAdmin>(),
                  httpServiceUser: context.read<HttpServiceUser>(),
                  httpServiceCompany: context.read<HttpServiceCompany>(),
                ),
              ),
            ],
            child: MaterialApp(
              routes: {
                '/': (context) => const AdminOptionPage(),
                '/dashboard': (context) => const MainDashboardPage(),
              },
            )
        )
    );
  }
}