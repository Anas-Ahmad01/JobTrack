import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/job_application.dart';
import '../../data/repositories/applications_repository.dart';
import '../../data/services/firestore_service.dart';
import 'auth_viewmodel.dart';

// Repository provider
final applicationsRepositoryProvider = Provider((ref) {
  return ApplicationsRepository(ref.watch(firestoreServiceProvider));
});

// Filter state
final applicationFilterProvider = StateProvider<ApplicationStatus?>((ref) => null);

// Applications state
class ApplicationsState {
  final List<JobApplication> applications;
  final bool isLoading;
  final String? error;
  final bool isSuccess;

  const ApplicationsState({
    this.applications = const [],
    this.isLoading = false,
    this.error,
    this.isSuccess = false,
  });

  ApplicationsState copyWith({
    List<JobApplication>? applications,
    bool? isLoading,
    String? error,
    bool? isSuccess,
  }) {
    return ApplicationsState(
      applications: applications ?? this.applications,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  List<JobApplication> getFilteredApplications(ApplicationStatus? filter) {
    if (filter == null) return applications;
    return applications.where((a) => a.status == filter).toList();
  }
}

class ApplicationsViewModel extends StateNotifier<ApplicationsState> {
  final ApplicationsRepository _repository;
  final String? _userId;

  ApplicationsViewModel(this._repository, this._userId)
      : super(const ApplicationsState()) {
    if (_userId != null) {
      _loadApplications();
    }
  }

  void _loadApplications() {
    state = state.copyWith(isLoading: true, error: null);
    
    _repository.getApplications(_userId!).listen(
      (apps) {
        state = state.copyWith(applications: apps, isLoading: false);
      },
      onError: (e) {
        state = state.copyWith(error: e.toString(), isLoading: false);
      },
    );
  }

  Future<void> addApplication(JobApplication application) async {
    if (_userId == null) return;

    state = state.copyWith(isLoading: true, error: null, isSuccess: false);
    try {
      await _repository.addApplication(_userId, application);
      state = state.copyWith(isLoading: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> updateApplication(
    String applicationId,
    Map<String, dynamic> data,
  ) async {
    if (_userId == null) return;

    state = state.copyWith(isLoading: true, error: null, isSuccess: false);
    try {
      await _repository.updateApplication(_userId, applicationId, data);
      state = state.copyWith(isLoading: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> deleteApplication(String applicationId) async {
    if (_userId == null) return;

    try {
      await _repository.deleteApplication(_userId, applicationId);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> changeStatus(
    String applicationId,
    ApplicationStatus newStatus,
  ) async {
    await updateApplication(applicationId, {
      'status': newStatus.name,
    });
  }

  void clearSuccess() {
    state = state.copyWith(isSuccess: false);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final applicationsViewModelProvider = StateNotifierProvider<ApplicationsViewModel, ApplicationsState>((ref) {
  final user = ref.watch(currentUserProvider);
  return ApplicationsViewModel(
    ref.watch(applicationsRepositoryProvider),
    user?.uid,
  );
});