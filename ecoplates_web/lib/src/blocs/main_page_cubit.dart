
import 'package:ecoplates_web/src/blocs/main_page_state.dart';
import 'package:ecoplates_web/src/constant/user_or_company_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/change_user_deletion_status.dart';
import '../model/change_user_status.dart';
import '../model/pagination_info.dart';
import '../services/data_provider/http_service_user.dart';
import '../services/http_response/response_change_deletion_status.dart';
import '../services/http_response/response_change_user_status.dart';
import '../services/http_response/response_user_info.dart';

class MainPageCubit extends Cubit<MainPageState> {
  MainPageCubit() : super(MainPageState());

  void setShowLoading({required bool show}) {
    emit(state.compyWith(isLoading: show));
  }

  Future<void> fetchUserInfo() async {
    setShowLoading(show: true);
    try {
      Paginationinfo data = Paginationinfo(pageSize: 10, offset: 0);
      ResponseUserInfo? response = await HttpServiceUser.getUserInfo(
          data: data);

      if (response != null && response.resultData != null) {
        emit(state.compyWith(isLoading: false, userData: response.resultData, refreshWindow: true));
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
}