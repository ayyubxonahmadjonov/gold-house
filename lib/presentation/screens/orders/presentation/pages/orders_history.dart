import 'package:gold_house/bloc/my_orders/my_orders_bloc.dart';
import 'package:gold_house/core/constants/app_imports.dart';
import 'package:gold_house/data/models/order_';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {

  final Map<int, bool> _visibilityMap = {};

  @override
  void initState() {
    super.initState();
    context.read<MyOrdersBloc>().add(GetMyOrdersEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primaryColor,
        title: const Text("Buyurtmalarim"),
      ),
      body: BlocConsumer<MyOrdersBloc, MyOrdersState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is MyOrdersLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MyOrdersSuccess) {
            final orders = state.orders;

            if (orders.isEmpty) {
              return const Center(child: Text("Buyurtmalar topilmadi"));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const Divider(height: 32),
              itemBuilder: (context, index) {
                final order = orders[index];
                final isVisible = _visibilityMap[order.id] ?? false;
                return _buildOrderTile(order, isVisible, index);
              },
            );
          } else if (state is MyOrdersError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildOrderTile(Order order, bool isVisible, int index) {
    // Order statusni text va rangga aylantiramiz
    final statusText = _getStatusText(order.status);
    final statusColor = _getStatusColor(order.status);

    // order.items[0] ni asosiy mahsulot sifatida ko‘rsatamiz
    final firstItem = order.items.isNotEmpty ? order.items.first : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
    
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

        // Sana
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Rasmiylashtirish sanasi:",
                style: TextStyle(fontWeight: FontWeight.w600)),
            Text(order.createdAt.split("T").first),
          ],
        ),
        SizedBox(height: 20.h),

        // Umumiy narx
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${order.items.length} dona maxsulot",
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
            ),
            Text(
              "${order.totalAmount} so‘m",
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
            ),
          ],
        ),

        if (firstItem != null && isVisible) ...[
          SizedBox(height: 20.h),
          Row(
            children: [
              Image.network(
                'https://backkk.stroybazan1.uz${firstItem.productVariant.image}',
                height: 80.h,
                width: 80.w,
                fit: BoxFit.cover,
              ),
              SizedBox(width: 15.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Variant ID: ${firstItem.productVariant.id}",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text("${firstItem.price} so‘m"),
                ],
              ),
            ],
          ),
        ],

        if (firstItem != null) ...[
          SizedBox(height: 12.h),
          TextButton(
            onPressed: () {
              setState(() {
                _visibilityMap[order.id] = !isVisible;
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

  String _getStatusText(String status) {
    switch (status) {
      case "pending":
        return "Jarayonda";
      case "delivered":
        return "Xaridorga berilgan";
      case "cancelled":
        return "Qaytarilgan";
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "pending":
        return AppColors.yellow;
      case "delivered":
        return Colors.green;
      case "cancelled":
        return AppColors.red;
      default:
        return Colors.grey;
    }
  }
}
