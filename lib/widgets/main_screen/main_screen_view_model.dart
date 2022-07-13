import 'package:flutter/cupertino.dart';
import 'package:movieapp/domain/data_providers/session_data_provider.dart';
import 'package:movieapp/navigation/main_navigation.dart';

class MainScreenViewModel extends ChangeNotifier {
  final _sessionDataProvider = SessionDataProvider();


  void logoutAccount(BuildContext context) {
    _sessionDataProvider.deleteSessionId();
    MainNavigation.resetNavigation(context);
  }
}