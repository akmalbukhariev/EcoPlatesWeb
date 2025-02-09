
import '../model/admin_info.dart';
import '../services/http_response/company_data_response.dart';
import '../services/http_response/user_data_response.dart';

class MainPageState {
  bool isLoading;
  bool refreshWindow;
  int pageOffset;
  UserDataResponse? userData;
  CompanyDataResponse? companyData;
  List<AdminInfo>? adminData;

  MainPageState({
    this.isLoading = false,
    this.refreshWindow = false,
    this.pageOffset = 1,
    this.userData,
    this.companyData,
    this.adminData
  });

  MainPageState copyWith({
    bool? isLoading,
    bool? refreshWindow,
    int? pageOffset,
    UserDataResponse? userData,
    CompanyDataResponse? companyData,
    List<AdminInfo>? adminData
  }) {
    return MainPageState(
        isLoading: isLoading ?? this.isLoading,
        refreshWindow: refreshWindow ?? this.refreshWindow,
        pageOffset: pageOffset ?? this.pageOffset,
        userData: userData ?? this.userData,
        companyData: companyData ?? this.companyData,
        adminData: adminData ?? this.adminData
    );
  }
}