class CandidateProfileModel {
  final String id;
  final String userId;
  final String? headline;
  final String? bio;
  final String? location;
  final List<String> topSkills;
  final int profileCompletion;
  final Map<String, dynamic> stats;
  final List<dynamic> recentApplications;

  CandidateProfileModel({
    required this.id,
    required this.userId,
    this.headline,
    this.bio,
    this.location,
    this.topSkills = const [],
    this.profileCompletion = 0,
    this.stats = const {},
    this.recentApplications = const [],
  });

  factory CandidateProfileModel.fromJson(Map<String, dynamic> json) {
    return CandidateProfileModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] ?? json['user_id'] ?? '',
      headline: json['headline'] as String?,
      bio: json['bio'] as String?,
      location: json['location'] as String?,
      topSkills: (json['topSkills'] ?? json['top_skills'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      profileCompletion: json['profileCompletion'] ?? json['profile_completion'] ?? 0,
      stats: json['stats'] as Map<String, dynamic>? ?? {},
      recentApplications: json['recentApplications'] as List<dynamic>? ?? [],
    );
  }
}
