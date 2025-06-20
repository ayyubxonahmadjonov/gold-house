import '../../core/constants/app_imports.dart';

class SelectLgScreen extends StatefulWidget {
  const SelectLgScreen({super.key});

  @override
  State<SelectLgScreen> createState() => _SelectLgScreenState();
}

class _SelectLgScreenState extends State<SelectLgScreen> {
  String _selectedLanguage = "uz"; // default til

  final Map<String, String> languages = {
    "uz": "O'zbekcha",
    "en": "Inglizcha",
    "ru": "Ruscha",
  };

  void _onLanguageSelect(String langCode) {
    setState(() {
      _selectedLanguage = langCode;
      // TODO: Local saqlash (SharedPreferences, Hive va h.k.)
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          children: [
            SizedBox(height: 100),

            const Text(
              "Tilni tanlang",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Spacer(),
            for (var entry in languages.entries)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: GestureDetector(
                  onTap: () => _onLanguageSelect(entry.key),
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white, // Doim oq fon
                      border: Border.all(
                        color:
                            _selectedLanguage == entry.key
                                ? Colors.yellow
                                : Colors.black,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      entry.value,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),

            Spacer(), // Davom etish tugmasi
            CustomButton(
              onPressed: () async {
                final prefs = SharedPreferencesService.instance;
                await prefs.saveString("selected_lg", _selectedLanguage);
                final savedLanguage = await prefs.getString("selected_lg");

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectBusinessScreen(),
                  ),
                );
              },

              title: "Davom etish",
              bacColor: Colors.yellow,
              textColor: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 20,
              borderRadius: 5,
              width: double.infinity,
              height: 55,
            ),
            SizedBox(height: 70),
          ],
        ),
      ),
    );
  }
}
