import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';

// Because we don't have a rigid ApplicationModel yet, we can type it as List<Map<String, dynamic>>
// or create a simple ApplicationModel inline / in core models.
class ApplicationModel {
  final String id;
  final String status;
  final int? matchScore;
  final String appliedAt;
  final String title;
  final String company;
  final String location;
  final String workMode;

  ApplicationModel({
    required this.id,
    required this.status,
    this.matchScore,
    required this.appliedAt,
    required this.title,
    required this.company,
    required this.location,
    required this.workMode,
  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    return ApplicationModel(
      id: json['id']?.toString() ?? '',
      status: json['status']?.toString() ?? 'applied',
      matchScore: json['match_score'] ?? json['matchScore'],
      appliedAt: json['applied_at'] ?? json['appliedAt'] ?? DateTime.now().toIso8601String(),
      title: json['title']?.toString() ?? 'Unknown Role',
      company: json['company']?.toString() ?? 'Unknown Company',
      location: json['location']?.toString() ?? 'Remote',
      workMode: json['work_mode']?.toString() ?? 'hybrid',
    );
  }
}

final applicationsProvider = FutureProvider<List<ApplicationModel>>((ref) async {
  final res = await ApiClient.instance.get(ApiEndpoints.myApplications);
  
  final data = res.data['data'] as List<dynamic>? ?? res.data as List<dynamic>;
  
  return data.map((json) => ApplicationModel.fromJson(json)).toList();
});
