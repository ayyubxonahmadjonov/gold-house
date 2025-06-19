import 'package:gold_house/core/constants/app_imports.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final orders = AllStaticLists().orders;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text("Buyurtmalarim"),
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(16),
        itemCount: orders.length,
        separatorBuilder: (_, __) => Divider(height: 32),
        itemBuilder: (context, index) {
          return _buildOrderTile(index);
        },
      ),
    );
  }

  Widget _buildOrderTile(int index) {
    final order = orders[index];
    final isVisible = order.isVisible;
    final statusText = _getStatusText(order.status);
    final statusColor = _getStatusColor(order.status);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Buyurtma ID va holati
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${order.id}-sonli buyurtma",
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
            ),
            Text(
              statusText,
              style: TextStyle(
                color: statusColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),

        // Sana ma'lumotlari
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Yetkazish sanasi:",
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
            ),
            Text(
              order.date,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Rasmiylashtirish sanasi:",
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
            ),
            Text(
              order.date,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        SizedBox(height: 20.h),

        // Narx
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "1 dona maxsulot",
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
            ),
            Text(
              "${order.productPrice.toStringAsFixed(0)} so‘m",
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
            ),
          ],
        ),

        if (order.image != null && isVisible) ...[
          SizedBox(height: 20.h),
          Row(
            children: [
              Image.asset(order.image!, height: 80.h),
              SizedBox(width: 15.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.productName ?? "",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text("${order.productPrice.toStringAsFixed(0)} so‘m"),
                  if (order.installmentText != null)
                    Container(
                      margin: EdgeInsets.only(top: 10.h),
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 7.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Text(
                        order.installmentText!,
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],

        if (order.image != null) ...[
          SizedBox(height: 12.h),
          TextButton(
            onPressed: () {
              setState(() {
                orders[index].isVisible = !orders[index].isVisible;
              });
            },
            child: Text(
              isVisible ? "Maxsulotni berkitish" : "Maxsulotni ko‘rsatish",
              style: TextStyle(
                color: AppColors.brown,
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.delivered:
        return "Xaridorga Berilgan";
      case OrderStatus.processing:
        return "Jarayonda";
      case OrderStatus.cancelled:
        return "Qaytarilgan";
    }
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.processing:
        return AppColors.yellow;
      case OrderStatus.cancelled:
        return AppColors.red;
    }
  }
}
