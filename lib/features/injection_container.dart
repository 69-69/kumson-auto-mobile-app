import 'package:automasters/features/auto_mobile/data/data_sources/local/app_local_database.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/remote/automobile_api_service.dart';
import 'package:automasters/features/auto_mobile/data/repositories/vehicle_repository_impl.dart';
import 'package:automasters/features/auto_mobile/domain/repositories/make_repository.dart';
import 'package:automasters/features/auto_mobile/domain/repositories/vehicle_repository.dart';
import 'package:automasters/features/auto_mobile/domain/usecases/get_Hunter.dart';
import 'package:automasters/features/auto_mobile/domain/usecases/get_make.dart';
import 'package:automasters/features/auto_mobile/domain/usecases/get_model.dart';
import 'package:automasters/features/auto_mobile/domain/usecases/get_parts.dart';
import 'package:automasters/features/auto_mobile/domain/usecases/get_vehicle.dart';
import 'package:automasters/features/auto_mobile/domain/usecases/get_vendor.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/hunter/remote/hunter_bloc.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/model/remote/model_bloc.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/parts/remote/part_bloc.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/vehicle/remote/vehicle_bloc.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/vendor/remote/vendor_bloc.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'auto_mobile/data/repositories/hunter_repository_impl.dart';
import 'auto_mobile/data/repositories/make_repository_impl.dart';
import 'auto_mobile/data/repositories/model_repository_impl.dart';
import 'auto_mobile/data/repositories/parts_repository_impl.dart';
import 'auto_mobile/data/repositories/vendor_repository_impl.dart';
import 'auto_mobile/domain/repositories/hunter_repository.dart';
import 'auto_mobile/domain/repositories/model_repository.dart';
import 'auto_mobile/domain/repositories/parts_repository.dart';
import 'auto_mobile/domain/repositories/vendor_repository.dart';
import 'auto_mobile/presentation/bloc/make/remote/make_bloc.dart';

final sl = GetIt.instance;

// FACTORY: GET IT -> NEW INSTANCE
// SINGLETON: GET IT -> SAME INSTANCE
/// Dependencies Injection
Future<void> initializeDependencies() async {
  await AppLocalDatabase.initFlutterHive();

  /// Dio:
  sl.registerSingleton<Dio>(Dio());

  /// data source
  sl.registerSingleton<AutomobileApiService>(
    AutomobileApiService(sl()),
  );

  /// Singleton-> VehicleRepository:
  ///
  // Vehicles/Cars:
  sl.registerSingleton<VehicleRepository>(
    VehicleRepositoryImpl(sl()),
  );

  // Makes:
  sl.registerSingleton<MakeRepository>(
    MakeRepositoryImpl(sl()),
  );

  // Models:
  sl.registerSingleton<ModelRepository>(
    ModelRepositoryImpl(sl()),
  );

  // Parts:
  sl.registerSingleton<PartsRepository>(
    PartsRepositoryImpl(sl()),
  );

  // Hunter:
  sl.registerSingleton<HunterRepository>(
    HunterRepositoryImpl(sl()),
  );

  // Vendor:
  sl.registerSingleton<VendorRepository>(
    VendorRepositoryImpl(sl()),
  );

  /// Singleton-> UseCases:
  ///
  // Vehicles/Cars
  sl.registerSingleton<GetVehicleUseCase>(
    GetVehicleUseCase(sl()),
  );
  sl.registerSingleton<GetVehicleByVinUseCase>(
    GetVehicleByVinUseCase(sl()),
  );
  sl.registerSingleton<GetVehicleByVicUseCase>(
    GetVehicleByVicUseCase(sl()),
  );

  // Makes
  sl.registerSingleton<GetMakesUseCase>(
    GetMakesUseCase(sl()),
  );

  // Models
  sl.registerSingleton<GetModelsUseCase>(
    GetModelsUseCase(sl()),
  );
  sl.registerSingleton<GetModelsByMakeRefUseCase>(
    GetModelsByMakeRefUseCase(sl()),
  );

  // Parts
  sl.registerSingleton<GetPartsUseCase>(
    GetPartsUseCase(sl()),
  );
  sl.registerSingleton<GetPartsByMakeModelUseCase>(
    GetPartsByMakeModelUseCase(sl()),
  );
  sl.registerSingleton<GetPartByHunterNoUseCase>(
    GetPartByHunterNoUseCase(sl()),
  );
  sl.registerSingleton<GetPartsByVFamUseCase>(
    GetPartsByVFamUseCase(sl()),
  );
  sl.registerSingleton<GetPartsYearsByMakeModelUseCase>(
    GetPartsYearsByMakeModelUseCase(sl()),
  );

  // Hunters
  sl.registerSingleton<GetHuntersUseCase>(
    GetHuntersUseCase(sl()),
  );
  sl.registerSingleton<GetHunterPartsByHunterNoUseCase>(
    GetHunterPartsByHunterNoUseCase(sl()),
  );
  sl.registerSingleton<GetHunterPartsByPartNoUseCase>(
    GetHunterPartsByPartNoUseCase(sl()),
  );

  // Vendors
  sl.registerSingleton<GetVendorsUseCase>(
    GetVendorsUseCase(sl()),
  );
  sl.registerSingleton<GetVendorByIdUseCase>(
    GetVendorByIdUseCase(sl()),
  );
  sl.registerSingleton<GetVendorPartsByBrandPartNoUseCase>(
    GetVendorPartsByBrandPartNoUseCase(sl()),
  );

  /// Factory-> Blocs:
  ///
  // Vehicles/Cars
  sl.registerFactory<VehiclesBloc>(
    () => VehiclesBloc(sl()),
  );
  sl.registerFactory<VehicleByVinBloc>(
    () => VehicleByVinBloc(sl()),
  );
  sl.registerFactory<VehicleByVicBloc>(
    () => VehicleByVicBloc(sl()),
  );

  // Makes
  sl.registerFactory<MakesBloc>(
    () => MakesBloc(sl()),
  );

  // Models
  sl.registerFactory<ModelsBloc>(
    () => ModelsBloc(sl()),
  );
  sl.registerFactory<ModelsByMakeRefBloc>(
    () => ModelsByMakeRefBloc(sl()),
  );

  // Parts
  sl.registerFactory<PartsBloc>(
    () => PartsBloc(sl()),
  );
  sl.registerFactory<PartByHunterNoBloc>(
    () => PartByHunterNoBloc(sl()),
  );
  sl.registerFactory<PartsByVFamBloc>(
    () => PartsByVFamBloc(sl()),
  );
  sl.registerFactory<PartsByMakeModelBloc>(
    () => PartsByMakeModelBloc(sl()),
  );
  sl.registerFactory<PartsYearsByMakeModelBloc>(
    () => PartsYearsByMakeModelBloc(sl()),
  );

  // Hunters
  sl.registerFactory<HuntersBloc>(
    () => HuntersBloc(sl()),
  );
  sl.registerFactory<HunterPartsByHunterNoBloc>(
    () => HunterPartsByHunterNoBloc(sl()),
  );
  sl.registerFactory<HunterPartsByPartNoBloc>(
    () => HunterPartsByPartNoBloc(sl()),
  );

  // Vendors
  sl.registerFactory<VendorsBloc>(
    () => VendorsBloc(sl()),
  );
  sl.registerFactory<VendorByIdBloc>(
    () => VendorByIdBloc(sl()),
  );
  sl.registerFactory<VendorPartsByBrandPartNoBloc>(
    () => VendorPartsByBrandPartNoBloc(sl()),
  );
}
