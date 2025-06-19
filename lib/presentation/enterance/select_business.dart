import '../../core/constants/app_imports.dart';

class SelectBusinessScreen extends StatefulWidget {
  const SelectBusinessScreen({super.key});

  @override
  State<SelectBusinessScreen> createState() => _SelectBusinessScreenState();
}

class _SelectBusinessScreenState extends State<SelectBusinessScreen> {
  String selectedBusiness = "";

  void _selectBusiness(String title) {
    setState(() {
      selectedBusiness = title;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BusinessCard(
                imagePath: "assets/icons/mebel.svg",
                title: "Giaz Mebel",
                isSelected: selectedBusiness == "Giaz Mebel",
                onTap: _selectBusiness,
              ),
              const SizedBox(height: 16),
              BusinessCard(
                imagePath: "assets/icons/story_baza.svg",
                title: "Stroy Baza №1",
                isSelected: selectedBusiness == "Stroy Baza №1",
                onTap: _selectBusiness,
              ),
              const SizedBox(height: 16),
              BusinessCard(
                imagePath: "assets/icons/gold.svg",
                title: "Gold Klinker",
                isSelected: selectedBusiness == "Gold Klinker",
                onTap: _selectBusiness,
              ),
              const SizedBox(height: 60),
              CustomButton(
                title: "Saqlash",
                onPressed: () async {
                  final prefs = SharedPreferencesService.instance;
                  await prefs.saveString("selected_business", selectedBusiness);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SelectRgScreen()),
                  );
                },
                bacColor: Colors.yellow,
                textColor: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 20,
                borderRadius: 5,
                width: double.infinity,
                height: 55,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BusinessCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final bool isSelected;
  final Function(String title) onTap;

  const BusinessCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(title),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.yellow : Colors.black,
            width: 1.8,
          ),
          color: Colors.white,
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                imagePath,
                // width: 35,
                // height: 35,
                // fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16.5,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
