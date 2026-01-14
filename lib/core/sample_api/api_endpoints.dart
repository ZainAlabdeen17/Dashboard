class ApiEndpoint {
  final String path;

  const ApiEndpoint(this.path);

  static const ApiEndpoint users = ApiEndpoint('users');
}
