import '../domain/domain.dart';

abstract class PostRepository {
  List<SmartPost> fetchSmartPosts();
  List<SharePlatform> fetchSharePlatforms();
  List<ShareStep> fetchShareSteps();
  List<ChecklistStep> fetchChecklistSteps();
}
