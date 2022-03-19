class InvalidRequestException implements Exception {
  final String message;

  const InvalidRequestException({required this.message});
}
