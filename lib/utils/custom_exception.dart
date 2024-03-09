class CustomException implements Exception {
  const CustomException({required this.errorMessage});

  final String errorMessage;

  @override
  String toString() {
    return errorMessage;
  }
}