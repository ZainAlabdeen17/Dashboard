class ApiEndpoint {
  final String path;

  const ApiEndpoint(this.path);

  static const ApiEndpoint users = ApiEndpoint('users');
  static const ApiEndpoint posts = ApiEndpoint('posts');
  static const ApiEndpoint comments = ApiEndpoint('comments');
}
