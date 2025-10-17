import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_app/blocs/barcode/barcode_state.dart';
import 'package:flutter_web_app/component/barcode/ui.dart';
import 'package:flutter_web_app/component/all/buildSection.dart';
import '../../../blocs/barcode/barcode_bloc.dart';
import '../../../blocs/barcode/barcode_event.dart';
import '../../../blocs/image/image_bloc.dart';
import '../../../widgets/image_upload_box.dart';

class BarcodeRightPanel extends StatelessWidget {
  const BarcodeRightPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 600;
            
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 8 : 16, 
                    vertical: 5
                  ),
              child: SingleChildScrollView(
                child: BlocBuilder<BarcodeBloc, BarcodeState>(
                  builder: (context, state) {
                    final sel = state.selected;
                    return SectionBuilder.buildSection(
                      title: 'ชื่อประเภทธุรกิจ',
                      icon: Icons.calculate_outlined,
                      // padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ---------------- TOP ROW: TAGS + IMAGE ----------------
                          isMobile
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildLeftContent(sel, isMobile),
                                    const SizedBox(height: 16),
                                    Center(
                                      child: BlocProvider(
                                        create: (context) => ImageBloc(),
                                        child: const ImageUploadBox(),
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: _buildLeftContent(sel, isMobile),
                                    ),
                                    const SizedBox(width: 16),
                                    BlocProvider(
                                      create: (context) => ImageBloc(),
                                      child: const ImageUploadBox(),
                                    ),
                                  ],
                                ),
                          const SizedBox(height: 20),
                          const SoftDivider(),

                          // ---------------- PRODUCT TYPE, TAX TYPE, MONEY ----------------
                          isMobile
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildProductTypeSection(context, state),
                                    const SizedBox(height: 16),
                                    _buildTaxTypeSection(context, state),
                                    const SizedBox(height: 16),
                                    _buildMoneySection(),
                                  ],
                                )
                              : Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(child: _buildProductTypeSection(context, state)),
                                    const SizedBox(width: 16),
                                    Expanded(child: _buildTaxTypeSection(context, state)),
                                    const SizedBox(width: 16),
                                    Expanded(child: _buildMoneySection()),
                                  ],
                                ),
                          const SoftDivider(),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const RowBaseline(children: [
                                HeaderWithIcon('ส่วนลด :', Icons.sell),
                                SizedBox(width: 8),
                                UnderlineValue(text: '-', minWidth: 120),
                              ]),
                              SizedBox(width: 20),
                              const RowBaseline(children: [
                                HeaderWithIcon(
                                    'คะแนนสะสม  :', Icons.attach_money),
                                SizedBox(width: 8),
                                UnderlineValue(
                                    text: 'ไม่คิดคะแนนสะสม', minWidth: 120),
                              ]),
                              SizedBox(width: 20),
                              const RowBaseline(children: [
                                HeaderWithIcon('เวลา  :', Icons.timer),
                                SizedBox(width: 8),
                                UnderlineValue(
                                    text: '12:55 - 15:885 lmsd', minWidth: 120),
                              ]),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              // color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              child: SingleChildScrollView(
                child: BlocBuilder<BarcodeBloc, BarcodeState>(
                  builder: (context, state) {
                    final sel = state.selected;
                    return SectionBuilder.buildSection(
                      title: 'ราคาขาย',
                      icon: Icons.percent,
                      // padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ---------------- ราคาตามช่องทาง ----------------
                          RowBaseline(children: [
                            const FormLabel('ราคาขายปลีก :'),
                            const SizedBox(width: 8),
                            UnderlineValue(
                              text: sel?.code.toLowerCase() ?? '0',
                              minWidth: 80,
                            ),
                            const SizedBox(width: 30),
                            const FormLabel('ราคาขายสมาชิก :'),
                            const SizedBox(width: 8),
                            UnderlineValue(
                              text: sel?.code.toLowerCase() ?? '0',
                              minWidth: 80,
                            ),
                            const SizedBox(width: 30),
                            const FormLabel('ราคาตามช่องทาง :'),
                            const SizedBox(width: 8),
                            UnderlineValue(
                              text: sel?.code.toLowerCase() ?? '0',
                              minWidth: 80,
                            ),
                          ]),

                          const SoftDivider(),
                          // ---------------- มิติ ----------------
                          //const _SectionHeader('มิติ'),
                          RowBaseline(children: [
                            const FormLabel('ราคาลู่ 1:'),
                            const SizedBox(width: 8),
                            UnderlineValue(
                              text: sel?.code.toLowerCase() ?? '0',
                              minWidth: 80,
                            ),
                            const SizedBox(width: 30),
                            const FormLabel('ราคาลู่ 2:'),
                            const SizedBox(width: 8),
                            UnderlineValue(
                              text: sel?.code.toLowerCase() ?? '0',
                              minWidth: 80,
                            ),
                            const SizedBox(width: 30),
                            const FormLabel('ราคาลู่ 3:'),
                            const SizedBox(width: 8),
                            UnderlineValue(
                              text: sel?.code.toLowerCase() ?? '0',
                              minWidth: 80,
                            ),
                            const SizedBox(width: 30),
                            const FormLabel('ราคาลู่ 4:'),
                            const SizedBox(width: 8),
                            UnderlineValue(
                              text: sel?.code.toLowerCase() ?? '0',
                              minWidth: 80,
                            ),
                          ]),
                          //  const SizedBox(height: 8),
                        ],
                      ),
                    );
                  },
                ),
              ),
            )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildLeftContent(dynamic sel, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: const [
            TagChip(label: '001 - ธุรกิจร้านอาหาร', icon: Icons.storefront),
            TagChip(label: '0000 - หาดใหญ่', icon: Icons.place_outlined),
          ],
        ),
        const SizedBox(height: 20),
        _buildInfoRows(sel, isMobile),
      ],
    );
  }

  Widget _buildInfoRows(dynamic sel, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RowBaseline(children: [
                    const FormLabel('บาร์โค้ด :'),
                    const SizedBox(width: 8),
                    UnderlineValue(text: sel?.code.toLowerCase() ?? 'ff0005', minWidth: 80),
                  ]),
                  const SizedBox(height: 8),
                  RowBaseline(children: [
                    const FormLabel('ชื่อสินค้า (Thai) :'),
                    const SizedBox(width: 8),
                    UnderlineValue(text: sel?.name ?? 'ปากกา / Pen', minWidth: 100),
                  ]),
                ],
              )
            : Wrap(
                spacing: 50,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.end,
                children: [
                  RowBaseline(children: [
                    const FormLabel('บาร์โค้ด :'),
                    const SizedBox(width: 8),
                    UnderlineValue(text: sel?.code.toLowerCase() ?? 'ff0005', minWidth: 80),
                    const SizedBox(width: 10),
                    const FormLabel('ชื่อสินค้า (Thai) :'),
                    const SizedBox(width: 8),
                    UnderlineValue(text: sel?.name ?? 'ปากกา / Pen', minWidth: 100, maxWidth: 360),
                  ]),
                ],
              ),
        const SizedBox(height: 20),
        isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RowBaseline(children: [
                    const FormLabel('รหัสสินค้า :'),
                    const SizedBox(width: 8),
                    UnderlineValue(text: sel?.code.toLowerCase() ?? 'ff0005', minWidth: 80),
                  ]),
                  const SizedBox(height: 8),
                  RowBaseline(children: [
                    const FormLabel('หน่วยนับ :'),
                    const SizedBox(width: 8),
                    UnderlineValue(text: '10', minWidth: 80),
                  ]),
                ],
              )
            : Wrap(
                spacing: 50,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.end,
                children: [
                  RowBaseline(children: [
                    const FormLabel('รหัสสินค้า :'),
                    const SizedBox(width: 8),
                    UnderlineValue(text: sel?.code.toLowerCase() ?? 'ff0005', minWidth: 80),
                    const SizedBox(width: 10),
                    const FormLabel('หน่วยนับ :'),
                    const SizedBox(width: 8),
                    UnderlineValue(text: '10', minWidth: 80),
                  ]),
                ],
              ),
        const SizedBox(height: 20),
        RowBaseline(children: [
          const FormLabel('บาร์โค้ดอ้างอิง : '),
          const SizedBox(width: 8),
          UnderlineValue(text: 'ff0005-A', minWidth: 140),
        ]),
      ],
    );
  }

  Widget _buildProductTypeSection(BuildContext context, BarcodeState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HeaderWithIcon('ประเภทสินค้า', Icons.category_outlined),
        const SizedBox(height: 8),
        RadioRow(
          title: 'สินค้ามีสต๊อก',
          value: 1,
          group: state.productTypeGroup,
          onChanged: (v) => context.read<BarcodeBloc>().add(BarcodeProductTypeChanged(v)),
        ),
        RadioRow(
          title: 'ประเภทธุรกิจบริการ',
          value: 2,
          group: state.productTypeGroup,
          onChanged: (v) => context.read<BarcodeBloc>().add(BarcodeProductTypeChanged(v)),
        ),
        RadioRow(
          title: 'สินค้าผลิต',
          value: 3,
          group: state.productTypeGroup,
          onChanged: (v) => context.read<BarcodeBloc>().add(BarcodeProductTypeChanged(v)),
        ),
      ],
    );
  }

  Widget _buildTaxTypeSection(BuildContext context, BarcodeState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HeaderWithIcon('ประเภทภาษี', Icons.receipt_long_outlined),
        const SizedBox(height: 8),
        RowBaseline(children: [
          RadioInline(
            label: 'สินค้าที่มีมูลค่าเพิ่ม',
            value: 1,
            group: state.produceGroup,
            onChanged: (v) => context.read<BarcodeBloc>().add(BarcodeProduceTypeChanged(v)),
          ),
          const SizedBox(width: 8),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 160),
            child: state.produceGroup == 1 ? const Capsule(text: 'VAT 7%') : const SizedBox.shrink(),
          ),
        ]),
        RadioRow(
          title: 'สินค้าที่ไม่มีภาษีมูลค่าเพิ่ม',
          value: 2,
          group: state.produceGroup,
          onChanged: (v) => context.read<BarcodeBloc>().add(BarcodeProduceTypeChanged(v)),
        ),
      ],
    );
  }

  Widget _buildMoneySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HeaderWithIcon('เงิน', Icons.payments_outlined),
        const SizedBox(height: 8),
        const RowBaseline(children: [
          FormLabel('เงินปันผล :'),
          SizedBox(width: 8),
          UnderlineValue(text: '25000', minWidth: 140),
        ]),
        const SizedBox(height: 8),
        const RowBaseline(children: [
          FormLabel('กลุ่มสินค้า :'),
          SizedBox(width: 8),
          UnderlineValue(text: 'แก้ว', minWidth: 120),
        ]),
      ],
    );
  }
}
