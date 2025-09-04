import 'package:easy_localization/easy_localization.dart';
import 'package:gold_house/data/models/city_model.dart';
import 'package:gold_house/presentation/widgets/select_city_dialog.dart';

import '../../core/constants/app_imports.dart';

class SelectRgScreen extends StatefulWidget {
  const SelectRgScreen({super.key});

  @override
  State<SelectRgScreen> createState() => _SelectRgScreenState();
}

class _SelectRgScreenState extends State<SelectRgScreen> {
  String selectedCity = "Andijon";


void _showCityDialog() {
  String? tempSelected = selectedCity;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return BlocConsumer<GetCitiesBloc, GetCitiesState>(
        listener: (context, state) {
         
        },
        builder: (context, state) {
  
          if (state is GetCitiesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is GetCitiesError) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title:  Text("error".tr()),
              content: Text("Shaharlarni yuklashda muammo yuz berdi.${state.message}"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                ),
              ],
            );
          }


          if (state is GetCitiesSuccess) {
       
            List<City> cities = state.cities; 

            if (cities.isEmpty) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: const Text("Ma'lumot yo‘q"),
                content: const Text("Hech qanday shahar topilmadi."),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("OK"),
                  ),
                ],
              );
            }

          return SelectCityDialog(
            cities: cities,
            initialSelectedCity: selectedCity,
          );
          }

          // Default fallback (hech qaysi holatga tushmagan bo'lsa)
          return const Center(child: CircularProgressIndicator());
        },
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            
              Image.asset(
                'assets/icons/location.png',
                width: 100,
                height: 100,
              ),
      
              const SizedBox(height: 40),
      
              Text(
                "are_you_from_city".tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
      
              const SizedBox(height: 12),
      
               Text(
                "note_region".tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
      
              const SizedBox(height: 40),
      
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: ()  {
                    BlocProvider.of<GetCitiesBloc>(context).add(GetAllCitiesEvent());
                    Future.delayed(const Duration(seconds: 1)).then((value) {
                      _showCityDialog();
                    });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text("${"no".tr()} ${"change".tr()}"),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainScreen(),
                        ),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow[700],
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text("yes".tr()),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
