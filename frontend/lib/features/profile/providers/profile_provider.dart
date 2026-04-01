import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/candidate_profile_model.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';

final profileProvider = FutureProvider<CandidateProfileModel>((ref) async {
  final res = await ApiClient.instance.get(ApiEndpoints.profile);
  return CandidateProfileModel.fromJson(res.data);
});
