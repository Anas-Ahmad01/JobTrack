import '../models/saved_job.dart';
import '../services/firestore_service.dart';

class SavedJobsRepository {
  final FirestoreService _firestoreService;

  SavedJobsRepository(this._firestoreService);

  Future<void> saveJob(String userId, SavedJob savedJob) async {
    await _firestoreService.saveJob(userId, savedJob.toJson());
  }

  Future<void> removeSavedJob(String userId, String jobId) async {
    await _firestoreService.removeSavedJob(userId, jobId);
  }

  Stream<List<SavedJob>> getSavedJobs(String userId) {
    return _firestoreService.getSavedJobs(userId).map((list) {
      return list.map((json) => SavedJob.fromJson(json)).toList();
    });
  }

  Future<bool> isJobSaved(String userId, String jobId) async {
    // We'll use the stream for real-time, but this is useful for checks
    return true; // Placeholder - we'll handle this via stream
  }
}