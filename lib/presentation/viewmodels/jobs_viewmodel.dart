import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/job.dart';
import '../../data/repositories/jobs_repository.dart';
import '../../data/services/arbeitnow_service.dart';

// Service provider
final arbeitnowServiceProvider = Provider((ref) => ArbeitnowService());

// Repository provider
final jobsRepositoryProvider = Provider((ref) {
  return JobsRepository(ref.watch(arbeitnowServiceProvider));
});

// Jobs state
class JobsState {
  final List<Job> jobs;
  final bool isLoading;
  final String? error;
  final String searchQuery;

  const JobsState({
    this.jobs = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
  });

  JobsState copyWith({
    List<Job>? jobs,
    bool? isLoading,
    String? error,
    String? searchQuery,
  }) {
    return JobsState(
      jobs: jobs ?? this.jobs,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class JobsViewModel extends StateNotifier<JobsState> {
  final JobsRepository _repository;

  JobsViewModel(this._repository) : super(const JobsState()) {
    loadJobs();
  }

  Future<void> loadJobs() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final jobs = await _repository.getJobs();
      state = state.copyWith(jobs: jobs, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> search(String query) async {
    state = state.copyWith(isLoading: true, error: null, searchQuery: query);
    try {
      final jobs = await _repository.searchJobs(query);
      state = state.copyWith(jobs: jobs, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  void clearSearch() {
    state = state.copyWith(searchQuery: '');
    loadJobs();
  }
}

final jobsViewModelProvider =
    StateNotifierProvider<JobsViewModel, JobsState>((ref) {
  return JobsViewModel(ref.watch(jobsRepositoryProvider));
});