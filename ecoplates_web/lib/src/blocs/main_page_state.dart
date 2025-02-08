
import '../services/http_response/user_data_response.dart';

class MainPageState {
  bool isLoading;
  bool refreshWindow;
  UserDataResponse? userData;

  MainPageState({
    this.isLoading = false,
    this.refreshWindow = false,
    this.userData
  });

  MainPageState compyWith({
    bool? isLoading,
    bool? refreshWindow,
    UserDataResponse? userData
  }) {
    return MainPageState(
        isLoading: isLoading ?? this.isLoading,
        refreshWindow: refreshWindow ?? this.refreshWindow,
        userData: userData ?? this.userData
    );
  }
}