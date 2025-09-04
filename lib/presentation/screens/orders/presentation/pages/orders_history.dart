import 'package:easy_localization/easy_localization.dart';
import 'package:gold_house/bloc/my_orders/my_orders_bloc.dart';
import 'package:gold_house/core/constants/app_imports.dart';
import 'package:gold_house/data/models/my_order.dart';

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
      backgroundColor: AppColors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primaryColor,
        title:  Text("my_orders".tr()),
      ),
      body: BlocConsumer<MyOrdersBloc, MyOrdersState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is MyOrdersLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MyOrdersSuccess) {
              final orders = state.orders.where((order) {
    final status = order.status ?? "";
    return status != "pending" && status != "in_payment";
  }).toList();

            if (orders.isEmpty) {
              return const Center(child: Text("Buyurtmalar topilmadi"));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const Divider(height: 32),
              itemBuilder: (context, index) {
                final order = orders[index];
                final key = order.id ?? index;
                final isVisible = _visibilityMap[key] ?? false;
                return _buildOrderTile(order, isVisible, key);
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

  Widget _buildOrderTile(OrderOfBasket order, bool isVisible, int key) {
    // Status
    final statusText = _getStatusText(order.status ?? "");
    final statusColor = _getStatusColor(order.status ?? "");

    // Mahsulotlar
    final firstItem = order.items.isNotEmpty ? order.items.first : null;

    // Sana
    final createdAt = (order.createdAt.isNotEmpty)
        ? order.createdAt.split("T").first
        : "-";

    // Umumiy narx
    final total =
        int.tryParse(order.totalAmount ?? "") ?? 0; // string bo‘lsa 0 qilamiz

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Buyurtma raqami va status
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
            Text(createdAt),
          ],
        ),
        SizedBox(height: 20.h),

        // Umumiy nar
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${order.items.length} ${'piece'.tr()} ${'product'.tr()}",
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
            ),
            Text(
              "${order.totalAmount} ${'currency'.tr()}",
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
            ),
          ],
        ),

        // Mahsulot rasmlari
        if (isVisible && order.items.isNotEmpty) ...[
          SizedBox(height: 20.h),
          SizedBox(
            height: 100.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: order.items
                  .map((e) => e.productVariant.image ?? "")
                  .toSet()
                  .length,
              separatorBuilder: (_, __) => SizedBox(width: 15.w),
              itemBuilder: (context, i) {
                final uniqueImages = order.items
                    .map((e) => e.productVariant.image ?? "")
                    .toSet()
                    .toList();

                final img = uniqueImages[i];

                if (img.isEmpty) {
                  return Container(
                    height: 80.h,
                    width: 80.w,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported),
                  );
                }

                return InkWell(
                  onTap: () {
            
                  },
                  child: Image.network(
                    'https://backkk.stroybazan1.uz$img',
                    height: 80.h,
                    width: 80.w,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.broken_image, size: 40),
                  ),
                );
              },
            ),
          ),
        ],

        // "Ko‘rsatish/berkitish" tugmasi
        if (firstItem != null) ...[
          SizedBox(height: 12.h),
          TextButton(
            onPressed: () {
              setState(() {
                _visibilityMap[key] = !isVisible;
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
        return status.isEmpty ? "-" : status;
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
