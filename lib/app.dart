import 'package:gold_house/bloc/banners/banners_bloc.dart';
import 'package:gold_house/bloc/branches/branches_bloc.dart';
import 'package:gold_house/bloc/categories/get_categories_bloc.dart';
import 'package:gold_house/bloc/create_order/create_order_bloc.dart';
import 'package:gold_house/bloc/my_orders/my_orders_bloc.dart';
import 'package:gold_house/bloc/regions/regions_bloc.dart';
import 'package:gold_house/core/constants/app_imports.dart';

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
            BlocProvider(
              create: (context) => AuthLoginBloc(),
            ),
            BlocProvider(
              create: (context) => AuthRegisterBloc(),
            ),
              BlocProvider(
              create: (context) => OtpVerificationBloc(),
            ),
            BlocProvider(
              create: (context) => GetCitiesBloc(),
            ),
                BlocProvider(
              create: (context) => GetProductsBloc(),
            ),
                  BlocProvider(
              create: (context) => BannersBloc(),
            ),
            BlocProvider(
              create: (context) => MyOrdersBloc(),
            ),
            BlocProvider(
              create: (context) => CreateOrderBloc(),
            ),
            BlocProvider(
              create: (context) => GetCategoriesBloc(),
            ),
            BlocProvider(
              create: (context) => BranchesBloc(),
            ),
            BlocProvider(
              create: (context) => RegionsBloc(),
            ),
          ],
          child: MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: selected_lg != null ? MainScreen() : SelectLgScreen()
          ),
        );
      },
    );
  }
}
