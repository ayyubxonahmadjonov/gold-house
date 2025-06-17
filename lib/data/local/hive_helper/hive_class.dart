import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as pp;

class HiveService {
  const HiveService._();
  static Future<void> init() async {
    final dir = await pp.getApplicationDocumentsDirectory();
    Hive.init(dir.path);

    // await Hive.openBox<String>(HiveBoxNames.acces_token);
    // await Hive.openBox<String>(HiveBoxNames.refresh_token);
  }
}
