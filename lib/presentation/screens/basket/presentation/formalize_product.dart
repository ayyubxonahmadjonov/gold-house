import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gold_house/bloc/branches/branches_bloc.dart';
import 'package:gold_house/bloc/create_order/create_order_bloc.dart';
import 'package:gold_house/bloc/regions/regions_bloc.dart';
import 'package:gold_house/core/shared/custom_awesome_dialog.dart';
import 'package:gold_house/data/datasources/local/hive_helper/hive_names.dart';
import 'package:gold_house/data/datasources/local/shared_preferences/shared_service.dart';
import 'package:gold_house/data/models/basket_model.dart';
import 'package:gold_house/presentation/screens/basket/presentation/pages/payment_option.dart';
import 'package:gold_house/presentation/screens/main/main_screen.dart';
import 'package:gold_house/presentation/widgets/select_pickup_dialog.dart';

class FormalizeProduct extends StatefulWidget {
  String total_price;
  FormalizeProduct({super.key, required this.total_price});

  @override
  State<FormalizeProduct> createState() => _FormalizeProductState();
  final List<String> paymentMethods = [
    "Click",
    "Payme",
    "Qabul qilinganda",
    "Muddatli to'lov",
  ];
}

class _FormalizeProductState extends State<FormalizeProduct> {
  List<int> productIdList = [];
  List<int> variantIdList = [];
  List<int> quantityList = [];

  String selectedDelivery = "";
  String? selectedPayment;
  List<BasketModel> purchuaseProductList = HiveBoxes.basketData.values.toList();
  String fullname =
      SharedPreferencesService.instance.getString("profilfullname") ?? "";
  String phone = SharedPreferencesService.instance.getString("phone") ?? "";
  bool isInstallment = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: const Text("Buyurtma"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle("Qabul qiluvchi"),
            Card(
              child: ListTile(
                leading: const Icon(Icons.person),
                title: Text(fullname),
                subtitle: Text(phone),
              ),
            ),
            const SizedBox(height: 16),
            _sectionTitle("Mahsulotlar"),
            ListView.builder(
              shrinkWrap: true,
              itemCount: purchuaseProductList.length,
              itemBuilder: (context, index) {
                productIdList.add(
                  int.parse(purchuaseProductList[index].productId),
                );
                variantIdList.add(purchuaseProductList[index].variantId);
                quantityList.add(
                  int.parse(purchuaseProductList[index].quantity!),
                );
                final product = purchuaseProductList[index];
                return Container(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        "https://backkk.stroybazan1.uz${product.image}",
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      product.title,
                      style: TextStyle(fontSize: 17),
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      "${product.price} so'm",
                      style: TextStyle(fontSize: 15),
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Text(
                      "${product.quantity} dona",
                      style: TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              },
            ),

            //   const SizedBox(height: 16),
            //   _sectionTitle("Qabul qilish usuli"),
            // CustomSelectable2Widget(isInstallment: isInstallment,title1: "Olib ketish", title2: "Yetkazib berish"),
            MultiBlocListener(
              listeners: [
                BlocListener<BranchesBloc, BranchesState>(
                  listener: (context, state) {
                    if (state is GetBranchesSuccess) {
                      showDialog(
                        context: context,
                        builder:
                            (context) =>
                                SelectPickupDialog(branches: state.branches),
                      );
                    }
                  },
                ),
                BlocListener<RegionsBloc, RegionsState>(
                  listener: (context, state) {
                    if (state is GetRegionsSucces) {}
                  },
                ),
              ],
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: Icon(
                  Icons.location_on,
                  color: Colors.redAccent,
                  size: 28,
                ),
                title: Text(
                  "Yetkazib berish usulini tanlang",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  "Yaqin filiallardan birini tanlashingiz mumkin",
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                  size: 28,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
                onTap: () => _chooseDeliveryMethod(context),
              ),
            ),
            SizedBox(height: 16),
            _sectionTitle("Keshbekni ishlatish"),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Keshbek: 0 so'm",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Checkbox(value: true, onChanged: (_) {}),
              ],
            ),
            const SizedBox(height: 16),
            _sectionTitle("To‘lov usuli"),
            PaymentSelector(
              paymentMethods: [
                PaymentOption(
                  title: "Click",
                  assetIcon: "click.png",
                  isCredit: false,
                ),
                PaymentOption(
                  title: "Payme",
                  assetIcon: "payme.png",
                  isCredit: false,
                ),
                PaymentOption(
                  title: "Qabul qilinganda",
                  assetIcon: "bring.png",
                  isCredit: false,
                ),
                PaymentOption(
                  title: "Muddatli to‘lov",
                  assetIcon: "delivery.png",
                  isCredit: true,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Card(
            //   color: Colors.grey.shade100,
            //   child: ListTile(
            //     leading: const Icon(Icons.account_balance_wallet),
            //     title: const Text("Muddatli to‘lov turi: Alif"),
            //     subtitle: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: const [
            //         Text("Oylik to‘lov: 119,250 so‘m"),
            //         Text("Muddati: 12 oy"),
            //         Text("Jami: 1,431,000 so‘m"),
            //       ],
            //     ),
            //   ),
            // ),
            const SizedBox(height: 24),

            // Yakuniy summa
            _sectionTitle("Sizning buyurtmangiz"),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${purchuaseProductList.length} ta mahsulot narxi:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "1,431,000 so‘m",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Muddatli to‘lov: ",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "12 oy",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Oylik to‘lov:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "119,250 so‘m",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  const Divider(),
                  const SizedBox(height: 15),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Jami:",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        widget.total_price,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),

            // Tugma
            BlocConsumer<CreateOrderBloc, CreateOrderState>(
              listener: (context, state) {
               if(state is CreateOrderSuccess){
           CustomAwesomeDialog.showInfoDialog(
            dismissOnTouchOutside: false,
  context,
  dialogtype: DialogType.success,
  title: "Buyurtma yaratildi",
  desc: "Buyurtmangiz muvaffaqiyatli yaratildi",
  onOkPress: () {
    HiveBoxes.basketData.clear();
    Navigator.push(context, MaterialPageRoute(builder: (context) => const MainScreen()));
  },
);

                
               }
              },
              builder: (context, state) {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      print(productIdList);
                      print(variantIdList);
                      print(quantityList);

                      BlocProvider.of<CreateOrderBloc>(context).add(
                        GenerateOrderEvent(
                          productId: productIdList,
                          variantId: variantIdList,
                          quantity: quantityList,
                          deliveryAddress: '',
                          paymentMethod: 'click',
                          useCashback: false,
                          branchId: 1,
                          part: 1,
                          status: 'pending',
                          delivery_method: selectedDelivery,
                        ),
                      );
                    },
                          style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD8BB6C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child:  Text("Xaridni rasmiylashtirish",style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _chooseDeliveryMethod(BuildContext context) async {
    final result = await showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Yetkazib berish usulini tanlang",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.delivery_dining, color: Colors.green),
                title: Text("Yetkazib berish"),
                subtitle: Text("Buyurtma manzilingizga yetkaziladi"),
                onTap: () {
                  Navigator.pop(context, "delivery");
                  setState(() {
                    selectedDelivery = "delivery";
                  });
                },
              ),
              ListTile(
                leading: Icon(Icons.storefront, color: Colors.blue),
                title: Text("Olib ketish"),
                subtitle: Text("Do‘kondan o‘zingiz olib ketasiz"),
                onTap: () {
                  Navigator.pop(context, "pickup");
                  setState(() {
                    selectedDelivery = "pickup";
                  });
                },
              ),
            ],
          ),
        );
      },
    );
    if (result == "delivery") {
      BlocProvider.of<RegionsBloc>(context).add(GetRegionsEvent());
    } else if (result == "pickup") {
      BlocProvider.of<BranchesBloc>(context).add(GetBranchesEvent());
    }

    print("Tanlangan usul: $result");
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
      ),
    );
  }
}
