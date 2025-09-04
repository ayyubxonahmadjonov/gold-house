import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gold_house/core/constants/app_imports.dart';
import 'package:gold_house/data/models/address_model.dart';
import 'package:gold_house/data/models/city_model.dart';
import 'package:gold_house/data/models/region_model.dart';

class AddressForm extends StatefulWidget {
  final Function(Address) onAddressSelected;

  const AddressForm({super.key, required this.onAddressSelected});

  @override
  State<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  Region? selectedRegion;
  City? selectedCity;
  final TextEditingController streetController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Viloyatlarni yuklash
    context.read<RegionsBloc>().add(GetRegionsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // REGION
                const Text("Viloyat", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                BlocBuilder<RegionsBloc, RegionsState>(
                  builder: (context, state) {
                    if (state is GetRegionsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is GetRegionsSucces) {
                      // Viloyat selected value filter
                      final regions = state.regions;
                      final regionValue = regions.contains(selectedRegion)
                          ? selectedRegion
                          : null;

                      return DropdownButtonFormField<Region>(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Viloyatni tanlang",
                        ),
                        value: regionValue,
                        validator: (value) =>
                            value == null ? "Viloyatni tanlang" : null,
                        items: regions
                            .map((r) => DropdownMenuItem(
                                  value: r,
                                  child: Text(r.nameUz),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedRegion = value;
                            selectedCity = null;
                          });
                          if (value != null) {
                            context
                                .read<GetCitiesBloc>()
                                .add(GetAllCitiesEvent());
                          }
                        },
                      );
                    } else {
                      return const Text("Viloyatlarni yuklashda xatolik yuz berdi");
                    }
                  },
                ),
                const SizedBox(height: 20),

                // CITY
                const Text("Shahar / Tuman",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                BlocBuilder<GetCitiesBloc, GetCitiesState>(
                  builder: (context, state) {
                    if (state is GetCitiesLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is GetCitiesSuccess) {
                      // Faqat tanlangan viloyatga tegishli shaharlar
                      final filteredCities = state.cities
                          .where((c) => c.region == selectedRegion?.id)
                          .toList();

                      // SelectedCity filter
                      final cityValue = filteredCities.contains(selectedCity)
                          ? selectedCity
                          : null;

                      return DropdownButtonFormField<City>(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Shahar / Tumanni tanlang",
                        ),
                        value: cityValue,
                        validator: (value) =>
                            value == null ? "Shahar / Tumanni tanlang" : null,
                        items: filteredCities
                            .map((c) => DropdownMenuItem(
                                  value: c,
                                  child: Text(c.nameUz),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCity = value;
                          });
                        },
                      );
                    } else {
                      return DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Shahar / Tumanni tanlang",
                        ),
                        items: const [],
                        onChanged: null,
                      );
                    }
                  },
                ),
                const SizedBox(height: 20),

                // STREET
                const Text("Ko'cha", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: streetController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Ko'changiz nomini kiriting",
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? "Ko'cha nomi bo'sh bo'lishi mumkin emas"
                      : null,
                ),
                const SizedBox(height: 30),

                // CONFIRM BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate() &&
                          selectedRegion != null &&
                          selectedCity != null) {
                        final address = Address(
                          region: selectedRegion!,
                          city: selectedCity!,
                          street: streetController.text,
                        );

                        widget.onAddressSelected(address);
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Tasdiqlash",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
