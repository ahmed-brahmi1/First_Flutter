import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../core/network/network_info.dart';
import '../features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../features/dashboard/presentation/bloc/dashboard_event.dart';
import '../features/dashboard/domain/usecases/get_pet_status.dart';
import '../features/dashboard/domain/usecases/get_location.dart';
import '../features/dashboard/domain/usecases/get_health_data.dart';
import '../features/dashboard/data/repositories/dashboard_repository_impl.dart';
import '../features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import '../features/dashboard/data/datasources/dashboard_local_datasource.dart';
import '../features/tracking/presentation/bloc/tracking_bloc.dart';
import '../features/tracking/domain/usecases/get_realtime_location.dart';
import '../features/tracking/domain/usecases/set_geofence.dart';
import '../features/tracking/domain/usecases/get_location_history.dart';
import '../features/tracking/data/repositories/tracking_repository_impl.dart';
import '../features/tracking/data/datasources/tracking_remote_datasource.dart';
import '../features/health/presentation/bloc/health_bloc.dart';
import '../features/health/domain/usecases/get_temperature_history.dart';
import '../features/health/domain/usecases/get_ai_predictions.dart';
import '../features/health/data/repositories/health_repository_impl.dart';
import '../features/health/data/datasources/health_remote_datasource.dart';
import '../features/feeding/presentation/bloc/feeding_bloc.dart';
import '../features/feeding/domain/usecases/get_feeding_logs.dart';
import '../features/feeding/domain/usecases/trigger_manual_feed.dart';
import '../features/feeding/domain/usecases/set_schedule.dart';
import '../features/feeding/data/repositories/feeding_repository_impl.dart';
import '../features/feeding/data/datasources/feeding_remote_datasource.dart';
import '../features/alerts/presentation/bloc/alerts_bloc.dart';
import '../features/alerts/domain/usecases/get_alerts.dart';
import '../features/alerts/domain/usecases/mark_alert_read.dart';
import '../features/alerts/data/repositories/alert_repository_impl.dart';
import '../features/alerts/data/datasources/alert_remote_datasource.dart';
import '../features/alerts/data/datasources/alert_local_datasource.dart';
import '../features/audio/presentation/bloc/audio_bloc.dart';
import '../features/audio/domain/usecases/start_two_way_audio.dart';
import '../features/audio/domain/usecases/send_voice_command.dart';
import '../features/audio/data/repositories/audio_repository_impl.dart';
import '../features/audio/data/datasources/audio_remote_datasource.dart';

class BlocProviders {
  static Widget wrapWithDashboardBloc(Widget child) {
    return BlocProvider<DashboardBloc>(
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
      child: child,
    );
  }

  static Widget wrapWithTrackingBloc(Widget child) {
    return BlocProvider<TrackingBloc>(
      create: (context) {
        final networkInfo = context.read<NetworkInfo>();
        final client = context.read<http.Client>();

        final remoteDataSource = TrackingRemoteDataSourceImpl(client: client);
        final repository = TrackingRepositoryImpl(
          remoteDataSource: remoteDataSource,
          networkInfo: networkInfo,
        );

        return TrackingBloc(
          getRealtimeLocation: GetRealtimeLocation(repository),
          setGeofence: SetGeofence(repository),
          getLocationHistory: GetLocationHistory(repository),
        );
      },
      child: child,
    );
  }

  static Widget wrapWithHealthBloc(Widget child) {
    return BlocProvider<HealthBloc>(
      create: (context) {
        final networkInfo = context.read<NetworkInfo>();
        final client = context.read<http.Client>();

        final remoteDataSource = HealthRemoteDataSourceImpl(client: client);
        final repository = HealthRepositoryImpl(
          remoteDataSource: remoteDataSource,
          networkInfo: networkInfo,
        );

        return HealthBloc(
          getTemperatureHistory: GetTemperatureHistory(repository),
          getAIPredictions: GetAIPredictions(repository),
        );
      },
      child: child,
    );
  }

  static Widget wrapWithFeedingBloc(Widget child) {
    return BlocProvider<FeedingBloc>(
      create: (context) {
        final networkInfo = context.read<NetworkInfo>();
        final client = context.read<http.Client>();

        final remoteDataSource = FeedingRemoteDataSourceImpl(client: client);
        final repository = FeedingRepositoryImpl(
          remoteDataSource: remoteDataSource,
          networkInfo: networkInfo,
        );

        return FeedingBloc(
          getFeedingLogs: GetFeedingLogs(repository),
          triggerManualFeed: TriggerManualFeed(repository),
          setSchedule: SetSchedule(repository),
        );
      },
      child: child,
    );
  }

  static Widget wrapWithAlertsBloc(Widget child) {
    return BlocProvider<AlertsBloc>(
      create: (context) {
        final networkInfo = context.read<NetworkInfo>();
        final client = context.read<http.Client>();

        final remoteDataSource = AlertRemoteDataSourceImpl(client: client);
        final localDataSource = AlertLocalDataSourceImpl();
        final repository = AlertRepositoryImpl(
          remoteDataSource: remoteDataSource,
          localDataSource: localDataSource,
          networkInfo: networkInfo,
        );

        return AlertsBloc(
          getAlerts: GetAlerts(repository),
          markAlertRead: MarkAlertRead(repository),
        );
      },
      child: child,
    );
  }

  static Widget wrapWithAudioBloc(Widget child) {
    return BlocProvider<AudioBloc>(
      create: (context) {
        final networkInfo = context.read<NetworkInfo>();
        final client = context.read<http.Client>();

        final remoteDataSource = AudioRemoteDataSourceImpl(client: client);
        final repository = AudioRepositoryImpl(
          remoteDataSource: remoteDataSource,
          networkInfo: networkInfo,
        );

        return AudioBloc(
          startTwoWayAudio: StartTwoWayAudio(repository),
          sendVoiceCommand: SendVoiceCommand(repository),
        );
      },
      child: child,
    );
  }
}

