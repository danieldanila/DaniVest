import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/services/analysis_service.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/services/conversation_service.dart';
import 'package:frontend/services/token_service.dart';
import 'package:frontend/services/tracking_events_service.dart';
import 'package:frontend/services/transaction_service.dart';
import 'package:frontend/services/user_service.dart';
import 'package:get_it/get_it.dart';
import 'package:frontend/constants/constants.dart' as constants;

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: constants.Strings.backendURL,
        validateStatus: (status) {
          return status != null && status >= 200 && status < 500;
        },
      ),
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await locator<TokenService>().getToken();
          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
          }
          return handler.next(options);
        },
      ),
    );
    return dio;
  });

  locator.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: constants.Strings.analysisURL,
        validateStatus:
            (status) => status != null && status >= 200 && status < 500,
      ),
    );
    return dio;
  }, instanceName: "BehaviouralDio");

  locator.registerLazySingleton<AuthService>(() => AuthService(locator<Dio>()));
  locator.registerLazySingleton<UserService>(() => UserService(locator<Dio>()));
  locator.registerLazySingleton<TransactionService>(
    () => TransactionService(locator<Dio>()),
  );
  locator.registerLazySingleton<ConversationService>(
    () => ConversationService(locator<Dio>()),
  );
  locator.registerLazySingleton<TrackingEventsService>(
    () => TrackingEventsService(locator<Dio>()),
  );
  locator.registerLazySingleton<AnalysisService>(
    () => AnalysisService(locator<Dio>(instanceName: "BehaviouralDio")),
  );
  locator.registerLazySingleton<TokenService>(() => TokenService());
  locator.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );
}
