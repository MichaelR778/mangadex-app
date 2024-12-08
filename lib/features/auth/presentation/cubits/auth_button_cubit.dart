import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangadex_app/features/auth/domain/auth_repo.dart';
import 'package:mangadex_app/features/auth/presentation/cubits/auth_button_state.dart';

class AuthButtonCubit extends Cubit<AuthButtonState> {
  final AuthRepo authRepo;

  AuthButtonCubit({required this.authRepo}) : super(AuthButtonInitial());

  Future<void> login(String email, String password) async {
    try {
      emit(AuthButtonLoading());
      await authRepo.login(email, password);
      emit(AuthButtonSuccess());
    } catch (e) {
      emit(AuthButtonError(message: e.toString()));
    }
  }

  Future<void> register(String email, String password) async {
    try {
      emit(AuthButtonLoading());
      await authRepo.register(email, password);
      emit(AuthButtonSuccess());
    } catch (e) {
      emit(AuthButtonError(message: e.toString()));
    }
  }
}
