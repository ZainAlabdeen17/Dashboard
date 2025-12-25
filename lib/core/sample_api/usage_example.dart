import 'api_const.dart';
import 'api_method.dart';
import 'api_service.dart';

/// مثال بسيط على استخدام SimpleApiService
class UsageExample {
  final SimpleApiService _apiService = SimpleApiService.instance;

  /// مثال: جلب قائمة المستخدمين
  Future<void> fetchUsers() async {
    final result = await _apiService.makeRequest(
      method: ApiMethod.get,
      endpoint: ApiConst.users,
    );

    result.fold(
      (error) {
        print('Error: $error');
      },
      (data) {
        print('Success: $data');
        // data هنا هو Map أو List مباشرة من الـ API
        // بدون أي تحويل
      },
    );
  }

  /// مثال: جلب منشورات مع query parameters
  Future<void> fetchPosts({int? userId}) async {
    final result = await _apiService.makeRequest(
      method: ApiMethod.get,
      endpoint: ApiConst.posts,
      queryParams: userId != null ? {'userId': userId} : null,
    );

    result.fold(
      (error) => print('Error: $error'),
      (data) => print('Success: $data'),
    );
  }

  /// مثال: إنشاء منشور جديد
  Future<void> createPost() async {
    final result = await _apiService.makeRequest(
      method: ApiMethod.post,
      endpoint: ApiConst.posts,
      body: {
        'title': 'Test Post',
        'body': 'This is a test post',
        'userId': 1,
      },
    );

    result.fold(
      (error) => print('Error: $error'),
      (data) {
        print('Post created: $data');
        // data هنا هو الـ response مباشرة من الـ API
      },
    );
  }

  /// مثال: جلب التعليقات
  Future<void> getComments() async {
    final result = await _apiService.makeRequest(
      method: ApiMethod.get,
      endpoint: ApiConst.comments,
      queryParams: {'postId': 1},
    );

    result.fold(
      (error) => print('Error: $error'),
      (data) => print('Comments: $data'),
    );
  }

  /// مثال: تحديث منشور
  Future<void> updatePost(int postId) async {
    final result = await _apiService.makeRequest(
      method: ApiMethod.put,
      endpoint: '${ApiConst.posts}/$postId',
      body: {
        'title': 'Updated Post',
        'body': 'This post has been updated',
        'userId': 1,
      },
    );

    result.fold(
      (error) => print('Error: $error'),
      (data) => print('Post updated: $data'),
    );
  }

  /// مثال: حذف منشور
  Future<void> deletePost(int postId) async {
    final result = await _apiService.makeRequest(
      method: ApiMethod.delete,
      endpoint: '${ApiConst.posts}/$postId',
    );

    result.fold(
      (error) => print('Error: $error'),
      (data) => print('Post deleted successfully'),
    );
  }
}

