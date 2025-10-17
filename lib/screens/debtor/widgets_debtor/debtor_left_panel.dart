import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_app/component/all/custom_collapse_button.dart';
import 'package:flutter_web_app/theme/theme_web.dart';

import '../../../blocs/debtor/debtor_bloc.dart';
import '../../../blocs/debtor/debtor_event.dart';
import '../../../blocs/debtor/debtor_state.dart';
import '../../../component/barcode/form_box.dart';
import '../../../component/all/collapsible_panel_widget.dart';

class DebtorLeftPanel extends StatelessWidget {
  const DebtorLeftPanel({super.key});

  Widget _buildPanelContent() {
    return BlocBuilder<DebtorBloc, DebtorState>(
      buildWhen: (p, c) =>
          p.query != c.query || p.items != c.items || p.status != c.status,
      builder: (context, state) {
        return Column(
          children: [
            // Search + Filter
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 36,
                      child: FormBox(
                        hintText: 'ค้นหา',
                        filled: true,
                        onChanged: (v) => context
                            .read<DebtorBloc>()
                            .add(DebtorSearchChanged(v)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    height: 36,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Center(
                      child: Text('กรอง', style: TextStyle(fontSize: 14)),
                    ),
                  ),
                ],
              ),
            ),

            // Header row
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
              ),
              child: const Row(
                children: [
                  Expanded(flex: 1, child: _Header('รหัส')),
                  Expanded(flex: 2, child: _Header('ชื่อลูกหนี้')),
                  Expanded(flex: 1, child: _Header('โทรศัพท์')),
                  Expanded(flex: 1, child: _Header('วงเงิน')),
                  Expanded(flex: 1, child: _Header('ยอดคงเหลือ')),
                ],
              ),
            ),

            // List
            Expanded(
              child: Builder(
                builder: (_) {
                  if (state.status == DebtorStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.status == DebtorStatus.failure) {
                    return Center(child: Text(state.error ?? 'เกิดข้อผิดพลาด'));
                  }
                  final list = state.filtered;
                  return ListView.separated(
                    itemCount: list.length,
                    separatorBuilder: (_, __) =>
                        Divider(height: 1, color: Colors.grey.shade200),
                    itemBuilder: (context, i) {
                      final item = list[i];
                      final isSelected = state.selected == item;
                      return InkWell(
                        onTap: () => context
                            .read<DebtorBloc>()
                            .add(DebtorItemSelected(item)),
                        child: _RowItem(item: item, isSelected: isSelected),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DebtorBloc, DebtorState>(
      buildWhen: (p, c) => p.leftPanelWidth != c.leftPanelWidth,
      builder: (context, state) {
        return CollapsiblePanelWidget(
          customWidth: state.leftPanelWidth > 0 ? state.leftPanelWidth : null,
          minWidth: 300.0,
          maxWidth: 600.0,
          onDividerDrag: (dx) {
            context.read<DebtorBloc>().add(DebtorLeftPanelDragged(dx));
          },
          customCollapseButtonBuilder: (isCollapsed, onTap) {
            return Container(
              color: Colors.white,
              child: CustomCollapseButton(
                isCollapsed: isCollapsed,
                onTap: onTap,
                gradient: dashboard_gradient_2,
                tooltip: 'ตาราง',
              ),
            );
          },
          child: _buildPanelContent(),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  final String text;
  const _Header(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500));
  }
}

class _RowItem extends StatelessWidget {
  final DebtorItem item;
  final bool isSelected;
  const _RowItem({required this.item, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.shade50 : null,
      ),
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: Text(item.code, style: const TextStyle(fontSize: 12))),
          Expanded(
              flex: 2,
              child:
                  Text(item.name ?? '', style: const TextStyle(fontSize: 12))),
          Expanded(
              flex: 1,
              child:
                  Text(item.phone ?? '', style: const TextStyle(fontSize: 12))),
          Expanded(
              flex: 1,
              child: Text(item.creditLimit?.toStringAsFixed(2) ?? '0.00',
                  style: const TextStyle(fontSize: 12))),
          Expanded(
              flex: 1,
              child: Text(item.currentBalance?.toStringAsFixed(2) ?? '0.00',
                  style: const TextStyle(fontSize: 12))),
        ],
      ),
    );
  }
}
