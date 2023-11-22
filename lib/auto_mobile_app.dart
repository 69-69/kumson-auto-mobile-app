import 'package:flutter/material.dart';
import 'config/theme/app_theme.dart';
import 'config/theme/color_schemes.g.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:automasters/config/routes/app_routes.dart';
import 'package:automasters/core/constants/constants.dart';
import 'package:automasters/features/injection_container.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/onboarding/onboarding_screen.dart';
import 'package:automasters/features/auto_mobile/domain/repositories/auth_repository.dart';
import 'package:automasters/features/auto_mobile/domain/repositories/user_repository.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/index.dart';


class AutoMobileApp extends StatefulWidget {
  const AutoMobileApp({super.key});

  @override
  State<AutoMobileApp> createState() => _AutoMobileAppState();
}

class _AutoMobileAppState extends State<AutoMobileApp> {
  late final AuthRepository _authRepository;
  late final UserRepository _userRepository;

  @override
  void initState() {
    super.initState();
    _authRepository = AuthRepository();
    _userRepository = UserRepository();
  }

  @override
  void dispose() {
    _authRepository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authRepository,
      child: MultiBlocProvider(
        providers: initBlocProviders(),
        child: MaterialApp(
          title: appName,
          debugShowCheckedModeBanner: false,
          theme: buildThemeData(context, cs: lightColorScheme),
          darkTheme: buildThemeData(context, cs: darkColorScheme),
          initialRoute: '/',
          onGenerateRoute: AppRoutes.onGenerateRoutes,
          home: const OnBoardingScreen(),
        ),
      ),
    );
  }

  initBlocProviders() => [
    // Authentication/Login
    BlocProvider(
      create: (_) => AuthBloc(
        authRepository: _authRepository,
        userRepository: _userRepository,
      ),
    ),

    /// Vehicles/Cars
    BlocProvider<VehicleByVinBloc>(
        create: (context) => sl<VehicleByVinBloc>()),
    BlocProvider<VehicleByVicBloc>(
        create: (context) => sl<VehicleByVicBloc>()),

    /// Makes
    BlocProvider<MakesBloc>(
      create: (context) => sl()..add(const GetMakesEvent()),
    ),

    /// Models
    BlocProvider<ModelsByMakeRefBloc>(
        create: (context) => sl<ModelsByMakeRefBloc>()),

    /// Parts
    BlocProvider<PartByHunterNoBloc>(
        create: (context) => sl<PartByHunterNoBloc>()),
    BlocProvider<PartsByVFamBloc>(
        create: (context) => sl<PartsByVFamBloc>()),
    BlocProvider<PartsByMakeModelBloc>(
        create: (context) => sl<PartsByMakeModelBloc>()),
    BlocProvider<PartsYearsByMakeModelBloc>(
        create: (context) => sl<PartsYearsByMakeModelBloc>()),

    /// Hunter
    BlocProvider<HunterPartsByPartNoBloc>(
        create: (context) => sl<HunterPartsByPartNoBloc>()),
    BlocProvider<HunterPartsByHunterNoBloc>(
        create: (context) => sl<HunterPartsByHunterNoBloc>()),

    /// Vendor
    BlocProvider<VendorPartsByBrandPartNoBloc>(
        create: (context) => sl<VendorPartsByBrandPartNoBloc>()),
  ];
}