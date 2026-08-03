import '../models/job.dart';
import '../services/arbeitnow_service.dart';
import '../../core/utils/html_utils.dart';

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
    // Handle both string and int IDs
    final id = json['slug']?.toString() ?? 
               json['id']?.toString() ?? 
               '${json['title']}_${json['company_name']}'; // fallback ID

    // Parse created_at - API returns Unix timestamp (int)
    DateTime? createdAt;
    final createdAtRaw = json['created_at'];
    if (createdAtRaw != null) {
      if (createdAtRaw is int) {
        // Unix timestamp in seconds
        createdAt = DateTime.fromMillisecondsSinceEpoch(createdAtRaw * 1000);
      } else if (createdAtRaw is String) {
        createdAt = DateTime.tryParse(createdAtRaw);
      }
    }

    // Parse tags - API returns List<String>
    List<String>? tags;
    final tagsRaw = json['tags'];
    if (tagsRaw is List) {
      tags = tagsRaw.map((e) => e.toString()).toList();
    }

    // Parse remote - API returns boolean
    bool? remote;
    final remoteRaw = json['remote'];
    if (remoteRaw is bool) {
      remote = remoteRaw;
    } else if (remoteRaw is String) {
      remote = remoteRaw.toLowerCase() == 'true';
    }

    return Job(
      id: id,
      title: json['title']?.toString() ?? 'No Title',
      companyName: json['company_name']?.toString() ?? 'Unknown Company',
      location: json['location']?.toString(),
      description: HtmlUtils.stripTags(json['description']?.toString()),
      url: json['url']?.toString(),
      remote: remote,
      tags: tags,
      createdAt: createdAt,
    );
  }
}