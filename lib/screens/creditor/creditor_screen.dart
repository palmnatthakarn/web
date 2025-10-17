import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/creditor/creditor_bloc.dart';
import '../../blocs/creditor/creditor_event.dart';
import '../../blocs/creditor/creditor_state.dart';
import '../../repository/creditor_repository.dart';
import '../../component/barcode/action_icon_button.dart';
import '../../component/barcode/thai_flag.dart';
import '../../theme/app_theme.dart';
import 'widgets_creditor/creditor_left_panel.dart';
import 'widgets_creditor/creditor_right_panel.dart';

class CreditorScreen extends StatelessWidget {
  const CreditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          CreditorBloc(CreditorRepository())..add(const CreditorInitialized()),
      child: const _CreditorScreenState(),
    );
  }
}

class _CreditorScreenState extends StatelessWidget {
  const _CreditorScreenState();

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
              'เจ้าหนี้',
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
              BlocBuilder<CreditorBloc, CreditorState>(
                builder: (context, state) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ActionIconButton(
                        icon: Icons.calculate,
                        tooltip: 'คำนวณ',
                        onPressed: () => context.read<CreditorBloc>().add(const CreditorCalculatePressed()),
                      ),
                      ActionIconButton(
                        icon: Icons.inventory_2_outlined,
                        tooltip: 'คลังสินค้า',
                        onPressed: () => context.read<CreditorBloc>().add(const CreditorInventoryPressed()),
                      ),
                      ActionIconButton(
                        icon: Icons.add,
                        tooltip: 'เพิ่ม',
                        onPressed: () => context.read<CreditorBloc>().add(const CreditorAddPressed()),
                      ),
                      ActionIconButton(
                        icon: Icons.delete_outline,
                        tooltip: 'ลบ',
                        onPressed: () => context.read<CreditorBloc>().add(const CreditorDeletePressed()),
                      ),
                      ActionIconButton(
                        icon: Icons.person_outline,
                        tooltip: 'ผู้ใช้',
                        onPressed: () => context.read<CreditorBloc>().add(const CreditorUserPressed()),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ),
      body: BlocBuilder<CreditorBloc, CreditorState>(
        buildWhen: (p, c) => p.leftPanelWidth != c.leftPanelWidth,
        builder: (context, state) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CreditorLeftPanel(),
              const Expanded(
                child: CreditorRightPanel(),
              ),
            ],
          );
        },
      ),
    );
  }
}
