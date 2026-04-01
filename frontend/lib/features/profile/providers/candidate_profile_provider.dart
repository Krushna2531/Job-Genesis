import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/candidate_profile_model.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';

final candidateProfileProvider = FutureProvider<CandidateProfileModel>((ref) async {
  // 1. Fetch the enriched profile for stats and skills
  final profileRes = await ApiClient.instance.get(ApiEndpoints.profile);
  
  // 2. Fetch the profile completion score (from backend)
  final completionRes = await ApiClient.instance.get(ApiEndpoints.profileCompletion);
  
  final Map<String, dynamic> data = profileRes.data;
  // Inject completion score manually if it's missing from enriched profile
  data['profileCompletion'] = completionRes.data['score'] ?? 0;
  
  return CandidateProfileModel.fromJson(data);
});
