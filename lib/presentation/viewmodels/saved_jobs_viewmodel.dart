import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/job.dart';
import '../../data/models/saved_job.dart';
import '../../data/repositories/saved_jobs_repository.dart';
import '../../data/services/firestore_service.dart';
import 'auth_viewmodel.dart';

// Repository provider
final savedJobsRepositoryProvider = Provider((ref) {
  return SavedJobsRepository(ref.watch(firestoreServiceProvider));
});

// Saved jobs state
class SavedJobsState {
  final List<SavedJob> savedJobs;
  final bool isLoading;
  final String? error;
  final Set<String> savingJobIds; // Track which jobs are being saved

  const SavedJobsState({
    this.savedJobs = const [],
    this.isLoading = false,
    this.error,
    this.savingJobIds = const {},
  });

  SavedJobsState copyWith({
    List<SavedJob>? savedJobs,
    bool? isLoading,
    String? error,
    Set<String>? savingJobIds,
  }) {
    return SavedJobsState(
      savedJobs: savedJobs ?? this.savedJobs,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      savingJobIds: savingJobIds ?? this.savingJobIds,
    );
  }

  bool isJobSaved(String jobId) {
    return savedJobs.any((sj) => sj.jobId == jobId);
  }
}

class SavedJobsViewModel extends StateNotifier<SavedJobsState> {
  final SavedJobsRepository _repository;
  final String? _userId;

  SavedJobsViewModel(this._repository, this._userId) : super(const SavedJobsState()) {
    if (_userId != null) {
      _loadSavedJobs();
    }
  }

  void _loadSavedJobs() {
    state = state.copyWith(isLoading: true, error: null);
    
    _repository.getSavedJobs(_userId!).listen(
      (jobs) {
        state = state.copyWith(savedJobs: jobs, isLoading: false);
      },
      onError: (e) {
        state = state.copyWith(error: e.toString(), isLoading: false);
      },
    );
  }

  Future<void> toggleSaveJob(Job job) async {
    if (_userId == null) return;

    final isSaved = state.isJobSaved(job.id);
    
    // Optimistic UI - add to saving set
    state = state.copyWith(
      savingJobIds: {...state.savingJobIds, job.id},
    );

    try {
      if (isSaved) {
        // Remove
        final savedJob = state.savedJobs.firstWhere((sj) => sj.jobId == job.id);
        await _repository.removeSavedJob(_userId, savedJob.id);
      } else {
        // Add
        final savedJob = SavedJob(
          id: '${job.id}_${_userId}',
          jobId: job.id,
          userId: _userId,
          title: job.title,
          companyName: job.companyName,
          location: job.location,
          url: job.url,
          savedAt: DateTime.now(),
        );
        await _repository.saveJob(_userId, savedJob);
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(
        savingJobIds: state.savingJobIds.where((id) => id != job.id).toSet(),
      );
    }
  }

  Future<void> removeSavedJob(String savedJobId) async {
    if (_userId == null) return;

    try {
      await _repository.removeSavedJob(_userId, savedJobId);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

final savedJobsViewModelProvider = StateNotifierProvider<SavedJobsViewModel, SavedJobsState>((ref) {
  final user = ref.watch(currentUserProvider);
  return SavedJobsViewModel(
    ref.watch(savedJobsRepositoryProvider),
    user?.uid,
  );
});