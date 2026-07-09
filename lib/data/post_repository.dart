import '../domain/domain.dart';

abstract class PostRepository {
  Future<List<SmartPost>> fetchSmartPosts();
  Future<List<SharePlatform>> fetchSharePlatforms();
  Future<List<ShareStep>> fetchShareSteps();
  Future<List<ChecklistStep>> fetchChecklistSteps();
}
