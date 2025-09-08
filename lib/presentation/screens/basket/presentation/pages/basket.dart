import 'package:easy_localization/easy_localization.dart';
import 'package:gold_house/presentation/screens/basket/presentation/formalize_product.dart';

import '../../../../../core/constants/app_imports.dart';

class BasketPage extends StatefulWidget {
  const BasketPage({super.key});

  @override
  State<BasketPage> createState() => _BasketPageState();
}

class _BasketPageState extends State<BasketPage> {
  late List<bool> selected;
  late List<int> quantity;
  bool selectAll = true;
  bool isInstallment = false;
  List<BasketModel> basketList = HiveBoxes.basketData.values.toList();
  final token = SharedPreferencesService.instance.getString("access");
  final delivery_address = SharedPreferencesService.instance.getString(
    "selected_city",
  );
  @override
  void initState() {
    super.initState();
    selected = List.generate(basketList.length, (index) => true);
    quantity = List.generate(basketList.length, (index) => 1);
  }

  double get total {
    double sum = 0;
    for (int i = 0; i < basketList.length; i++) {
      if (selected[i]) {
        sum += (double.parse(basketList[i].price) * quantity[i]);
        basketList[i].quantity = quantity[i].toString();
        HiveBoxes.basketData.put(basketList[i].productId, basketList[i]);
      }
    }
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('cart'.tr(), style: TextStyle(color: Colors.black)),
        backgroundColor: AppColors.primaryColor,
        actions: [
          IconButton(
            onPressed: () {
              HiveBoxes.basketData.clear();
              basketList.clear();
              selected.clear();
              quantity.clear();
              setState(() {});
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body:
          basketList.isEmpty
              ? Center(child: Text("cart_empty".tr()))
              : Padding(
                padding: EdgeInsets.all(8.r),
                child: Column(
                  children: [
                    // "Hammasini tanlash"
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
                              for (int i = 0; i < selected.length; i++) {
                                selected[i] = selectAll;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),

                    // Mahsulotlar listi
                    Container(
                      height: MediaQuery.of(context).size.height * 0.52,
                      child: ListView.builder(
                        itemCount: basketList.length,
                        itemBuilder: (context, index) {
                          final product = basketList[index];

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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                ),
                                              )
                                              : const SizedBox(),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "${product.price} so‘m",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13.sp,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                    Container(
  width: 120.w,
  decoration: BoxDecoration(
    border: Border.all(color: Colors.grey.shade300),
    borderRadius: BorderRadius.circular(8),
  ),
  child: Row(
    children: [
      IconButton(
        icon: const Icon(Icons.remove),
        onPressed: () {
          setState(() {
            if (quantity[index] > 1) {
              quantity[index]--;
            }
          });
        },
      ),

Expanded(
  child: InkWell(
    onTap: () async {
      final result = await showModalBottomSheet<int>(
        context: context,
        isScrollControlled: true, // keyboard paydo bo‘lganda to‘liq chiqadi
        backgroundColor: Colors.transparent, // chetki rang shaffof bo‘lsin
        builder: (context) {
          final controller = TextEditingController(text: quantity[index].toString());
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
                  )
                ],
              ),
            ),
          );
        },
      );

      if (result != null && result > 0) {
        setState(() {
          quantity[index] = result;
        });
      }
    },
    child: Text(
      quantity[index].toString(),
      textAlign: TextAlign.center,
      maxLines: 2,
      style:  TextStyle(fontSize: 16.sp),
    ),
  ),
),

      IconButton(
        icon: const Icon(Icons.add),
        onPressed: () {
          setState(() {
            quantity[index]++;
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
                                  side: BorderSide(
                                    color: AppColors.primaryColor,
                                  ),
                                  activeColor: AppColors.primaryColor,
                                  value: selected[index],
                                  onChanged: (v) {
                                    setState(() {
                                      selected[index] = v ?? false;
                                      selectAll = !selected.contains(false);
                                    });
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    // Payment switch
              

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${'general'.tr()}:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "${total.toStringAsFixed(3)} ${'currency'.tr()}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        FormalizeProduct(total_price: total),
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
  }
}
