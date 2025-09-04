import 'package:easy_localization/easy_localization.dart';
import 'package:gold_house/core/constants/app_imports.dart';
import 'package:gold_house/presentation/screens/basket/presentation/pages/pasport_data.dart';
import 'package:gold_house/presentation/widgets/addres_form.dart';

class FormalizeProduct extends StatefulWidget {
  double total_price;
  FormalizeProduct({super.key, required this.total_price});
  @override
  State<FormalizeProduct> createState() => _FormalizeProductState();
}

class _FormalizeProductState extends State<FormalizeProduct> {
  List<int> productIdList = [];
  List<int> variantIdList = [];
  List<int> quantityList = [];
  String selectedDelivery = "";
  String selectedPayment = "";
  String deliveryAddress = "";
  int selectedBranchId = 0;
  bool useCashback = false;
  double cashback = 0;
  List<BasketModel> purchuaseProductList = HiveBoxes.basketData.values.toList();
  String selected_business= "";
  
  
  int id = 0;
  @override
  void initState() {
    super.initState();
    selected_business = SharedPreferencesService.instance.getString("selected_business") ?? "";
    id = SharedPreferencesService.instance.getInt("user_id") ?? 0;
    BlocProvider.of<GetUserDataBloc>(
      context,
    ).add(GetUserAllDataEvent(id: id.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.white,
        title: const Text("Buyurtma"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle("receiver".tr()),
            BlocBuilder<GetUserDataBloc, GetUserDataState>(
              builder: (context, state) {
                if (state is GetUserDataSuccess) {
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.person),
                      title: Text("${state.user.firstName} ${state.user.lastName}"),
                      subtitle: Text(state.user.phoneNumber),
                      ),
                  );
                }
                return const SizedBox();
              },
            ),
            const SizedBox(height: 16),
            _sectionTitle("Mahsulotlar"),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: ListView.builder(
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
                        "${product.price} ${'currency'.tr()}",
                        style: TextStyle(fontSize: 15),
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(
                        "${product.quantity} ${'piece'.tr()}",
                        style: TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                },
              ),
            ),
            MultiBlocListener(
              listeners: [
                BlocListener<BranchesBloc, BranchesState>(
                  listener: (context, state) {
                    if (state is GetBranchesSuccess) {
                    
                      showDialog(
                        context: context,
                        builder:
                            (context) => SelectPickupDialog(
                              branches: state.branches,
                              onSelected: (value) {
                                setState(() {
                                  deliveryAddress = value.addressUz;
                                  selectedBranchId = value.id;
                                });
                              },
                            ),
                      );
                    }
                  },
                ),
                BlocListener<RegionsBloc, RegionsState>(
                  listener: (context, state) {
                    if (state is GetRegionsSucces) {

                    }
                  },
                ),
                BlocListener<UpdatePaymentBloc, UpdatePaymentState>(
                  listener: (context, state) {

                    if (state is UpdatePaymentSuccess) {
                    launchUrl(Uri.parse(state.paymentLink));
                    Future.delayed(Duration(seconds: 5), () {
                     CustomAwesomeDialog.showInfoDialog(
                      dismissOnTouchOutside: false,
                      context,
                      dialogtype: DialogType.success,
                      title: "Buyurtma yaratildi",
                      desc: "Buyurtmangiz muvaffaqiyatli yaratildi",
                      onOkPress: () {
                        HiveBoxes.basketData.clear();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const MainScreen()),
                        );
                      },
                    );
                    });
              
                    }
                  },
                ),
              ],
              child: Padding(
                padding: const EdgeInsets.only(top: 15),
                child: ListTile(
                
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
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
                    selectedDelivery.isEmpty
                        ? "Yaqin filiallardan birini tanlashingiz mumkin"
                        :deliveryAddress,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
            ),
            SizedBox(height: 16),
            cashback == 0.00
                ? const SizedBox()
                : _sectionTitle("Keshbekni ishlatish"),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: BlocConsumer<GetUserDataBloc, GetUserDataState>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is GetUserDataSuccess) {
                    final user = state.user;
                    cashback = double.parse(user.cashbackBalance);

                    if (cashback == 0.00) return const SizedBox();

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Keshbek: $cashback ${'currency'.tr()}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Checkbox(
                          value: useCashback,
                          onChanged: (value) {
                            setState(() {
                              useCashback = value!;
                            });
                          },
                        ),
                      ],
                    );
                  } else if (state is GetUserDataError) {
                    return Text(state.message);
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),

            const SizedBox(height: 10),
            _sectionTitle("To‘lov usuli"),
            PaymentSelector(
              paymentMethods: [
                PaymentOption(
                  code: "click",
                  title: "Click",
                  assetIcon: "click.png",
                  isCredit: false,
                ),
                PaymentOption(
                  code: "payme",
                  title: "Payme",
                  assetIcon: "payme.png",
                  isCredit: false,
                ),
                PaymentOption(
                  code: "cash",
                  title: "pay_on_delivery".tr(),
                  assetIcon: "bring.png",
                  isCredit: false,
                ),
                PaymentOption(
                  code: "installments_payment",
                  title: "Muddatli to‘lov",
                  assetIcon: "delivery.png",
                  isCredit: true,
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedPayment = value;
                });
              },
            ),
            const SizedBox(height: 40),
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
            // )
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
                        "${widget.total_price} so‘m",
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
                  TotalPriceWidget(
                    totalPrice: widget.total_price,
                    useCashback: useCashback,
                    cashback: cashback,
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),

            // Tugma
            BlocConsumer<CreateOrderBloc, CreateOrderState>(
              listener: (context, state) {
                if (state is CreateOrderSuccess) {
                  print("Buyurtma muvaffaqiyatli yaratildi");
                  bool isValid =
                      selectedPayment.isNotEmpty && selectedDelivery.isNotEmpty;

                  if (!isValid) {
                    CustomAwesomeDialog.showInfoDialog(
                      context,
                      dialogtype: DialogType.error,
                      title: "error".tr(),
                      desc: "Iltimos, to‘lov turi va yetkazib berishni tanlang",
                      onOkPress: () {},
                    );
                    return;
                  }

                  if (selectedPayment == "cash") {
                    CustomAwesomeDialog.showInfoDialog(
                      dismissOnTouchOutside: false,
                      context,
                      dialogtype: DialogType.success,
                      title: "Buyurtma yaratildi",
                      desc: "Buyurtmangiz muvaffaqiyatli yaratildi",
                      onOkPress: () {
                        HiveBoxes.basketData.clear();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const MainScreen()),
                        );
                      },
                    );
                  }
                  
                  else if (selectedPayment == "installments_payment") {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => const PassportFormPage())); 
                  }
                   else if (selectedPayment == "payme" ||
                      selectedPayment == "click") {
                    context.read<UpdatePaymentBloc>().add(
                      PaymentEvent(
                        orderId: state.orderId,
                        paymentMethod: selectedPayment,
                      ),
                    );
                  } else {
                    CustomAwesomeDialog.showInfoDialog(
                      context,
                      dialogtype: DialogType.error,
                      title: "error".tr(),
                      desc: "To‘lov turi noto‘g‘ri tanlandi",
                      onOkPress: () {},
                    );
                  }
                }
              },
              builder: (context, state) {
                return SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<CreateOrderBloc>().add(
                        GenerateOrderEvent(
                          productId: productIdList,
                          variantId: variantIdList,
                          quantity: quantityList,
                          deliveryAddress: deliveryAddress,
                          paymentMethod: selectedPayment,
                          useCashback: useCashback,
                          branchId: selectedBranchId,
                          part: 1,
                          status: 'in_payment',
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
                    child:  Text(
                      "complete_purchase".tr(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),
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
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => AddressForm(
                            onAddressSelected: (address) {
                              setState(() {
                                deliveryAddress =
                                    "${address.region.nameUz}, ${address.city.nameUz}, ${address.street}";
                              });
                            },
                          ),
                    ),
                  );

                  setState(() {
                    selectedDelivery = "delivery";
                  });

                  Navigator.pop(context, "delivery");
                },
              ),
              ListTile(
                leading: Icon(Icons.storefront, color: Colors.blue),
                title: Text("pickup".tr()),
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
