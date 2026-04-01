class JobModel {
  final String id;
  final String title;
  final String company;
  final String? location;
  final String? workMode;
  final int? salaryMin;
  final int? salaryMax;
  final String? salaryCurrency;
  final List<String> requiredSkills;
  final String? status;
  final DateTime? createdAt;
  final String source;

  JobModel({
    required this.id,
    required this.title,
    required this.company,
    this.location,
    this.workMode,
    this.salaryMin,
    this.salaryMax,
    this.salaryCurrency,
    this.requiredSkills = const [],
    this.status,
    this.createdAt,
    required this.source,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['id'] as String,
      title: json['title'] as String,
      company: json['company'] as String,
      location: json['location'] as String?,
      workMode: json['work_mode'] as String?,
      salaryMin: json['salary_min'] as int?,
      salaryMax: json['salary_max'] as int?,
      salaryCurrency: json['salary_currency'] as String?,
      requiredSkills: (json['required_skills'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      status: json['status'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      source: json['source'] as String? ?? 'internal',
    );
  }

  /// Formats salary string gracefully
  String get displaySalary {
    if (salaryMin == null && salaryMax == null) return 'Salary Negotiable';
    final cur = salaryCurrency ?? 'USD';
    if (salaryMin != null && salaryMax != null) {
      return '$cur ${salaryMin! ~/ 1000}k - ${salaryMax! ~/ 1000}k';
    }
    return '$cur ${(salaryMin ?? salaryMax)! ~/ 1000}k+';
  }

  /// Calculates a fuzzy time ago string
  String get timeAgo {
    if (createdAt == null) return '';
    final diff = DateTime.now().difference(createdAt!);
    if (diff.inDays > 1) return '${diff.inDays}d ago';
    if (diff.inDays == 1) return '1d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'Just now';
  }
}
