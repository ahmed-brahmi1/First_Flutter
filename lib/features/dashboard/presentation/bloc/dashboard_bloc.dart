import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_pet_status.dart';
import '../../domain/usecases/get_location.dart';
import '../../domain/usecases/get_health_data.dart';
import '../../../../core/usecases/usecase.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetPetStatus getPetStatus;
  final GetLocation getLocation;
  final GetHealthData getHealthData;

  DashboardBloc({
    required this.getPetStatus,
    required this.getLocation,
    required this.getHealthData,
  }) : super(DashboardInitial()) {
    on<LoadDashboardData>(_onLoadDashboardData);
    on<RefreshDashboardData>(_onRefreshDashboardData);
  }

  Future<void> _onLoadDashboardData(
    LoadDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());

    final statusResult = await getPetStatus(const NoParams());
    final locationResult = await getLocation(const NoParams());
    final healthResult = await getHealthData(const NoParams());

    statusResult.fold(
      (failure) => emit(DashboardError(failure.message)),
      (status) {
        locationResult.fold(
          (failure) => emit(DashboardError(failure.message)),
          (location) {
            healthResult.fold(
              (failure) => emit(DashboardError(failure.message)),
              (health) => emit(DashboardLoaded(
                petStatus: status,
                location: location,
                healthData: health,
              )),
            );
          },
        );
      },
    );
  }

  Future<void> _onRefreshDashboardData(
    RefreshDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    await _onLoadDashboardData(const LoadDashboardData(), emit);
  }
}

