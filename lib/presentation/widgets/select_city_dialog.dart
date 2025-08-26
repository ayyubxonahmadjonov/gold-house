import 'package:flutter/material.dart';
import 'package:gold_house/data/datasources/local/shared_preferences/shared_service.dart';
import 'package:gold_house/data/models/city_model.dart';
import 'package:gold_house/presentation/screens/main/main_screen.dart';

class SelectCityDialog extends StatefulWidget {
  Widget? route;
  final List<City> cities;        
  final String? initialSelectedCity; 

  SelectCityDialog({
    Key? key,
    required this.cities,
    this.initialSelectedCity,
     this.route,
  }) : super(key: key);

  @override
  State<SelectCityDialog> createState() => _SelectCityDialogState();
}

class _SelectCityDialogState extends State<SelectCityDialog> {
  String? tempSelected;

  @override
  void initState() {
    super.initState();
    tempSelected = widget.initialSelectedCity;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: const Text(
        "Shaharni tanlang",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.cities.length,
          itemBuilder: (context, index) {
            final city = widget.cities[index].nameUz;
            return RadioListTile<String>(
              title: Text(
                city,
                style: TextStyle(
                  fontSize: 16,
                  color: tempSelected == city
                      ? Colors.amber[800]
                      : Colors.black87,
                ),
              ),
              value: city,
              groupValue: tempSelected,
              activeColor: Colors.amber[800],
              onChanged: (value) {
                setState(() {
                  tempSelected = value;
                });
              },
            );
          },
        ),
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
          onPressed: tempSelected == null
              ? null
              : () async {
                  await SharedPreferencesService.instance
                      .saveString("selected_city", tempSelected!);

                widget.route!=null?  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => widget.route!,
                    ),
                  ): Navigator.pop(context);
                },
          child: const Text(
            "Tasdiqlash",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
      ],
    );
  }
}
