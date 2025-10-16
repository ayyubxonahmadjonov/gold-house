import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:gold_house/core/constants/app_imports.dart';
import 'package:gold_house/presentation/screens/basket/presentation/pages/pasport_data.dart';
import 'package:gold_house/presentation/screens/basket/presentation/pages/user_agreements.dart';
import 'package:gold_house/presentation/widgets/addres_form.dart';

class FormalizeProduct extends StatefulWidget {
  double total_price;
  List<BasketModel> purchuaseProductList;
  FormalizeProduct({
    super.key,
    required this.total_price,
    required this.purchuaseProductList,
  });
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
  int? selectedBranchId;

  int selectedBusinessId = 0;
  bool useCashback = false;
  double cashback = 0;
  String selected_business = "";
            bool _orderHandled = false;

  String paymentType = "";

  int id = 0;
  @override
  void initState() {
    super.initState();
    deliveryAddress =
        SharedPreferencesService.instance.getString("delivery_address") ?? "";
    selectedDelivery =
        SharedPreferencesService.instance.getString("selected_delivery") ?? "";
    selected_business =
        SharedPreferencesService.instance.getString("selected_business") ?? "";
    id = SharedPreferencesService.instance.getInt("user_id") ?? 0;

    BlocProvider.of<GetUserDataBloc>(
      context,
    ).add(GetUserAllDataEvent(id: id.toString()));

    for (var product in widget.purchuaseProductList) {
      productIdList.add(int.parse(product.productId));
      variantIdList.add(product.variantId);
      quantityList.add(int.parse(product.quantity!));
    }
    if (selected_business == "Stroy Baza №1") {
      selectedBusinessId = 0;
    } else if (selected_business == "Giaz Mebel") {
      selectedBusinessId = 1;
    } else if (selected_business == "Goldklinker") {
      selectedBusinessId = 2;
    } else {
      selectedBusinessId = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final monthlyPrice6 = selectedPayment == "installments_payment"
        ? (widget.total_price * 1.26 / 6).toStringAsFixed(2)
        : '';
    final monthlyPrice12 = selectedPayment == "installments_payment"
        ? (widget.total_price * 1.42 / 12).toStringAsFixed(2)
        : '';
    final monthlyPrice15 = selectedPayment == "installments_payment"
        ? (widget.total_price * 1.50 / 15).toStringAsFixed(2)
        : '';
    final monthlyPrice18 = selectedPayment == "installments_payment"
        ? (widget.total_price * 1.56 / 18).toStringAsFixed(2)
        : '';
    final monthlyPrice24 = selectedPayment == "installments_payment"
        ? (widget.total_price * 1.75 / 24).toStringAsFixed(2)
        : '';

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
                      title: Text(
                        "${state.user.firstName} ${state.user.lastName}",
                      ),
                      subtitle: Text(state.user.phoneNumber),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
            const SizedBox(height: 16),
            _sectionTitle("products".tr()),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.purchuaseProductList.length,
                itemBuilder: (context, index) {
                  final product = widget.purchuaseProductList[index];
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
                        builder: (context) => SelectPickupDialog(
                          branches: state.branches,
                          onSelected: (value) {
                            setState(() {
                              deliveryAddress = value.addressUz;
                              selectedBranchId = value.id;
                              selectedDelivery = "pickup";
                              SharedPreferencesService.instance.saveString(
                                "delivery_address",
                                value.addressUz,
                              );
                              SharedPreferencesService.instance.saveString(
                                "selected_delivery",
                                "pickup",
                              );
                            });
                          },
                        ),
                      );
                    }
                  },
                ),
                BlocListener<RegionsBloc, RegionsState>(
                  listener: (context, state) {},
                ),
                BlocListener<UpdatePaymentBloc, UpdatePaymentState>(
                  listener: (context, state) {
                    if (state is UpdatePaymentSuccess) {
                      launchUrl(
                        Uri.parse(state.paymentLink),
                        mode: LaunchMode.inAppBrowserView,
                      );

                      Future.delayed(Duration(seconds: 5), () {
                        CustomAwesomeDialog.showInfoDialog(
                          dismissOnTouchOutside: false,
                          context,
                          dialogtype: DialogType.success,
                          title: "Buyurtma yaratildi",
                          desc: "Buyurtmangiz muvaffaqiyatli yaratildi",
                          onOkPress: () {
                            HiveBoxes.basketData.clear();
                                       Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
  MaterialPageRoute(builder: (context) => const MainScreen()),
  (route) => false,
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
                    "choose_delivery".tr(),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    _getSubtitleText(),
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
            const SizedBox(height: 16),
            BlocConsumer<GetUserDataBloc, GetUserDataState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state is GetUserDataSuccess) {
                  final user = state.user;
                  cashback = double.parse(user.cashbackBalance ?? "0");

                  if (cashback <= 0.00) return const SizedBox();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle("Keshbekni ishlatish"),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
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
                        ),
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
            const SizedBox(height: 10),
            _sectionTitle("payment_method".tr()),
            PaymentSelector(
              paymentMethods: [
                PaymentOption(
                  code: "click",
                  title: "Click",
                  assetIcon: "click.jpg",
                  isCredit: false,
                ),
                PaymentOption(
                  code: "payme",
                  title: "Payme",
                  assetIcon: "payme.jpg",
                  isCredit: false,
                ),
                PaymentOption(
                  code: "cash",
                  title: "pay_on_delivery".tr(),
                  assetIcon: "payondeliver.jpg",
                  isCredit: false,
                ),
                PaymentOption(
                  code: "installments_payment",
                  title: "Muddatli to‘lov",
                  assetIcon: "credit.jpg",
                  isCredit: true,
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedPayment = value;
                });
              },
            ),
            SizedBox(height: 20),
            if (selectedPayment == "installments_payment")
              MonthlyPaymentWidget(
                monthlyPrice6: monthlyPrice6,
                monthlyPrice12: monthlyPrice12,
                monthlyPrice15: monthlyPrice15,
                monthlyPrice18: monthlyPrice18,
                monthlyPrice24: monthlyPrice24,
              ),
            const SizedBox(height: 40),
            _sectionTitle("your_order".tr()),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
            BlocConsumer<CreateOrderBloc, CreateOrderState>(
              listener: (context, state) {
                if (state is CreateOrderSuccess && !_orderHandled) {
                    _orderHandled = true;
                  bool isCredit = selectedPayment == "installments_payment";
                  bool isValid =
                      selectedPayment.isNotEmpty &&
                      selectedDelivery.isNotEmpty &&
                      deliveryAddress.isNotEmpty; 

                  if (!isValid && !isCredit) {
                    CustomAwesomeDialog.showInfoDialog(
                      context,
                      dialogtype: DialogType.error,
                      title: "error".tr(),
                      desc: "Iltimos, to‘lov turi, yetkazib berish usuli va manzilni tanlang",
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
                     Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
  MaterialPageRoute(builder: (context) => const MainScreen()),
  (route) => false,
);
                      },
                    );
                  } else if (selectedPayment == "installments_payment") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PassportFormPage(),
                      ),
                    );
                  } else if (selectedPayment == "payme" ||
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
          
  final isLoading = state is CreateOrderLoading;

  return SizedBox(
    width: double.infinity,
    height: 55,
    child: ElevatedButton(
      onPressed: isLoading
          ? null // bloklanadi
          : () {
              context.read<CreateOrderBloc>().add(
                    GenerateOrderEvent(
                      productId: productIdList,
                      variantId: variantIdList,
                      quantity: quantityList,
                      deliveryAddress: deliveryAddress,
                      paymentMethod: selectedPayment,
                      useCashback: useCashback,
                      branchId: selectedBranchId,
                      part: selectedBusinessId,
                      status: selectedPayment == "cash"
                          ? "processing"
                          : 'in_payment',
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
      child: isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : Text(
              "complete_purchase".tr(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
    ),
  );


              },
            ),
          
            SizedBox(height: 10.h),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(color: Colors.black, fontSize: 16),
                children: [
                  const TextSpan(text: "Buyurtmani tasdiqlash orqali men "),
                  TextSpan(
                    text: "foydalanuvchi shartnomasi",
                    style: const TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UserAgreements(),
                          ),
                        );
                      },
                  ),
                  const TextSpan(text: " shartlarini qabul qilaman."),
                ],
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  String _getSubtitleText() {
    if (deliveryAddress.isNotEmpty) {
      return deliveryAddress;
    } else if (selectedDelivery == "delivery") {
      return "choose_delivery_address".tr();
    } else if (selectedDelivery == "pickup") {
      return "choose_branch".tr();
    }
    return "choose_delivery".tr();
  }

  Future<void> _chooseDeliveryMethod(BuildContext context) async {
    setState(() {
      if (selectedDelivery != "") {
        deliveryAddress = "";
        selectedBranchId = null;
        SharedPreferencesService.instance.remove("delivery_address");
      }
    });

    final result = await showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              children: [
                Text(
                  "choose_delivery".tr(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: Icon(Icons.delivery_dining, color: Colors.green),
                  title: Text("delivery".tr()),
                  subtitle: Text("Buyurtma manzilingizga yetkaziladi"),
                  onTap: () async {
                    BlocProvider.of<RegionsBloc>(context).add(GetRegionsEvent());
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddressForm(
                          onAddressSelected: (address) {
                            setState(() {
                              deliveryAddress =
                                  "${address.region.nameUz}, ${address.city.nameUz}, ${address.street}";
                              selectedDelivery = "delivery";
                              SharedPreferencesService.instance.saveString(
                                "delivery_address",
                                deliveryAddress,
                              );
                              SharedPreferencesService.instance.saveString(
                                "selected_delivery",
                                selectedDelivery,
                              );
                            });
                          },
                        ),
                      ),
                    );
                    Navigator.pop(context, "delivery");
                  },
                ),
                ListTile(
                  leading: Icon(Icons.storefront, color: Colors.blue),
                  title: Text("pickup".tr()),
                  subtitle: Text("Do‘kondan o‘zingiz olib ketasiz"),
                  onTap: () {
                    Navigator.pop(context, "pickup");
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
    if (result == "delivery") {
    } else if (result == "pickup") {
      BlocProvider.of<BranchesBloc>(context).add(GetBranchesEvent());
    }
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