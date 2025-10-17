import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/debtor/debtor_bloc.dart';
import '../../blocs/debtor/debtor_event.dart';
import '../../blocs/debtor/debtor_state.dart';
import '../../repository/debtor_repository.dart';
import '../../component/barcode/action_icon_button.dart';
import '../../component/barcode/thai_flag.dart';
import '../../theme/app_theme.dart';
import 'widgets_debtor/debtor_left_panel.dart';
import 'widgets_debtor/debtor_right_panel.dart';

class DebtorScreen extends StatelessWidget {
  const DebtorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          DebtorBloc(DebtorRepository())..add(const DebtorInitialized()),
      child: const _DebtorScreenState(),
    );
  }
}

class _DebtorScreenState extends StatelessWidget {
  const _DebtorScreenState();

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
              'ลูกหนี้',
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
              BlocBuilder<DebtorBloc, DebtorState>(
                builder: (context, state) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ActionIconButton(
                        icon: Icons.calculate,
                        tooltip: 'คำนวณ',
                        onPressed: () => context
                            .read<DebtorBloc>()
                            .add(const DebtorCalculatePressed()),
                      ),
                      ActionIconButton(
                        icon: Icons.inventory_2_outlined,
                        tooltip: 'คลังสินค้า',
                        onPressed: () => context
                            .read<DebtorBloc>()
                            .add(const DebtorInventoryPressed()),
                      ),
                      ActionIconButton(
                        icon: Icons.add,
                        tooltip: 'เพิ่ม',
                        onPressed: () => context
                            .read<DebtorBloc>()
                            .add(const DebtorAddPressed()),
                      ),
                      ActionIconButton(
                        icon: Icons.delete_outline,
                        tooltip: 'ลบ',
                        onPressed: () => context
                            .read<DebtorBloc>()
                            .add(const DebtorDeletePressed()),
                      ),
                      ActionIconButton(
                        icon: Icons.person_outline,
                        tooltip: 'ผู้ใช้',
                        onPressed: () => context
                            .read<DebtorBloc>()
                            .add(const DebtorUserPressed()),
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
      body: BlocBuilder<DebtorBloc, DebtorState>(
        buildWhen: (p, c) => p.leftPanelWidth != c.leftPanelWidth,
        builder: (context, state) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DebtorLeftPanel(),
              const Expanded(
                child: DebtorRightPanel(),
              ),
            ],
          );
        },
      ),
    );
  }
}
