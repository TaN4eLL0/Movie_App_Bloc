import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:movieapp/domain/blocs/auth_bloc.dart';

enum LoaderViewCubitState { unknown, authorized, notAuthorized }

class LoaderViewCubit extends Cubit<LoaderViewCubitState> {
  final AuthBloc authBloc;
  late final StreamSubscription<AuthState> authBlocSubscription;

  LoaderViewCubit(
    LoaderViewCubitState initialState,
    this.authBloc,
  ) : super(initialState) {
    Future.microtask(
      () {
        _onState(authBloc.state);
        authBlocSubscription = authBloc.stream.listen(_onState);
        authBloc.add(AuthCheckStatusEvent());
      },
    );
  }

  void _onState(AuthState state) {
    if (state is AuthAuthorizedState) {
      emit(LoaderViewCubitState.authorized);
    } else if (state is AuthUnauthorizedState) {
      emit(LoaderViewCubitState.notAuthorized);
    }
  }

  @override
  Future<void> close() {
    authBlocSubscription.cancel();
    return super.close();
  }
}

// class LoaderViewModel {
//   final BuildContext context;
//   final _authService = AuthService();
//
//   LoaderViewModel(this.context) {
//     asyncInit();
//   }
//
//   Future<void> asyncInit() async {
//     await checkAuth();
//   }
//
//   Future<void> checkAuth() async {
//     final isAuth = await _authService.isAuth();
//     final nextScreen = isAuth
//         ? MainNavigationRouteNames.mainScreen
//         : MainNavigationRouteNames.auth;
//     Navigator.of(context).pushReplacementNamed(nextScreen);
//   }
// }
