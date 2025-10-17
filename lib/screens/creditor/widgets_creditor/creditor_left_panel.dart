import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_app/component/all/custom_collapse_button.dart';
import 'package:flutter_web_app/theme/theme_web.dart';

import '../../../blocs/creditor/creditor_bloc.dart';
import '../../../blocs/creditor/creditor_event.dart';
import '../../../blocs/creditor/creditor_state.dart';
import '../../../component/barcode/form_box.dart';
import '../../../component/all/collapsible_panel_widget.dart';

class CreditorLeftPanel extends StatelessWidget {
  const CreditorLeftPanel({super.key});

  Widget _buildPanelContent() {
    return BlocBuilder<CreditorBloc, CreditorState>(
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
                            .read<CreditorBloc>()
                            .add(CreditorSearchChanged(v)),
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
                  Expanded(flex: 2, child: _Header('ชื่อเจ้าหนี้')),
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
                  if (state.status == CreditorStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.status == CreditorStatus.failure) {
                    return Center(child: Text(state.error ?? 'เกิดข้อผิดพลาด'));
                  }
                  final list = state.filteredItems;
                  return ListView.separated(
                    itemCount: list.length,
                    separatorBuilder: (_, __) =>
                        Divider(height: 1, color: Colors.grey.shade200),
                    itemBuilder: (context, i) {
                      final item = list[i];
                      return InkWell(
                        onTap: () => context
                            .read<CreditorBloc>()
                            .add(CreditorItemSelected(item)),
                        child: _RowItem(item: item),
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
    return BlocBuilder<CreditorBloc, CreditorState>(
      buildWhen: (p, c) => p.leftPanelWidth != c.leftPanelWidth,
      builder: (context, state) {
        return CollapsiblePanelWidget(
          customWidth: state.leftPanelWidth > 0 ? state.leftPanelWidth : null,
          minWidth: 300.0,
          maxWidth: 600.0,
          onDividerDrag: (dx) {
            context.read<CreditorBloc>().add(CreditorLeftPanelDragged(dx));
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
  final CreditorItem item;
  const _RowItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
