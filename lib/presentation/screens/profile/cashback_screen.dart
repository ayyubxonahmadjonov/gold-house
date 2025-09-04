import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gold_house/bloc/user_data/get_user_data_bloc.dart';
import 'package:gold_house/data/datasources/local/shared_preferences/shared_service.dart';

class CashbackView extends StatefulWidget {
  const CashbackView({super.key});

  @override
  State<CashbackView> createState() => _CashbackViewState();
}

class _CashbackViewState extends State<CashbackView> {
  int id = 0;

  @override
  void initState() {
    super.initState();
    id = SharedPreferencesService.instance.getInt("user_id") ?? 0;
    BlocProvider.of<GetUserDataBloc>(context).add(
      GetUserAllDataEvent(id: id.toString()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title:  Text("cashback".tr()),
      ),
      body: BlocBuilder<GetUserDataBloc, GetUserDataState>(
        builder: (context, state) {
          if (state is GetUserDataSuccess) {
            final cashback = state.user.cashbackBalance;
            final hasCashback = num.parse(cashback) > 0;
      
            return Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                padding: const EdgeInsets.all(24),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: hasCashback
                        ? [Colors.green.shade400, Colors.green.shade700]
                        : [Colors.grey.shade300, Colors.grey.shade500],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: hasCashback
                          ? Colors.green.withOpacity(0.3)
                          : Colors.black26,
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      hasCashback ? Icons.card_giftcard : Icons.error_outline,
                      size: 60,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      hasCashback
                          ? "Sizning Cashback summangiz"
                          : "Cashback mavjud emas",
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      hasCashback ? "${num.parse(cashback).toStringAsFixed(2)} so'm" : "😕",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is GetUserDataLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetUserDataError) {
            return const Center(
              child: Text(
                "Xatolik yuz berdi",
                style: TextStyle(color: Colors.red),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
