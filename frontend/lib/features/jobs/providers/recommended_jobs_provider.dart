import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/job_model.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';

final recommendedJobsProvider = FutureProvider<List<JobModel>>((ref) async {
  final res = await ApiClient.instance.get(ApiEndpoints.recommendations);
  
  final data = res.data['data'] as List<dynamic>? ?? res.data as List<dynamic>;
  
  return data.map((json) => JobModel.fromJson(json)).toList();
});
