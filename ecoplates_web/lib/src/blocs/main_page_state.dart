import '../model/admin_info.dart';
import '../model/company_info.dart';
import '../model/user_info.dart';
import '../services/http_response/company_data_response.dart';
import '../services/http_response/user_data_response.dart';

class MainPageState {
  bool isLoading;
  bool searchUserClicked;
  bool refreshWindow;
  bool showAlertBox;
  int pageOffset;
  UserInfo? searchUserData;
  CompanyInfo? searchCompanyData;
  UserDataResponse? userData;
  CompanyDataResponse? companyData;
  List<AdminInfo>? adminData;

  MainPageState({
    this.isLoading = false,
    this.searchUserClicked = true,
    this.refreshWindow = false,
    this.showAlertBox = false,
    this.pageOffset = 1,
    this.searchUserData,
    this.searchCompanyData,
    this.userData,
    this.companyData,
    this.adminData
  });

  MainPageState copyWith({
    bool? isLoading,
    bool? searchUserClicked,
    bool? refreshWindow,
    bool? showAlertBox,
    int? pageOffset,
    Object? searchUserData = _unset,
    Object? searchCompanyData = _unset,
    Object? userData = _unset,
    Object? companyData = _unset,
    Object? adminData = _unset,
  }) {
    return MainPageState(
      isLoading: isLoading ?? this.isLoading,
      searchUserClicked: searchUserClicked ?? this.searchUserClicked,
      refreshWindow: refreshWindow ?? this.refreshWindow,
      showAlertBox: showAlertBox ?? this.showAlertBox,
      pageOffset: pageOffset ?? this.pageOffset,
      searchUserData: searchUserData == _unset ? this.searchUserData : searchUserData as UserInfo?,
      searchCompanyData: searchCompanyData == _unset ? this.searchCompanyData : searchCompanyData as CompanyInfo?,
      userData: userData == _unset ? this.userData : userData as UserDataResponse?,
      companyData: companyData == _unset ? this.companyData : companyData as CompanyDataResponse?,
      adminData: adminData == _unset ? this.adminData : adminData as List<AdminInfo>?,
    );
  }

  static const _unset = Object();
}