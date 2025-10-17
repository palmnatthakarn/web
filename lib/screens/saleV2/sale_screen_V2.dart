import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/sale/sale_bloc.dart';
import '../../blocs/sale/sale_state.dart';
import '../../blocs/sale/sale_event.dart';
import '../../component/barcode/action_icon_button.dart';
import '../../component/barcode/thai_flag.dart';
import '../../theme/app_theme.dart';
import 'widgets_saleV2/sale_product_list_V2.dart';
import 'widgets_saleV2/saletotalpage_V2.dart';

class SaleScreenV2 extends StatelessWidget {
  const SaleScreenV2({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SaleBloc(),
      child: const SaleScreenContent(),
    );
  }
}

class SaleScreenContent extends StatefulWidget {
  const SaleScreenContent({super.key});

  @override
  State<SaleScreenContent> createState() => _SaleScreenContentState();
}

class _SaleScreenContentState extends State<SaleScreenContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 48),
        child: Container(
          decoration: AppTheme.gradientDecoration,
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
              ),
            ),
            title: const Text(
              'ขายสินค้า',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              const Padding(
                padding: EdgeInsets.only(right: 16),
                child: ThaiFlag(width: 24, height: 16),
              ),
              BlocBuilder<SaleBloc, SaleState>(
                builder: (context, state) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ActionIconButton(
                        icon: Icons.calculate,
                        tooltip: 'คำนวณ',
                        onPressed: () {
                          // TODO: Implement calculation
                        },
                      ),
                      ActionIconButton(
                        icon: Icons.inventory_2_outlined,
                        tooltip: 'คลังสินค้า',
                        onPressed: () {
                          // TODO: Show inventory
                        },
                      ),
                      ActionIconButton(
                        icon: Icons.print,
                        tooltip: 'พิมพ์',
                        onPressed: () {
                          // TODO: Print receipt
                        },
                      ),
                      ActionIconButton(
                        icon: Icons.delete_outline,
                        tooltip: 'ล้างรายการ',
                        onPressed: () {
                          context.read<SaleBloc>().add(const SaleReset());
                        },
                      ),
                      ActionIconButton(
                        icon: Icons.person_outline,
                        tooltip: 'ผู้ใช้',
                        onPressed: () {
                          // TODO: Show user info
                        },
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(width: 16),
            ],
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: const [
                Tab(
                  icon: Icon(Icons.shopping_cart),
                  text: 'รายการสินค้า',
                ),
                Tab(
                  icon: Icon(Icons.payment),
                  text: 'สรุปยอดและชำระเงิน',
                ),
              ],
            ),
          ),
        ),
      ),
      body: BlocBuilder<SaleBloc, SaleState>(
        builder: (context, state) {
          return TabBarView(
            controller: _tabController,
            children: const [
              SaleProductListV2(),
              SummaryAndPaymentSectionV2(),
            ],
          );
        },
      ),
      floatingActionButton: BlocBuilder<SaleBloc, SaleState>(
        builder: (context, state) {
          if (state.cartItems.isNotEmpty) {
            return FloatingActionButton.extended(
              onPressed: () {
                _tabController.animateTo(1);
              },
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              icon: const Icon(Icons.payment),
              label: Text('ชำระเงิน (${state.cartItems.length})'),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
