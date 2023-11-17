import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'color_schemes.g.dart';
import 'config/theme/app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:automasters/config/routes/app_routes.dart';
import 'package:automasters/features/injection_container.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/app_local_database.dart';
import 'package:automasters/features/auto_mobile/presentation/onboarding_screen.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/hunter/remote/hunter_bloc.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/make/remote/make_event.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/model/remote/model_bloc.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/vehicle/remote/vehicle_bloc.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/vendor/remote/vendor_bloc.dart';
import 'features/auto_mobile/presentation/bloc/make/remote/make_bloc.dart';
import 'features/auto_mobile/presentation/bloc/parts/remote/part_bloc.dart';
import 'features/auto_mobile/presentation/bloc/vehicle/remote/vehicle_event.dart';

/*class MyHttpOverrides extends HttpOverrides {
  // Note: to Override HTTPS security ->  ByPass https security for development only(disable when in prod.)
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}*/

Future<void> main() async {
  // Note: to Override HTTPS security -> for dev only
  // HttpOverrides.global = MyHttpOverrides();

  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  await AppLocalDatabase.initFlutterHive();

  runApp(const AutoMobile());

  // Disable screen orientation to PORTRAIT-UP ONLY
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // Force System UI to use my defined colors
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  //SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
}

class AutoMobile extends StatelessWidget {
  const AutoMobile({super.key});

  @override
  Widget build(BuildContext context) {
    /*MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ChangeNotifierService()),
        ],
        builder: (context, child) => MaterialApp( */
    return MultiBlocProvider(
        providers: [
          /// Vehicles/Cars
          BlocProvider<VehiclesBloc>(
            create: (context) => sl()..add(const GetVehiclesEvent()),
          ),
          BlocProvider<VehicleByVinBloc>(create: (context) => sl<VehicleByVinBloc>()),
          BlocProvider<VehicleByVicBloc>(create: (context) => sl<VehicleByVicBloc>()),

          /// Makes
          BlocProvider<MakesBloc>(
            create: (context) => sl()..add(const GetMakesEvent()),
          ),

          /// Models
          /*BlocProvider<ModelsBloc>(
            create: (context) => sl()..add(const GetModels()),
          ),*/
          BlocProvider<ModelsByMakeRefBloc>(create: (context) => sl<ModelsByMakeRefBloc>()),

          /// Parts
          /*BlocProvider<PartsBloc>(
            create: (context) => sl()..add(const GetParts()),
          ),*/
          BlocProvider<PartByHunterNoBloc>(create: (context) => sl<PartByHunterNoBloc>()),
          BlocProvider<PartsByVFamBloc>(create: (context) => sl<PartsByVFamBloc>()),
          BlocProvider<PartsByMakeModelBloc>(create: (context) => sl<PartsByMakeModelBloc>()),
          BlocProvider<PartsYearsByMakeModelBloc>(create: (context) => sl<PartsYearsByMakeModelBloc>()),

          /// Hunter
          /*BlocProvider<HuntersBloc>(
            create: (context) => sl()..add(const GetHunters()),
          ),*/
          BlocProvider<HunterPartsByPartNoBloc>(create: (context) => sl<HunterPartsByPartNoBloc>()),
          BlocProvider<HunterPartsByHunterNoBloc>(create: (context) => sl<HunterPartsByHunterNoBloc>()),

          /// Vendor
          /*BlocProvider<VendorsBloc>(
            create: (context) => sl()..add(const GetVendors()),
          ),*/
          BlocProvider<VendorPartsByBrandPartNoBloc>(create: (context) => sl<VendorPartsByBrandPartNoBloc>()),
        ],
        child: MaterialApp(
          title: "AutoMasters",
          debugShowCheckedModeBanner: false,
          theme: buildThemeData(context, cs: lightColorScheme),

          darkTheme: buildThemeData(context, cs: darkColorScheme),

          // theme: ThemeData.light(useMaterial3: true,),
          //darkTheme: DarkTheme.darkTheme,
          // themeMode: ThemeMode.system,
          initialRoute: '/',
          onGenerateRoute: AppRoutes.onGenerateRoutes,
          home: const OnBoardingScreen(),
        ));
  }
}
