
import 'package:ecoplates_web/src/blocs/main_page_state.dart';
import 'package:ecoplates_web/src/constant/user_or_company_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constant/constants.dart';
import '../constant/result.dart';
import '../model/admin_register_info.dart';
import '../model/change_user_deletion_status.dart';
import '../model/change_user_status.dart';
import '../model/pagination_info.dart';
import '../presentation/widgets/show_snack_bar.dart';
import '../services/data_provider/http_service_admin.dart';
import '../services/data_provider/http_service_company.dart';
import '../services/data_provider/http_service_user.dart';
import '../services/http_response/response_all_admin_info.dart';
import '../services/http_response/response_change_deletion_status.dart';
import '../services/http_response/response_change_user_status.dart';
import '../services/http_response/response_company_info.dart';
import '../services/http_response/response_info.dart';
import '../services/http_response/response_user_info.dart';

class MainPageCubit extends Cubit<MainPageState> {
  MainPageCubit() : super(MainPageState());

  void setShowLoading({required bool show}) {
    emit(state.copyWith(isLoading: show));
  }

  void setPageOffset({required int pageOffset}){
    emit(state.copyWith(pageOffset: pageOffset));
  }

  Future<void> fetchUserInfo() async {
    setShowLoading(show: true);
    try {
      Paginationinfo data = Paginationinfo(pageSize: Constants.PAGE_SIZE, offset: state.pageOffset);
      ResponseUserInfo? response = await HttpServiceUser.getUserInfo(
          data: data);

      if (response != null && response.resultData != null) {
        emit(state.copyWith(isLoading: false, userData: response.resultData, refreshWindow: true));
      } else {
        print('Failed to fetch user data: ${response?.resultMsg}');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
    finally {
      setShowLoading(show: false);
    }
  }

  Future<void> fetchCompanyInfo() async {
    setShowLoading(show: true);

    try{
      Paginationinfo data = Paginationinfo(pageSize: Constants.PAGE_SIZE, offset: state.pageOffset);
      ResponseCompanyInfo? response = await HttpServiceCompany.getUserInfo(
          data: data);

      if (response != null && response.resultData != null) {
        emit(state.copyWith(isLoading: false, companyData: response.resultData,  refreshWindow: true));
      } else {
        print('Failed to fetch user data: ${response?.resultMsg}');
      }
    }
    catch(e){
      print('Error fetching company data: $e');
    }
    finally {
      setShowLoading(show: false);
    }
  }

  Future<void> fetchAllAdminInfo() async {
    setShowLoading(show: true);

    try{
      ResponseAllAdminInfo? response = await HttpServiceAdmin.getAllAdmins();

      if (response != null && response.resultData != null) {
        emit(state.copyWith(isLoading: false, adminData: response.resultData,  refreshWindow: true));
      } else {
        print('Failed to fetch all admin data: ${response?.resultMsg}');
      }
    }
    catch(e){
      print('Error fetching all admin data: $e');
    }
    finally {
      setShowLoading(show: false);
    }
  }

  Future<void> changeUserStatus({required String phone, required UserOrCompanyStatus status}) async {
    setShowLoading(show: true);

    try {
      ChangeUserStatus data = ChangeUserStatus(
        phoneNumber: phone,
        status: status,
      );

      ResponseChangeUserStatus? response = await HttpServiceUser
          .changeUserStatus(data: data);

      if (response != null) {
        await fetchUserInfo();
      } else {
        print('Failed to update user status: ${response?.resultMsg}');
      }
    }
    catch (e) {
      print('Error changing user status: $e');
    }
    finally {
      setShowLoading(show: false);
    }
  }

  Future<void> changeCompanyStatus({required String phone, required UserOrCompanyStatus status}) async {
    setShowLoading(show: true);

    try {
      ChangeUserStatus data = ChangeUserStatus(
        phoneNumber: phone,
        status: status,
      );

      ResponseChangeUserStatus? response = await HttpServiceCompany
          .changeUserStatus(data: data);

      if (response != null) {
        await fetchCompanyInfo();
      } else {
        print('Failed to update company status: ${response?.resultMsg}');
      }
    }
    catch (e) {
      print('Error changing company status: $e');
    }
    finally {
      setShowLoading(show: false);
    }
  }

  Future<void> changeUserDeletionStatus({required String phone, required bool deleted}) async{
    setShowLoading(show: true);

    try{
      ChangeUserDeletionStatus data = ChangeUserDeletionStatus(
        phoneNumber: phone,
        deleted: deleted,
      );

      ResponseChangeUserDeletionStatus? response = await HttpServiceUser
          .changeUserDeletionStatus(data: data);

      if (response != null) {
        await fetchUserInfo();
      } else {
        print('Failed to update user deletion status: ${response
            ?.resultMsg}');
      }
    }
    catch(e){
      print('Error updating user deletion status: $e');
    }
    finally{
      setShowLoading(show: false);
    }
  }

  Future<void> changeCompanyDeletionStatus({required String phone, required bool deleted}) async{
    setShowLoading(show: true);

    try{
      ChangeUserDeletionStatus data = ChangeUserDeletionStatus(
        phoneNumber: phone,
        deleted: deleted,
      );

      ResponseChangeUserDeletionStatus? response = await HttpServiceCompany
          .changeUserDeletionStatus(data: data);

      if (response != null) {
        await fetchCompanyInfo();
      } else {
        print('Failed to update company deletion status: ${response
            ?.resultMsg}');
      }
    }
    catch(e){
      print('Error updating company deletion status: $e');
    }
    finally{
      setShowLoading(show: false);
    }
  }

  Future<String> addAdmin({required String adminId, required String password, required String admin_role}) async{
    setShowLoading(show: true);

    try{
      AdminRegisterInfo data = AdminRegisterInfo(
          admin_id: adminId,
          password: password,
          admin_role: admin_role
      );
      ResponseInfo? response = await HttpServiceAdmin.register(
          data: data);
      if (response != null) {
        if (response.resultCode == Result.SUCCESS.codeAsString) {
          await fetchAllAdminInfo();
          return response.resultMsg ?? "Operation successful";
        } else {
          return response.resultMsg ?? "Error: Operation failed";
        }
      } else {
        return "Error: No response from server";
      }
    }
    catch(e){
      return "An error occurred ${e}";
    }
    finally{
      setShowLoading(show: false);
    }
  }

  Future<String> deleteAdmin({required String adminId}) async {
    setShowLoading(show: true);

    try{
      ResponseInfo? response = await HttpServiceAdmin.deleteAdminById(
          adminId: adminId);

      if (response != null){
        await fetchAllAdminInfo();
        return response?.resultMsg ?? "";
      }
      else{
        return response?.resultMsg ?? "An error occurred";
      }
    }
    catch(e){
      return "An error occurred ${e}";
    }
    finally{
      setShowLoading(show: false);
    }
  }
}