import 'package:flutter/material.dart';
import 'package:gold_house/core/shared/custom_selectable_widget2.dart';
import 'package:gold_house/data/datasources/local/hive_helper/hive_names.dart';
import 'package:gold_house/data/datasources/local/shared_preferences/shared_service.dart';
import 'package:gold_house/data/models/basket_model.dart';
import 'package:gold_house/presentation/screens/basket/presentation/pages/payment_option.dart';

class FormalizeProduct extends StatefulWidget {
String total_price;

   FormalizeProduct({
    super.key,
    required this.total_price,
  
  });

  @override
  State<FormalizeProduct> createState() => _FormalizeProductState();
    final List<String> paymentMethods = ["Click", "Payme", "Qabul qilinganda", "Muddatli to'lov"];
}

class _FormalizeProductState extends State<FormalizeProduct> {
  String? selectedDelivery = "Olib ketish"; // default
  String? selectedPayment; // foydalanuvchi tanlagani
  List<BasketModel> purchuaseProductList = HiveBoxes.basketData.values.toList();
  String fullname = SharedPreferencesService.instance.getString("profilfullname") ?? "";
  String phone = SharedPreferencesService.instance.getString("phone") ?? "";
  bool isInstallment = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      
        surfaceTintColor: Colors.white,
        title: const Text("Buyurtma")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Qabul qiluvchi
            _sectionTitle("Qabul qiluvchi"),
            Card(
              child: ListTile(
                leading: const Icon(Icons.person),
                title: Text(fullname),
                subtitle: Text(phone),
              ),
            ),
            const SizedBox(height: 16),

            // Mahsulotlar
            _sectionTitle("Mahsulotlar"),
        ListView.builder(
          shrinkWrap: true,
          itemCount: purchuaseProductList.length,
          itemBuilder: (context, index) {
          final product = purchuaseProductList[index];
          return Container(
            margin: EdgeInsets.all(8),
            child: ListTile(
              leading: ClipRRect(borderRadius: BorderRadius.circular(10),child: Image.network("https://backkk.stroybazan1.uz${product.image}", width: 70, height: 70,fit: BoxFit.cover)),
              title: Text(product.title,style: TextStyle(fontSize: 17),overflow: TextOverflow.ellipsis),
              subtitle: Text("${product.price} so'm",style: TextStyle(fontSize: 15),overflow: TextOverflow.ellipsis),
              trailing: Text("${product.quantity} dona",style: TextStyle(fontSize: 14),overflow: TextOverflow.ellipsis),
            ),
          );
        }),
            const SizedBox(height: 16),

            // Qabul qilish usuli
            _sectionTitle("Qabul qilish usuli"),
          CustomSelectable2Widget(isInstallment: isInstallment,title1: "Olib ketish", title2: "Yetkazib berish"),
            const SizedBox(height: 16),
          
            _sectionTitle("Keshbekni ishlatish"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Keshbek: 0 so'm",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600)),
                Checkbox(value: true, onChanged: (_) {}),
              ],
            ),
            const SizedBox(height: 16),

            // To'lov usuli
            _sectionTitle("To‘lov usuli"),
      PaymentSelector(
        paymentMethods: [
            PaymentOption(title: "Click", assetIcon: "click.png", isCredit: false),
             PaymentOption(title: "Payme", assetIcon: "payme.png", isCredit: false),
             PaymentOption(title: "Qabul qilinganda", assetIcon: "bring.png", isCredit: false),
            PaymentOption(title: "Muddatli to‘lov", assetIcon: "delivery.png", isCredit: true),
        ]
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
            _sectionTitle("Sizning buyurtmangiz" ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${purchuaseProductList.length} ta mahsulot narxi:",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600)),
                      Text("1,431,000 so‘m",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600)),                
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Muddatli to‘lov: ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600)),
                      Text("12 oy",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600)),
                    
                    ],
                  ),
                  const SizedBox(height: 8),

                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Oylik to‘lov:",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600)),
                      Text("119,250 so‘m",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600)),
                   
                    ],
                  ),
                  const SizedBox(height: 8),

                  const Divider(),
                  const SizedBox(height: 15),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Jami:", style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20)),
                      Text(widget.total_price,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w700)),
                  
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),

            // Tugma
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // API chaqirish
                },
                child: const Text("Xaridni rasmiylashtirish"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 10),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
    );
  }
}
