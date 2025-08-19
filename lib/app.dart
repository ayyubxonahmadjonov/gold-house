import 'package:gold_house/bloc/bloc/banners_bloc.dart';
import 'package:gold_house/core/constants/app_imports.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
    String? token;

  @override
  void initState() {
    super.initState();
    getToken();
  }

  Future<void> getToken() async {
    token = SharedPreferencesService.instance.getString("access");
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
          ],
          child: MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: token != null ? MainScreen() : SignUpScreen(),
          ),
        );
      },
    );
  }
}
