import '../../core/constants/app_imports.dart';

class SelectRgScreen extends StatefulWidget {
  const SelectRgScreen({super.key});

  @override
  State<SelectRgScreen> createState() => _SelectRgScreenState();
}

class _SelectRgScreenState extends State<SelectRgScreen> {
  String selectedCity = "Andijon";
  final List<String> cities = ["Toshkent", "Andijon", "Farg'ona", "Namangan"];

  void _showCityDialog() {
    String? tempSelected = selectedCity;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Shaharni tanlang",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: cities.length,
                  itemBuilder: (context, index) {
                    final city = cities[index];
                    return RadioListTile<String>(
                      title: Text(
                        city,
                        style: TextStyle(
                          fontSize: 16,
                          color:
                              tempSelected == city
                                  ? Colors.amber[800]
                                  : Colors.black87,
                        ),
                      ),
                      value: city,
                      groupValue: tempSelected,
                      activeColor: Colors.amber[800],
                      onChanged: (value) {
                        setState(() {
                          tempSelected = value!;
                        });
                      },
                    );
                  },
                ),
              );
            },
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[800],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              onPressed:
                  tempSelected == null
                      ? null
                      : () async {
                        setState(() {
                          selectedCity = tempSelected!;
                        });
                        final prefs = SharedPreferencesService.instance;
                        await prefs.saveString("selected_city", selectedCity);
                        print(prefs.getString("selected_city"));
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainScreen(),
                          ),
                        );
                      },
              child: const Text(
                "Tasdiqlash",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 📍 Location icon (siz rasm joylashtirasiz)
                Image.asset(
                  'assets/icons/location.png',
                  width: 100,
                  height: 100,
                ),

                const SizedBox(height: 40),

                Text(
                  "Siz $selectedCity shahridamisiz ?",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  "Tanlangan hududga qarab yetkazib berish\nusuli va mahsulot mavjudligi belgilanadi.",
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
                      onPressed: _showCityDialog,
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
                      child: const Text("Yo'q, o'zgartirish"),
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
                      child: const Text("Ha"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
