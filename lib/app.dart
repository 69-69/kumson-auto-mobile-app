import 'package:flutter/material.dart';
import 'config/theme/app_theme.dart';
import 'config/theme/color_schemes.g.dart';
import 'config/routes/routes_constant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:automasters/core/util/size_config.dart';
import 'package:automasters/core/constants/constants.dart';
import 'package:automasters/config/routes/app_routes.dart';
import 'package:automasters/features/injection_container.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/index.dart';
import 'package:automasters/features/auto_mobile/data/repositories/search_repository_impl.dart';
import 'package:automasters/features/auto_mobile/data/repositories/auth_repository_impl.dart';
import 'package:automasters/features/auto_mobile/data/repositories/user_repository_impl.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AuthRepositoryImpl _authRepository;
  late final UserRepositoryImpl _userRepository;
  late final SearchRepositoryImpl _searchRepository;
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState? get _navigator => _navigatorKey.currentState;

  @override
  void initState() {
    super.initState();
    _authRepository = AuthRepositoryImpl();
    _userRepository = UserRepositoryImpl();
    _searchRepository = SearchRepositoryImpl();
    _neededPlugin();
  }

  /// Get temporal Access & Refresh Tokens for
  /// unknown-visitors of the APP [_neededPlugin]
  void _neededPlugin() async {
    await _authRepository.temporalToken().whenComplete(
          // SMS Config Properties
          () => _userRepository.getSMSConfig(),
        );
  }

  @override
  void dispose() {
    _authRepository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Call SizeConfig on your starting screen
    SizeConfig().init(context);

    Future.delayed(const Duration(seconds: 1));

    return RepositoryProvider.value(
      value: _authRepository,
      child: MultiBlocProvider(
        providers: initBlocProviders(),
        child: _buildAppView(context),
      ),
    );
  }

  MaterialApp _buildAppView(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appName,
      navigatorKey: _navigatorKey,
      onGenerateRoute: AppRoutes.onGenerateRoutes,
      theme: buildThemeData(context, cs: lightColorScheme),
      darkTheme: buildThemeData(context, cs: darkColorScheme),
      // initialRoute: appRootRoute,
      // home: const OnBoardingScreen(),
      builder: (context, child) => BlocListener<AuthBloc, AuthState>(
        listener: (_, state) {
          switch (state.status) {
            case AuthStatus.authenticated:
              _navigator?.pushReplacementNamed(appRootRoute);

            case AuthStatus.unauthenticated:
              _navigator?.pushReplacementNamed(appRootRoute);

            case AuthStatus.continueSignup:
              _navigator?.pushReplacementNamed(
                autoHomeWithAuthRoute,
                arguments: state.activeSignup,
              );

            case AuthStatus.otpCreated:
              setState(() {});
              break;

            case AuthStatus.unknown:
              break;
          }
        },
        child: child,
      ),
      // OnBoardingScreen(navState: _navigator, child: child),
    );
  }

  initBlocProviders() => [
        // Authentication/Login/Signup
        BlocProvider(
          create: (_) => AuthBloc(
            authRepository: _authRepository,
            userRepository: _userRepository,
          ),
        ),

        /// ResendOTPBloc
        BlocProvider<ResendOTPBloc>(
          create: (context) => ResendOTPBloc(
            authRepository: _authRepository,
          ),
        ),

        /// VerifyOTPBloc
        BlocProvider<VerifyOTPBloc>(
          create: (context) => VerifyOTPBloc(
            authRepository: _authRepository,
          ),
        ),

        /// SearchBloc
        BlocProvider(
          create: (_) => SearchBloc(
            searchRepository: _searchRepository,
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
