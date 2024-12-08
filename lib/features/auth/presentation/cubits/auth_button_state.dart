abstract class AuthButtonState {}

class AuthButtonInitial extends AuthButtonState {}

class AuthButtonLoading extends AuthButtonState {}

class AuthButtonError extends AuthButtonState {
  final String message;

  AuthButtonError({required this.message});
}

class AuthButtonSuccess extends AuthButtonState {}
