import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Firebase/auth_service.dart';

final authServiceProvider = ChangeNotifierProvider<AuthService>((ref) {
  return AuthService();
});
