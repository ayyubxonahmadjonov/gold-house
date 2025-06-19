import '../../../../../core/constants/app_imports.dart';

class BasketPage extends StatefulWidget {
  const BasketPage({Key? key}) : super(key: key);

  @override
  State<BasketPage> createState() => _BasketPageState();
}

class _BasketPageState extends State<BasketPage> {
  final products = AllStaticLists().products;

  late List<bool> selected;
  late List<int> quantity;
  bool selectAll = true;
  bool isInstallment = false;

  @override
  void initState() {
    super.initState();
    selected = List.generate(products.length, (index) => true);
    quantity = List.generate(products.length, (index) => 1);
  }

  double get total {
    double sum = 0;
    for (int i = 0; i < products.length; i++) {
      if (selected[i]) {
        sum += products[i].price * quantity[i];
      }
    }
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Savatcha', style: TextStyle(color: Colors.black)),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(8.r),
        child: Column(
          children: [
            // "Hammasini tanlash"
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Hammasini tanlash", style: TextStyle(fontSize: 16)),
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
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: EdgeInsets.all(10.r),

                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          product.imageUrl,
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
                                product.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.sp,
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Row(
                                children: [
                                  Text(
                                    "O'lcham: ${product.size}",
                                    style: TextStyle(fontSize: 12.sp),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Rang: ${product.color}",
                                    style: TextStyle(fontSize: 12.sp),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Text(
                                "${product.price.toStringAsFixed(3)} so‘m",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13.sp,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Container(
                                width: 100.w,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
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
                                    Text(
                                      quantity[index].toString(),
                                      style: const TextStyle(fontSize: 16),
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
                          side: BorderSide(color: AppColors.primaryColor),
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

            SizedBox(height: 16.h),

            // Payment switch
            CustomSelectableWidget(isInstallment: isInstallment),
            SizedBox(height: 20.h),

            // Umumiy va rasmiylashtirish
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Umumiy:', style: TextStyle(fontSize: 16)),
                Text(
                  "${total.toStringAsFixed(3)} so‘m",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD8BB6C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // TODO: Rasmiylashtirish
                },
                child: Text(
                  "Rasmiylashtirish",
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
