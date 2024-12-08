import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangadex_app/features/auth/domain/auth_repo.dart';
import 'package:mangadex_app/features/auth/presentation/cubits/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo authRepo;

  AuthCubit({required this.authRepo}) : super(AuthInitial()) {
    checkAuth();
  }

  void checkAuth() {
    final loggedIn = authRepo.loggedIn();
    if (loggedIn) {
      emit(Authenticated());
    } else {
      emit(Unauthenticated());
    }
  }

  void authenticate() => emit(Authenticated());

  void logout() {
    authRepo.logout();
    emit(Unauthenticated());
  }
}
