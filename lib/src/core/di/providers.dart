import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/api_client.dart';
import '../../features/auth/data/auth_repository.dart';
import '../../features/capture/data/ai_repository.dart';

final apiClientProvider = FutureProvider<ApiClient>((ref) async {
  return ApiClient.create();
});

final authRepoProvider = Provider<AsyncValue<AuthRepository>>((ref) {
  final api = ref.watch(apiClientProvider);
  return api.whenData((a) => AuthRepository(a));
});

final aiRepoProvider = Provider<AsyncValue<AiRepository>>((ref) {
  final api = ref.watch(apiClientProvider);
  return api.whenData((a) => AiRepository(a));
});
