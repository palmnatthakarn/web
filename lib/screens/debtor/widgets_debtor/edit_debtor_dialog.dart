import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/debtor/debtor_bloc.dart';
import '../../../blocs/debtor/debtor_event.dart';
import '../../../blocs/debtor/debtor_state.dart';
import '../../../component/all/add_item_dialog.dart';

class EditDebtorDialog extends StatelessWidget {
  final DebtorItem item;

  const EditDebtorDialog({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AddItemDialog(
      title: 'แก้ไขข้อมูลลูกหนี้',
      fields: [
        AddItemField(
          key: 'code',
          label: 'รหัสลูกหนี้ (ไม่สามารถแก้ไขได้)',
          defaultValue: item.code,
        ),
        AddItemField(
          key: 'name',
          label: 'ชื่อลูกหนี้',
          defaultValue: item.name ?? '',
          validator: (v) => v?.isEmpty == true ? 'กรุณากรอกชื่อลูกหนี้' : null,
        ),
        AddItemField(
          key: 'address',
          label: 'ที่อยู่',
          defaultValue: item.address ?? '',
          maxLines: 2,
        ),
        AddItemField.row(
          key: 'row2',
          fields: [
            AddItemField(
              key: 'phone',
              label: 'เบอร์โทรศัพท์',
              defaultValue: item.phone ?? '',
              keyboardType: TextInputType.phone,
            ),
            AddItemField(
              key: 'email',
              label: 'อีเมล',
              defaultValue: item.email ?? '',
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        AddItemField.row(
          key: 'row3',
          fields: [
            AddItemField(
              key: 'taxId',
              label: 'เลขประจำตัวผู้เสียภาษี',
              defaultValue: item.taxId ?? '',
            ),
            AddItemField(
              key: 'contactPerson',
              label: 'ผู้ติดต่อ',
              defaultValue: item.contactPerson ?? '',
            ),
          ],
        ),
        AddItemField.row(
          key: 'row4',
          fields: [
            AddItemField(
              key: 'creditLimit',
              label: 'วงเงินเครดิต',
              defaultValue: item.creditLimit?.toString() ?? '0',
              keyboardType: TextInputType.number,
            ),
            AddItemField(
              key: 'currentBalance',
              label: 'ยอดคงเหลือ',
              defaultValue: item.currentBalance?.toString() ?? '0',
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        AddItemField(
          key: 'personType',
          label: 'ประเภท (1=นิติบุคคล, 2=บุคคลธรรมดา)',
          defaultValue: item.personType?.toString() ?? '1',
          keyboardType: TextInputType.number,
        ),
        AddItemField.row(
          key: 'row5',
          fields: [
            AddItemField(
              key: 'branch',
              label: 'สาขา',
              defaultValue: item.branch ?? 'สำนักงานใหญ่',
            ),
            AddItemField(
              key: 'branchNumber',
              label: 'เลขที่สาขา',
              defaultValue: item.branchNumber ?? '00000',
            ),
          ],
        ),
      ],
      onSave: (values) async {
        final updatedDebtor = item.copyWith(
          name: (values['name'] ?? '').trim(),
          address: (values['address'] ?? '').trim(),
          phone: (values['phone'] ?? '').trim(),
          email: (values['email'] ?? '').trim(),
          taxId: (values['taxId'] ?? '').trim(),
          contactPerson: (values['contactPerson'] ?? '').trim(),
          creditLimit: double.tryParse(values['creditLimit'] ?? '0') ?? 0.0,
          currentBalance:
              double.tryParse(values['currentBalance'] ?? '0') ?? 0.0,
          personType: int.tryParse(values['personType'] ?? '1') ?? 1,
          branch: (values['branch'] ?? '').trim(),
          branchNumber: (values['branchNumber'] ?? '').trim(),
        );

        final bloc = context.read<DebtorBloc>();
        final index = bloc.state.items.indexWhere((i) => i.code == item.code);
        if (index >= 0) {
          bloc.add(DebtorItemUpdated(index, updatedDebtor));
        }

        // Show success message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('แก้ไขข้อมูลลูกหนี้ "${updatedDebtor.name}" สำเร็จ'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      },
    );
  }
}
