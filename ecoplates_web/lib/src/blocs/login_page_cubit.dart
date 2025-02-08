
import 'package:ecoplates_web/src/blocs/login_page_state.dart';
import 'package:ecoplates_web/src/constant/admin_role.dart';
import 'package:ecoplates_web/src/constant/result.dart';
import 'package:ecoplates_web/src/model/admin_register_info.dart';
import 'package:ecoplates_web/src/services/data_provider/http_service_admin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/admin_login_info.dart';
import '../services/http_response/response_admin_login_info.dart';

class LoginPageCubit extends Cubit<LoginPageState>{
   LoginPageCubit() : super(LoginPageState());

   void setAdminRole({required AdminRole adminRole}) {
      emit(state.compyWith(adminRole: adminRole));
   }

   void setShowLoginWindow({required bool show}) {
      emit(state.compyWith(showLoginWindow: show));
   }

   void setShowLoading({required bool show}){
      emit(state.compyWith(isLoading: show));
   }

   Future<String> login({required String adminId, String? password}) async {
      if (adminId.isEmpty) {
         return "Admin ID cannot be empty.";
      }

      if (password == null || password.isEmpty) {
         return "Password cannot be empty.";
      }

      setShowLoading(show: true);

      try {
         AdminLoginInfo data = AdminLoginInfo(
            admin_id: adminId,
            password: password,
         );

         ResponseAdminLoginInfo? response = await HttpServiceAdmin.login(data: data);

         if (response != null && response.resultCode == Result.SUCCESS.codeAsString) {
            return response.resultMsg ?? "Login successful!";
         }
         else if(response != null){
            return response.resultMsg ?? "";
         }

         return "Unknown error occurred.";
      } catch (e) {
         print('Error during login: $e');
         return "Error during login.";
      } finally {
         setShowLoading(show: false);
      }
   }
}