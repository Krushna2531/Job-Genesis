import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpoints {
  static String get baseUrl => dotenv.env['API_BASE_URL'] ?? 'http://localhost:3001/api';

  // Auth
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String forgotPassword = '/auth/forgot-password';
  static const String me = '/auth/me';

  // Jobs
  static const String jobs = '/jobs';
  static const String myApplications = '/jobs/applications/mine';
  static const String recommendations = '/recommendations/jobs';
  
  // Apply
  static String applyToJob(String jobId) => '/jobs/$jobId/apply';

  // Candidates
  static const String profile = '/candidates/profile';
  static const String profileCompletion = '/candidates/profile/completion';

  // Interviews
  static const String interviewSessions = '/interviews/sessions';
  static String submitAnswer(String questionId) => '/interviews/questions/$questionId/answer';
  static String completeInterview(String sessionId) => '/interviews/sessions/$sessionId/complete';

  // Resumes
  static const String uploadRawResume = '/resumes/upload-raw';
  static const String getLatestResume = '/resumes/latest';
  static String analyzeResume(String resumeId) => '/resumes/$resumeId/analyse';
}
