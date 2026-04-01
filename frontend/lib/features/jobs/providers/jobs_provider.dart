import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/job_model.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';

final jobsProvider = FutureProvider<List<JobModel>>((ref) async {
  final res = await ApiClient.instance.get(ApiEndpoints.jobs);
  
  // The backend might return { data: [...], total: ... } or just a list.
  // We'll assume the standard pagination structure typically returns `data` or `jobs`
  final data = res.data['data'] as List<dynamic>? ?? res.data as List<dynamic>;
  
  return data.map((json) => JobModel.fromJson(json)).toList();
});
