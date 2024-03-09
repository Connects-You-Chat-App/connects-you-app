class Response<T> {

  const Response({
    required this.code,
    required this.message,
    required this.response,
  });
  final int code;
  final String message;
  final T response;
}