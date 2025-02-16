import '../model/admin_info.dart';
import '../model/company_info.dart';
import '../model/user_info.dart';
import '../services/http_response/company_data_response.dart';
import '../services/http_response/user_data_response.dart';

class MainPageState {
  bool isLoading;
  bool searchUserClicked;
  bool refreshWindow;
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
    int? pageOffset,
    UserInfo? searchUserData,
    CompanyInfo? searchCompanyData,
    UserDataResponse? userData,
    CompanyDataResponse? companyData,
    List<AdminInfo>? adminData
  }) {
    return MainPageState(
        isLoading: isLoading ?? this.isLoading,
        searchUserClicked: searchUserClicked ?? this.searchUserClicked,
        refreshWindow: refreshWindow ?? this.refreshWindow,
        pageOffset: pageOffset ?? this.pageOffset,
        searchUserData: searchUserData ?? this.searchUserData,
        searchCompanyData: searchCompanyData ?? this.searchCompanyData,
        userData: userData ?? this.userData,
        companyData: companyData ?? this.companyData,
        adminData: adminData ?? this.adminData
    );
  }
}