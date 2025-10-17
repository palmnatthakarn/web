import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/debtor/debtor_bloc.dart';
import '../../../blocs/debtor/debtor_event.dart';
import '../../../blocs/debtor/debtor_state.dart';
import '../../../component/all/add_item_dialog.dart';

class AddDebtorDialog extends StatelessWidget {
  const AddDebtorDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AddItemDialog(
      title: 'เพิ่มลูกหนี้ใหม่',
      fields: [
        AddItemField.row(
          key: 'row1',
          fields: [
            AddItemField(
              key: 'code',
              label: 'รหัสลูกหนี้',
              validator: (v) =>
                  v?.isEmpty == true ? 'กรุณากรอกรหัสลูกหนี้' : null,
            ),
            AddItemField(
              key: 'name',
              label: 'ชื่อลูกหนี้',
              validator: (v) =>
                  v?.isEmpty == true ? 'กรุณากรอกชื่อลูกหนี้' : null,
            ),
          ],
        ),
        AddItemField(
          key: 'address',
          label: 'ที่อยู่',
          maxLines: 2,
        ),
        AddItemField.row(
          key: 'row2',
          fields: [
            AddItemField(
              key: 'phone',
              label: 'เบอร์โทรศัพท์',
              keyboardType: TextInputType.phone,
            ),
            AddItemField(
              key: 'email',
              label: 'อีเมล',
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
            ),
            AddItemField(
              key: 'contactPerson',
              label: 'ผู้ติดต่อ',
            ),
          ],
        ),
        AddItemField.row(
          key: 'row4',
          fields: [
            AddItemField(
              key: 'creditLimit',
              label: 'วงเงินเครดิต',
              keyboardType: TextInputType.number,
              defaultValue: '0',
            ),
            AddItemField(
              key: 'currentBalance',
              label: 'ยอดคงเหลือ',
              keyboardType: TextInputType.number,
              defaultValue: '0',
            ),
          ],
        ),
        AddItemField(
          key: 'personType',
          label: 'ประเภท (1=นิติบุคคล, 2=บุคคลธรรมดา)',
          defaultValue: '1',
          keyboardType: TextInputType.number,
        ),
        AddItemField.row(
          key: 'row5',
          fields: [
            AddItemField(
              key: 'branch',
              label: 'สาขา',
              defaultValue: 'สำนักงานใหญ่',
            ),
            AddItemField(
              key: 'branchNumber',
              label: 'เลขที่สาขา',
              defaultValue: '00000',
            ),
          ],
        ),
      ],
      onSave: (values) async {
        final newDebtor = DebtorItem(
          code: (values['code'] ?? '').trim(),
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
          createdDate: DateTime.now(),
        );

        context.read<DebtorBloc>().add(DebtorItemAdded(newDebtor));

        // Show success message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('เพิ่มลูกหนี้ "${newDebtor.name}" สำเร็จ'),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
    );
  }
}
