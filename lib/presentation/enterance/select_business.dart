import 'package:easy_localization/easy_localization.dart';

import '../../core/constants/app_imports.dart';

class SelectBusinessScreen extends StatefulWidget {
  const SelectBusinessScreen({super.key});

  @override
  State<SelectBusinessScreen> createState() => _SelectBusinessScreenState();
}

class _SelectBusinessScreenState extends State<SelectBusinessScreen> {
  String selectedBusiness = "Stroy Baza №1";

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
                imagePath: "assets/images/giaz_mebel.png",
                title: "Giaz Mebel",
                isSelected: selectedBusiness == "Giaz Mebel",
                onTap: _selectBusiness,
              ),
              const SizedBox(height: 16),
              BusinessCard(
                imagePath: "assets/images/app_logo.png",
                title: "Stroy Baza №1",
                isSelected: selectedBusiness == "Stroy Baza №1",
                onTap: _selectBusiness,
              ),
              const SizedBox(height: 16),
              BusinessCard(
                imagePath: "assets/images/gold_klinker.jpg",
                title: "GoldKlinker",
                isSelected: selectedBusiness == "GoldKlinker",
                onTap: _selectBusiness,
              ),
              const SizedBox(height: 60),
              CustomButton(
                title: "save".tr(),
                onPressed: () async {
      await SharedPreferencesService.instance.saveString("selected_business", selectedBusiness);
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

class BusinessCard extends StatefulWidget {
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
  State<BusinessCard> createState() => _BusinessCardState();
}

class _BusinessCardState extends State<BusinessCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onTap(widget.title),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: widget.isSelected ? Colors.yellow : Colors.black,
            width: 1.8,
          ),
          color: Colors.white,
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(widget.imagePath,height: 40,width: 40,),
            ),
            const SizedBox(width: 16),
            Text(
              widget.title,
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
