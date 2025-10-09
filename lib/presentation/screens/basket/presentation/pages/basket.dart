import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gold_house/bloc/business_selection/business_selection_bloc.dart';
import 'package:gold_house/core/basket_notifier.dart';
import 'package:gold_house/core/constants/app_imports.dart';
import 'package:gold_house/core/langugage_notifier.dart';
import 'package:gold_house/presentation/screens/basket/presentation/formalize_product.dart';
import 'package:hive/hive.dart';

class BasketPage extends StatefulWidget {
  const BasketPage({super.key});

  @override
  State<BasketPage> createState() => _BasketPageState();
}

class _BasketPageState extends State<BasketPage> {
  late StreamSubscription<BoxEvent> _subscription;
  List<BasketModel> basketList = [];
  Map<String, bool> selected = {};
  bool selectAll = true;
  bool isInstallment = false;
  final String? token = SharedPreferencesService.instance.getString("access");
  final String? deliveryAddress = SharedPreferencesService.instance.getString("selected_city");

  @override
  void initState() {
    super.initState();
    _loadBasket();
    _subscription = HiveBoxes.basketData.watch().listen((event) {
      setState(() {
        _loadBasket();
      });
    });
  }

  void _loadBasket() {
    basketList = HiveBoxes.basketData.values.toList();
    BasketNotifier.productCount.value = basketList.fold(0, (sum, product) => sum + (int.parse(product.quantity ?? "1")));
    SharedPreferencesService.instance.saveString('basketProductCount', basketList.fold(0, (sum, product) => sum + (int.parse(product.quantity ?? "1"))).toString());
  }

  double getTotal(List<BasketModel> filteredList, Map<String, bool> selected) {
    double sum = 0;
    for (final product in filteredList) {
      if (selected[product.productId] ?? false) {
        sum += double.parse(product.price) * (int.parse(product.quantity ?? "1"));
      }
    }
    return sum;
  }

  int getTotalItems(List<BasketModel> filteredList, Map<String, bool> selected) {
    int sum = 0;
    for (final product in filteredList) {
      if (selected[product.productId] ?? false) {
        sum += int.parse(product.quantity ?? "1");
      }
    }
    return sum;
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SharedPreferencesService.instance.saveString('newBasketProduct', '0');
    BasketNotifier.updateNewBasketProduct("0");

    return ValueListenableBuilder<String>(
      valueListenable: LanguageNotifier.selectedLanguage,
      builder: (context, language, child) {
        return BlocBuilder<BusinessSelectionBloc, BusinessSelectionState>(
          builder: (context, businessState) {
            String selectedBusiness = "Stroy Baza №1";
            int selectedBranch = 0;

            if (businessState is BusinessSelectedState) {
              selectedBusiness = businessState.selectedBusiness;
              selectedBranch = businessState.selectedIndex;
            }

            final filteredList = basketList.where((product) => product.branchName == selectedBranch.toString()).toList();


            for (final product in filteredList) {
              selected.putIfAbsent(product.productId, () => true);
            }

            // Check if all are selected for selectAll
            selectAll = filteredList.every((product) => selected[product.productId] ?? false);

            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: Text('cart'.tr(), style: const TextStyle(color: Colors.black)),
                backgroundColor: AppColors.primaryColor,
                actions: [
                  IconButton(
                    onPressed: () {
                      HiveBoxes.basketData.clear();
                      setState(() {
                        basketList = [];
                        selected.clear();
                        BasketNotifier.productCount.value = 0;
                        SharedPreferencesService.instance.saveString('basketProductCount', '0');
                      });
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
              body: basketList.isEmpty || filteredList.isEmpty
                  ? Center(child: Text("cart_empty".tr()))
                  : Padding(
                      padding: EdgeInsets.all(8.r),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("select_all".tr(), style: TextStyle(fontSize: 16)),
                              Checkbox(
                                side: BorderSide(color: AppColors.primaryColor),
                                activeColor: AppColors.primaryColor,
                                value: selectAll,
                                onChanged: (v) {
                                  setState(() {
                                    selectAll = v ?? false;
                                    for (final product in filteredList) {
                                      selected[product.productId] = selectAll;
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          Expanded(
                            child: ListView.builder(
                              itemCount: filteredList.length,
                              itemBuilder: (context, index) {
                                final product = filteredList[index];

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: EdgeInsets.all(10.r),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Image.network(
                                        "https://backkk.stroybazan1.uz${product.image}",
                                        width: 80.w,
                                        height: 80.h,
                                        fit: BoxFit.contain,
                                      ),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              product.title,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14.sp,
                                              ),
                                            ),
                                            SizedBox(height: 6.h),
                                            Row(
                                              children: [
                                                Text(
                                                  "size".tr() + ": ${product.size}",
                                                  style: TextStyle(fontSize: 12.sp),
                                                ),
                                                SizedBox(width: 10),
                                                product.color != ""
                                                    ? Text(
                                                        "Rang: ${product.color}",
                                                        style: TextStyle(fontSize: 12.sp),
                                                      )
                                                    : const SizedBox(),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              "${product.price} ${'currency'.tr()}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13.sp,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            SizedBox(height: 8.h),
                                            Container(
                                              width: 150.w,
                                              decoration: BoxDecoration(
                                                border: Border.all(color: Colors.grey.shade300),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                children: [
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.remove,
                                                      color: (int.parse(product.quantity ?? "1") > 1) ? AppColors.primaryColor : Colors.grey,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        if (int.parse(product.quantity ?? "1") > 1) {
                                                          product.quantity = (int.parse(product.quantity ?? "1") - 1).toString();
                                                          HiveBoxes.basketData.put(product.productId, product);
                                                          BasketNotifier.productCount.value = basketList.fold(0, (sum, p) => sum + (int.parse(p.quantity ?? "1")));
                                                          SharedPreferencesService.instance.saveString(
                                                              'basketProductCount', BasketNotifier.productCount.value.toString());
                                                        } else {
                                                          HiveBoxes.basketData.delete(product.productId);
                                                          basketList.removeWhere((e) => e.productId == product.productId);
                                                          selected.remove(product.productId);
                                                          BasketNotifier.productCount.value = basketList.fold(0, (sum, p) => sum + (int.parse(p.quantity ?? "1")));
                                                          SharedPreferencesService.instance.saveString(
                                                              'basketProductCount', BasketNotifier.productCount.value.toString());
                                                        }
                                                      });
                                                    },
                                                  ),
                                                  Expanded(
                                                    child: InkWell(
                                                      onTap: () async {
                                                        final result = await showModalBottomSheet<int>(
                                                          context: context,
                                                          isScrollControlled: true,
                                                          backgroundColor: Colors.transparent,
                                                          builder: (context) {
                                                            final controller = TextEditingController(
                                                              text: (product.quantity ?? 1).toString(),
                                                            );
                                                            return Padding(
                                                              padding: EdgeInsets.only(
                                                                bottom: MediaQuery.of(context).viewInsets.bottom,
                                                              ),
                                                              child: Container(
                                                                margin: EdgeInsets.symmetric(horizontal: 20.r, vertical: 50.h),
                                                                padding: EdgeInsets.all(20.r),
                                                                decoration: BoxDecoration(
                                                                  color: Colors.white,
                                                                  borderRadius: BorderRadius.circular(20.r),
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: Colors.black26,
                                                                      blurRadius: 10,
                                                                      offset: Offset(0, 4),
                                                                    ),
                                                                  ],
                                                                ),
                                                                child: Column(
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  children: [
                                                                    Text(
                                                                      "Enter quantity".tr(),
                                                                      style: TextStyle(
                                                                        fontSize: 18.sp,
                                                                        fontWeight: FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                    SizedBox(height: 15.h),
                                                                    TextField(
                                                                      controller: controller,
                                                                      keyboardType: TextInputType.number,
                                                                      textAlign: TextAlign.center,
                                                                      style: TextStyle(fontSize: 16.sp),
                                                                      decoration: InputDecoration(
                                                                        border: OutlineInputBorder(
                                                                          borderRadius: BorderRadius.circular(10.r),
                                                                        ),
                                                                        hintText: "Number",
                                                                      ),
                                                                    ),
                                                                    SizedBox(height: 20.h),
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                      children: [
                                                                        ElevatedButton(
                                                                          style: ElevatedButton.styleFrom(
                                                                            backgroundColor: Colors.grey[300],
                                                                            shape: RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(10.r),
                                                                            ),
                                                                          ),
                                                                          onPressed: () => Navigator.pop(context),
                                                                          child: Text(
                                                                            "Cancel".tr(),
                                                                            style: TextStyle(color: Colors.black),
                                                                          ),
                                                                        ),
                                                                        ElevatedButton(
                                                                          style: ElevatedButton.styleFrom(
                                                                            backgroundColor: AppColors.primaryColor,
                                                                            shape: RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(10.r),
                                                                            ),
                                                                          ),
                                                                          onPressed: () {
                                                                            final val = int.tryParse(controller.text);
                                                                            Navigator.pop(context, val);
                                                                          },
                                                                          child: Text(
                                                                            "OK".tr(),
                                                                            style: const TextStyle(color: Colors.white),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        );

                                                        if (result != null && result >= 1) {
                                                          setState(() {
                                                            product.quantity = result.toString();
                                                            HiveBoxes.basketData.put(product.productId, product);
                                                            BasketNotifier.productCount.value = basketList.fold(0, (sum, p) => sum + (int.parse(p.quantity ?? "1")));
                                                            SharedPreferencesService.instance.saveString(
                                                                'basketProductCount', BasketNotifier.productCount.value.toString());
                                                          });
                                                        } else {
                                                          setState(() {
                                                            HiveBoxes.basketData.delete(product.productId);
                                                            basketList.removeWhere((e) => e.productId == product.productId);
                                                            selected.remove(product.productId);
                                                            BasketNotifier.productCount.value = basketList.fold(0, (sum, p) => sum + (int.parse(p.quantity ?? "1")));
                                                            SharedPreferencesService.instance.saveString(
                                                                'basketProductCount', BasketNotifier.productCount.value.toString());
                                                          });
                                                        }
                                                      },
                                                      child: Container(
                                                        width: 110.w,
                                                        height: 40,
                                                        color: Colors.white,
                                                        alignment: Alignment.center,
                                                        child: Text(
                                                          (product.quantity ?? 1).toString(),
                                                          textAlign: TextAlign.center,
                                                          maxLines: 1,
                                                          overflow: TextOverflow.visible,
                                                          style: TextStyle(fontSize: 16.sp),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(Icons.add),
                                                    onPressed: () {
                                                      setState(() {
                                                        product.quantity = (int.parse(product.quantity ?? "1") + 1).toString();
                                                        HiveBoxes.basketData.put(product.productId, product);
                                                        BasketNotifier.productCount.value = basketList.fold(0, (sum, p) => sum + (int.parse(p.quantity ?? "1")));
                                                        SharedPreferencesService.instance.saveString(
                                                            'basketProductCount', BasketNotifier.productCount.value.toString());
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Checkbox(
                                        side: BorderSide(color: AppColors.primaryColor),
                                        activeColor: AppColors.primaryColor,
                                        value: selected[product.productId] ?? false,
                                        onChanged: (v) {
                                          setState(() {
                                            selected[product.productId] = v ?? false;
                                            selectAll = filteredList.every((p) => selected[p.productId] ?? false);
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Jami:",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      "Jami ${getTotalItems(filteredList, selected)} ta maxsulot",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${'general'.tr()}:',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      "${getTotal(filteredList, selected).toStringAsFixed(3)} ${'currency'.tr()}",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 30.h),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: 55,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFD8BB6C),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                if (token == null) {
                                  CustomAwesomeDialog.showInfoDialog(
                                    context,
                                    title: "error".tr(),
                                    desc: "register_first".tr(),
                                    dialogtype: DialogType.error,
                                    onOkPress: () {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const SignUpScreen(),
                                        ),
                                        (route) => false,
                                      );
                                    },
                                  );
                                } else {
                                  final selectedProducts = <BasketModel>[];
                                  for (final product in filteredList) {
                                    if (selected[product.productId] ?? false) {
                                      selectedProducts.add(product);
                                    }
                                  }

                                  if (selectedProducts.isEmpty) {
                                    CustomAwesomeDialog.showInfoDialog(
                                      context,
                                      title: "error".tr(),
                                      desc: "please_select_product".tr(),
                                      dialogtype: DialogType.error,
                                    );
                                    return;
                                  }

                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => FormalizeProduct(
                                        total_price: getTotal(filteredList, selected),
                                        purchuaseProductList: selectedProducts,
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text(
                                "checkout".tr(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            );
          },
        );
      },
    );
  }
}