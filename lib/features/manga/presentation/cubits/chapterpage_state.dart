abstract class ChapterpageState {}

class ChapterpageLoading extends ChapterpageState {}

class ChapterpageLoaded extends ChapterpageState {
  final List<String> imageUrls;

  ChapterpageLoaded({required this.imageUrls});
}

class ChapterpageError extends ChapterpageState {
  final String message;

  ChapterpageError({required this.message});
}
