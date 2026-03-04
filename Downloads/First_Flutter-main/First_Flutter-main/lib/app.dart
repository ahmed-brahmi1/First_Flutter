import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'config/theme.dart';
import 'config/routes.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/domain/usecases/login.dart';
import 'features/auth/domain/usecases/register.dart';
import 'features/auth/domain/usecases/logout.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/datasources/auth_local_datasource.dart';
import 'features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'features/dashboard/presentation/bloc/dashboard_event.dart';
import 'features/dashboard/domain/usecases/get_pet_status.dart';
import 'features/dashboard/domain/usecases/get_location.dart';
import 'features/dashboard/domain/usecases/get_health_data.dart';
import 'features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'features/dashboard/data/datasources/dashboard_local_datasource.dart';
import 'core/network/network_info.dart';
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
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider<AuthBloc>(
                create: (context) {
                  final networkInfo = context.read<NetworkInfo>();
                  final client = context.read<http.Client>();
                  final sharedPrefs = context.read<SharedPreferences>();

                  final remoteDataSource = AuthRemoteDataSourceImpl(client: client);
                  final localDataSource = AuthLocalDataSourceImpl(
                    sharedPreferences: sharedPrefs,
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
                  );
                },
              ),
              BlocProvider<DashboardBloc>(
                create: (context) {
                  final networkInfo = context.read<NetworkInfo>();
                  final client = context.read<http.Client>();

                  final remoteDataSource = DashboardRemoteDataSourceImpl(client: client);
                  final localDataSource = DashboardLocalDataSourceImpl();
                  final repository = DashboardRepositoryImpl(
                    remoteDataSource: remoteDataSource,
                    localDataSource: localDataSource,
                    networkInfo: networkInfo,
                  );

                  return DashboardBloc(
                    getPetStatus: GetPetStatus(repository),
                    getLocation: GetLocation(repository),
                    getHealthData: GetHealthData(repository),
                  )..add(const LoadDashboardData());
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

