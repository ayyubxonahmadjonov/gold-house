import 'package:easy_localization/easy_localization.dart';
import 'package:gold_house/bloc/banners/banners_bloc.dart';
import 'package:gold_house/bloc/bloc/create_credit_bloc.dart';
import 'package:gold_house/bloc/bloc/get_productbyid_bloc.dart';
import 'package:gold_house/bloc/bloc/user_agrrements_dart_bloc.dart';
import 'package:gold_house/bloc/business_selection/business_selection_bloc.dart';
import 'package:gold_house/bloc/categories/get_categories_bloc.dart';
import 'package:gold_house/bloc/get_phone_number_bloc.dart';
import 'package:gold_house/bloc/my_orders/my_orders_bloc.dart';
import 'package:gold_house/bloc/user_update/user_update_bloc.dart';
import 'package:gold_house/core/basket_notifier.dart';
import 'package:gold_house/presentation/screens/splash/splash_screen.dart';
import '../../core/constants/app_imports.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await SharedPreferencesService.init();
  await HiveService.init();
  BasketNotifier.init();

  runApp(
    EasyLocalization(
      startLocale: const Locale('en'),
      supportedLocales: const [Locale('en'), Locale('uz'), Locale('ru')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? selected_lg;

  @override
  void initState() {
    super.initState();
    getToken();
  }

  Future<void> getToken() async {
    selected_lg = SharedPreferencesService.instance.getString("selected_lg");
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => AuthLoginBloc()),
            BlocProvider(create: (context) => AuthRegisterBloc()),
            BlocProvider(create: (context) => OtpVerificationBloc()),
            BlocProvider(create: (context) => GetCitiesBloc()),
            BlocProvider(create: (context) => GetProductsBloc()),
            BlocProvider(create: (context) => BannersBloc()),
            BlocProvider(create: (context) => MyOrdersBloc()),
            BlocProvider(create: (context) => CreateOrderBloc()),
            BlocProvider(create: (context) => GetCategoriesBloc()),
            BlocProvider(create: (context) => BranchesBloc()),
            BlocProvider(create: (context) => RegionsBloc()),
            BlocProvider(create: (context) => UpdatePaymentBloc()),
            BlocProvider(create: (context) => GetUserDataBloc()),
            BlocProvider(create: (context) => UserUpdateBloc()),
            BlocProvider(create: (context) => CreateCreditBloc()),
            BlocProvider(create: (context) => GetProductbyidBloc()),
            BlocProvider(create: (context) => UserAgrrementsDartBloc()),
            BlocProvider(create: (context) => GetPhoneNumberBloc()),
            BlocProvider(create: (context) => BusinessSelectionBloc()),
          ],
          child: MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: selected_lg != null ? MainScreen() : SplashScreen(),
          ),
        );
      },
    );
  }
}
