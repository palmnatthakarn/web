import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_app/blocs/purchase/purchase_event.dart';
import 'package:flutter_web_app/blocs/purchase/purchase_state.dart';
import 'package:flutter_web_app/repository/purchase_repository.dart';
import 'package:flutter_web_app/screens/purchaseV2/widgets_purchaseV2/purchase_tab_panel_V2.dart';
import 'package:flutter_web_app/screens/purchaseV2/widgets_purchaseV2/purchasetotalpage_V2_R.dart';
import '../../blocs/purchase/purchase_bloc.dart';
import '../../component/barcode/action_icon_button.dart';
import '../../component/barcode/thai_flag.dart';
import '../../theme/app_theme.dart';

class ProductManagementScreen_V2 extends StatelessWidget {
  const ProductManagementScreen_V2({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // แก้ตรงนี้: ใช้ cascade แทนการเรียก .add() ตรง ๆ
      create: (_) =>
          PurchaseBloc(ProductRepository())..add(const PurchaseInitialized()),
      child: const _ProductManagementScreenState(),
    );
  }
}

class _ProductManagementScreenState extends StatelessWidget {
  const _ProductManagementScreenState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
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
              'ซื้อสินค้า',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 16),
                child: ThaiFlag(width: 24, height: 16),
              ),
              ActionIconButton(icon: Icons.calculate, tooltip: 'คำนวณ'),
              ActionIconButton(
                  icon: Icons.inventory_2_outlined, tooltip: 'คลังสินค้า'),
              ActionIconButton(icon: Icons.add, tooltip: 'เพิ่ม'),
              ActionIconButton(icon: Icons.save, tooltip: 'บันทึกแบบร่าง'),
              ActionIconButton(icon: Icons.shopping_cart, tooltip: 'ดำเนิการสั่งซื้อ'),
              SizedBox(width: 16),
            ],
          ),
        ),
      ),
      body: BlocBuilder<PurchaseBloc, PurchaseState>(
        buildWhen: (p, c) => p.leftPanelWidth != c.leftPanelWidth,
        builder: (context, state) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
           
              Expanded(
                flex: 2,
                child: DefaultTabController(
                  length: 2,
                  child: const PurchaseRightPanel_V2(),
                ),
              ),
                Expanded(
                child: DefaultTabController(
                  length: 3,
                  child: const SummaryAndPaymentSection_V2() ,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
