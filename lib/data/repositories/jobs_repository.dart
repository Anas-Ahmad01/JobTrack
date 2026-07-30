import '../models/job.dart';
import '../services/arbeitnow_service.dart';

class JobsRepository {
  final ArbeitnowService _service;

  JobsRepository(this._service);

  Future<List<Job>> getJobs() async {
    final rawJobs = await _service.fetchJobs();
    return rawJobs.map((json) => _parseJob(json)).toList();
  }

  Future<List<Job>> searchJobs(String query) async {
    if (query.trim().isEmpty) return getJobs();
    final rawJobs = await _service.searchJobs(query.trim());
    return rawJobs.map((json) => _parseJob(json)).toList();
  }

  Job _parseJob(Map<String, dynamic> json) {
    return Job(
      id: json['slug']?.toString() ?? json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'No Title',
      companyName: json['company_name']?.toString() ?? 'Unknown Company',
      location: json['location']?.toString(),
      description: json['description']?.toString(),
      url: json['url']?.toString(),
      remote: json['remote'] == true || json['remote'] == 'true',
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      createdAt: _parseDate(json['created_at']),
    );
  }

  DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is int) {
      // Unix timestamp in seconds
      return DateTime.fromMillisecondsSinceEpoch(value * 1000);
    }
    if (value is String) {
      return DateTime.tryParse(value);
    }
    return null;
  }
}