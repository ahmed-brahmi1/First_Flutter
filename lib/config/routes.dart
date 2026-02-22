import 'package:flutter/material.dart';
import 'bloc_providers.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/dashboard/presentation/pages/home_dashboard_page.dart';
import '../../features/tracking/presentation/pages/tracking_dashboard_page.dart';
import '../../features/health/presentation/pages/health_dashboard_page.dart';
import '../../features/feeding/presentation/pages/feeding_dashboard_page.dart';
import '../../features/alerts/presentation/pages/alerts_page.dart';
import '../../features/audio/presentation/pages/audio_dashboard_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String map = '/map';
  static const String health = '/health';
  static const String feeding = '/feeding';
  static const String alerts = '/alerts';
  static const String audio = '/audio';
  static const String settings = '/settings';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case dashboard:
        return MaterialPageRoute(
          builder: (_) => BlocProviders.wrapWithDashboardBloc(
            const HomeDashboardPage(),
          ),
        );
      case map:
        return MaterialPageRoute(
          builder: (_) => BlocProviders.wrapWithTrackingBloc(
            const TrackingDashboardPage(),
          ),
        );
      case health:
        return MaterialPageRoute(
          builder: (_) => BlocProviders.wrapWithHealthBloc(
            const HealthDashboardPage(),
          ),
        );
      case feeding:
        return MaterialPageRoute(
          builder: (_) => BlocProviders.wrapWithFeedingBloc(
            const FeedingDashboardPage(),
          ),
        );
      case alerts:
        return MaterialPageRoute(
          builder: (_) => BlocProviders.wrapWithAlertsBloc(
            const AlertsPage(),
          ),
        );
      case audio:
        return MaterialPageRoute(
          builder: (_) => BlocProviders.wrapWithAudioBloc(
            const AudioDashboardPage(),
          ),
        );
      case AppRoutes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}

