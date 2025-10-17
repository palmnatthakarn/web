import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_app/blocs/barcode/barcode_bloc.dart';
import 'package:flutter_web_app/blocs/barcode/barcode_event.dart';
import 'package:flutter_web_app/blocs/barcode/barcode_state.dart';
import 'package:flutter_web_app/repository/barcode_repository.dart';
import '../../component/barcode/action_icon_button.dart';
import '../../component/barcode/resizable_divider.dart';
import '../../component/barcode/thai_flag.dart';
import '../../theme/app_theme.dart';
import 'widgets_barcode/barcode_left_panel.dart';
import 'widgets_barcode/barcode_right_panel.dart';

class BarcodeScreen extends StatelessWidget {
  const BarcodeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          BarcodeBloc(BarcodeRepository())..add(const BarcodeInitialized()),
      child: const _BarcodeScaffold(),
    );
  }
}

class _BarcodeScaffold extends StatelessWidget {
  const _BarcodeScaffold();

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
              'บาร์โค้ด',
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
              ActionIconButton(icon: Icons.delete_outline, tooltip: 'ลบ'),
              ActionIconButton(icon: Icons.person_outline, tooltip: 'ผู้ใช้'),
              SizedBox(width: 16),
            ],
          ),
        ),
      ),
      body: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BarcodeLeftPanel(),
          BarcodeRightPanel(),
        ],
      ),
    );
  }
}
