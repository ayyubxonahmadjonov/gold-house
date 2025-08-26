// import 'package:flutter/material.dart';
// import 'package:gold_house/data/models/region_model.dart';

// class LocationDialog extends StatefulWidget {
//   final List<Region> regions;

//   const LocationDialog({super.key, required this.regions});

//   @override
//   State<LocationDialog> createState() => _LocationDialogState();
// }

// class _LocationDialogState extends State<LocationDialog> {
//   Region? selectedRegion;
//   String? selectedDistrict;
//   final TextEditingController streetController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       title: const Text("Manzilni tanlang"),
//       content: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Viloyat tanlash
//             DropdownButtonFormField<Region>(
//               decoration: const InputDecoration(labelText: "Viloyat"),
//               value: selectedRegion,
//               items: widget.regions.map((region) {
//                 return DropdownMenuItem(
//                   value: region,
//                   child: Text(region.nameUz),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   selectedRegion = value;
//                   selectedDistrict = null; // reset district
//                 });
//               },
//             ),

//             const SizedBox(height: 16),

//             // Shahar/Tuman tanlash
//             DropdownButtonFormField<String>(
//               decoration: const InputDecoration(labelText: "Shahar / Tuman"),
//               value: selectedDistrict,
//               items: (selectedRegion?.nameUz ?? [])
//                   .map((district) => DropdownMenuItem(
//                         value: district.nameUz,
//                         child: Text(district.nameUz),
//                       ))
//                   .toList(),
//               onChanged: (value) {
//                 setState(() {
//                   selectedDistrict = value;
//                 });
//               },
//             ),

//             const SizedBox(height: 16),

//             // Ko‘cha kiritish
//             TextFormField(
//               controller: streetController,
//               decoration: const InputDecoration(
//                 labelText: "Ko‘cha",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text("Bekor qilish"),
//         ),
//         ElevatedButton(
//           onPressed: () {
//             if (selectedRegion != null &&
//                 selectedDistrict != null &&
//                 streetController.text.isNotEmpty) {
//               final fullAddress =
//                   "${selectedRegion!.nameUz}, $selectedDistrict, ${streetController.text}";
//               Navigator.pop(context, fullAddress);
//             } else {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text("Iltimos, barcha maydonlarni to‘ldiring")),
//               );
//             }
//           },
//           child: const Text("Tasdiqlash"),
//         ),
//       ],
//     );
//   }
// }
