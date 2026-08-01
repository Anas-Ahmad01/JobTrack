import '../models/job_application.dart';
import '../services/firestore_service.dart';

class ApplicationsRepository {
  final FirestoreService _firestoreService;

  ApplicationsRepository(this._firestoreService);

  Future<void> addApplication(String userId, JobApplication application) async {
    await _firestoreService.addApplication(userId, application.toJson());
  }

  Future<void> updateApplication(
    String userId,
    String applicationId,
    Map<String, dynamic> data,
  ) async {
    await _firestoreService.updateApplication(userId, applicationId, {
      ...data,
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  Future<void> deleteApplication(String userId, String applicationId) async {
    await _firestoreService.deleteApplication(userId, applicationId);
  }

  Stream<List<JobApplication>> getApplications(String userId) {
    return _firestoreService.getApplications(userId).map((list) {
      return list.map((json) => JobApplication.fromJson(json)).toList();
    });
  }

  Future<JobApplication?> getApplication(String userId, String applicationId) async {
    final data = await _firestoreService.getApplication(userId, applicationId);
    if (data == null) return null;
    return JobApplication.fromJson(data);
  }
}