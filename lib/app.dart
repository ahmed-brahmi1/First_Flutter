import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'config/theme.dart';
import 'config/routes.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/domain/usecases/login.dart';
import 'features/auth/domain/usecases/register.dart';
import 'features/auth/domain/usecases/logout.dart';
import 'features/auth/domain/usecases/restore_session.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/datasources/auth_local_datasource.dart';
import 'features/auth/data/datasources/auth_token_provider.dart';
import 'core/network/network_info.dart';
import 'core/network/api_client.dart';
import 'core/network/token_provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        final prefs = snapshot.data!;

        return MultiRepositoryProvider(
          providers: [
            RepositoryProvider<NetworkInfo>(
              create: (_) => NetworkInfoImpl(),
            ),
            RepositoryProvider<SharedPreferences>.value(
              value: prefs,
            ),
            RepositoryProvider<http.Client>(
              create: (_) => http.Client(),
            ),
            RepositoryProvider<AuthLocalDataSource>(
              create: (context) => AuthLocalDataSourceImpl(
                sharedPreferences: context.read<SharedPreferences>(),
              ),
            ),
            RepositoryProvider<TokenProvider>(
              create: (context) => AuthTokenProvider(
                context.read<AuthLocalDataSource>(),
              ),
            ),
            RepositoryProvider<ApiClient>(
              create: (context) => ApiClient(
                context.read<http.Client>(),
                tokenProvider: context.read<TokenProvider>(),
              ),
            ),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider<AuthBloc>(
                create: (context) {
                  final networkInfo = context.read<NetworkInfo>();
                  final localDataSource = context.read<AuthLocalDataSource>();
                  final remoteDataSource = AuthRemoteDataSourceImpl(
                    apiClient: context.read<ApiClient>(),
                  );
                  final repository = AuthRepositoryImpl(
                    remoteDataSource: remoteDataSource,
                    localDataSource: localDataSource,
                    networkInfo: networkInfo,
                  );

                  return AuthBloc(
                    login: Login(repository),
                    register: Register(repository),
                    logout: Logout(repository),
                    restoreSession: RestoreSession(repository),
                  )..add(AuthStatusChecked());
                },
              ),
            ],
            child: MaterialApp(
              title: 'SmartPet',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: ThemeMode.system,
              onGenerateRoute: AppRoutes.generateRoute,
              initialRoute: AppRoutes.login,
            ),
          ),
        );
      },
    );
  }
}

