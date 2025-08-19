
import 'package:gold_house/app.dart';
import '../../core/constants/app_imports.dart';
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesService.init();
  await HiveService.init();

  runApp(const MyApp());
}

