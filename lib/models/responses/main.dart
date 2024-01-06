class Response<T> {
  final int code;
  final String message;
  final T response;

  const Response({
    required this.code,
    required this.message,
    required this.response,
  });
}