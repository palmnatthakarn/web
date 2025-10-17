import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_app/screens/report_screen/widgets/process_step_content.dart';



import '../../../blocs/report/bloc.dart';
import '../../../blocs/report/event.dart';
import '../../../blocs/report/state.dart';
import '../../../component/report_screen/date_filter_section.dart';
import 'conditions_header.dart';
import 'report_processor.dart';

class ConditionsTab extends StatefulWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final String? savedConditionName;
  final TabController tabController;
  final Function(DateTime, DateTime) onDatePicked;
  final Function(String?) onSavedConditionNameChanged;

  const ConditionsTab({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.savedConditionName,
    required this.tabController,
    required this.onDatePicked,
    required this.onSavedConditionNameChanged,
  });

  @override
  State<ConditionsTab> createState() => _ConditionsTabState();
}

class _ConditionsTabState extends State<ConditionsTab> {
  bool _isProcessing = false;

  void _onProcessingChanged(bool processing) {
    setState(() {
      _isProcessing = processing;
    });
  }

  @override
  Widget build(BuildContext context) {
    //  final mediaWidth = MediaQuery.of(context).size.width;
    //final mediaHeight = MediaQuery.of(context).size.height;

    return BlocBuilder<ReportBloc, ReportState>(
      builder: (context, state) {
        print('🔍 Current state in ConditionsTab: ${state.runtimeType}');

        if (state is ReportLoaded) {
          print('✅ State is ReportLoaded with ${state.reports.length} reports');

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blue.shade50,
                  Colors.white,
                ],
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 80),
              child: Column(
                children: [
                  // Header
                  //const ConditionsHeader(),
                  // Simple step display
                  //const SizedBox(height: 10),
                  Container(
                    //height: mediaHeight * 0.8, // กำหนดความสูงที่ต้องการ
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 215, 230, 255), // Blue-500
                          Color.fromARGB(255, 194, 208, 248), // Blue-700
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 64, 165, 248)
                              .withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                       /* Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.blue.shade200),
                          ),
                          child: Text(
                            'โปรดเลือกวันที่ที่ต้องการทราบยอดคงเหลือ (ระบบจะคำนวณยอด ณ สิ้นวันของวันที่เลือก)',
                            style: ThemeData().textTheme.bodySmall?.copyWith(
                                  color: Colors.blue.shade800,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),*/
                         Icon(
                          Icons.assessment_outlined,
                          size: 60,
                          color: Colors.blue.shade400,
                        ),
                            const SizedBox(height: 8),
                        Text(
                          'รายงานยอดขาย',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'เลือกช่วงวันที่เพื่อดูรายงาน',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                     
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.blue.shade200),
                          ),
                          child: DateFilterSection(
                            onConditionSaved: (name) =>
                                widget.onSavedConditionNameChanged(name),
                            startDate: widget.startDate,
                            endDate: widget.endDate,
                            tabController: widget.tabController,
                            onDatePicked: widget.onDatePicked,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.blue.shade200),
                          ),
                          child: ProcessStepContent(
                            startDate: widget.startDate,
                            endDate: widget.endDate,
                            reportProcessor: ReportProcessor(
                              context: context,
                              tabController: widget.tabController,
                              onProcessingChanged: _onProcessingChanged,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        } else if (state is ReportLoading) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blue.shade50, Colors.white],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(strokeWidth: 3),
                  SizedBox(height: 16),
                  Text(
                    'กำลังโหลดข้อมูล',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 20),
                  // เพิ่มปุ่ม Retry
                  ElevatedButton(
                    onPressed: () {
                      context.read<ReportBloc>().add(LoadReportsEvent());
                    },
                    child: Text('ลองใหม่'),
                  ),
                ],
              ),
            ),
          );
        } else {
          print('🆕 State is ${state.runtimeType}');

          // ReportInitial state - แสดง DateFilterSection ให้เลือกวันที่ก่อน
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blue.shade50, Colors.white],
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const ConditionsHeader(),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.shade100,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.assessment_outlined,
                          size: 60,
                          color: Colors.blue.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'รายงานยอดขาย',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'เลือกช่วงวันที่เพื่อดูรายงาน',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 24),
                        // แสดง DateFilterSection
                        DateFilterSection(
                          onConditionSaved: (name) =>
                              widget.onSavedConditionNameChanged(name),
                          startDate: widget.startDate,
                          endDate: widget.endDate,
                          tabController: widget.tabController,
                          onDatePicked: widget.onDatePicked,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
