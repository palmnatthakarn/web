import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_app/blocs/main/app_bloc.dart';
import 'package:flutter_web_app/blocs/main/bloc_state.dart';

import '../../../models/model.dart';
import '../../../theme/theme_web.dart';

// DashboardCardsSection
// ใช้สำหรับแสดงการ์ดบนแดชบอร์ด
// ประกอบด้วยการ์ดที่แสดงข้อมูลสำคัญ เช่น รายงานสินค้าที่จำหน่าย รายงานผู้ใช้ทั้งหมด และ รายงานการสั่งซื้อสินค้า
// แต่ละการ์ดจะถูกสร้างขึ้นเป็นวิดเจ็ต DashboardCard

class DashboardCardsSection extends StatelessWidget {
  const DashboardCardsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(20.0),
          child: _buildMainCards(context),
        );
      },
    );
  }

  Widget _buildMainCards(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive design based on available width
        final isVerySmall = constraints.maxWidth < 400;
        final isSmall = constraints.maxWidth < 600;

        return Column(
          children: [
            // Top Row - 3 Equal Cards (Yellow, Blue, Green)
            if (isVerySmall)
              // Stack layout for very small screens
              Column(
                children: [
                  _buildMainRevenueCard(isVerySmall),
                  const SizedBox(height: 10),
                  _buildSalesCard(isVerySmall),
                  const SizedBox(height: 10),
                  _buildProfitRateCard(isVerySmall),
                ],
              )
            else
              // Row layout: 3 equal cards side by side
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main Revenue Card (Yellow)
                  Expanded(
                    child: _buildMainRevenueCard(isVerySmall),
                  ),
                  const SizedBox(width: 12),
                  // Profit/Loss Card (Blue)
                  Expanded(
                    child: _buildSalesCard(isVerySmall),
                  ),
                  const SizedBox(width: 12),
                  // Profit Rate Card (Green)
                  Expanded(
                    child: _buildProfitRateCard(isVerySmall),
                  ),
                ],
              ),

            const SizedBox(height: 15),

            // Bottom Row - Summary Card + Chart
            if (isSmall)
              // Stack for small screens
              Column(
                children: [
                  _buildBottomCard(),
                  const SizedBox(height: 15),
                  _buildChartSection(),
                ],
              )
            else
              // Side by side for larger screens
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bottom Summary Card (Purple) - Left
                  Expanded(
                    flex: 1,
                    child: _buildBottomCard(),
                  ),
                  const SizedBox(width: 15),
                  // Chart Section - Right
                  Expanded(
                    flex: 2,
                    child: _buildChartSection(),
                  ),
                ],
              ),
          ],
        );
      },
    );
  }

  Widget _buildMainRevenueCard(bool isVerySmall) {
    return Container(
      height: isVerySmall ? 100 : 120,
      decoration: BoxDecoration(
        gradient: dashboard_gradient_1,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(isVerySmall ? 12.0 : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ยอดขายวันนี้/บาท',
              style: TextStyle(
                color: Colors.white,
                fontSize: isVerySmall ? 11 : 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                '23,050.05',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isVerySmall ? 28 : 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Chart Section with Bar Chart
  Widget _buildChartSection() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Top Row - Status and Month Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // รอรับชำระ/รอชำระ section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'รอรับชำระ/รอชำระ:',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '6 รายการรอระบบ',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '0 รายการเก่าผ่านกำหนด',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // เลือกเดือน dropdown
                Flexible(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'เลือกเดือน',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_drop_down,
                          size: 18,
                          color: Colors.grey[700],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Bar Chart
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: _buildBarChartBars(),
              ),
            ),

            const SizedBox(height: 8),

            // Month Labels
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                'ก.ย./ต.ค./พ.ย.',
                'เดือน',
                'ก.ค.',
                'ส.ค',
                'ก.ย',
              ]
                  .map((label) => Expanded(
                        child: Center(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              label,
                              style: TextStyle(
                                fontSize: 9,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildBarChartBars() {
    // Sample data for bars - matching the image pattern
    final heights = [
      0.3, 0.2, 0.7, 0.9, 0.25, // ก.ย./ต.ค./พ.ย.
      0.6, 0.8, 0.3, 0.15, // เดือน
      0.8, 0.9, 0.85, 0.75, // ก.ค.
      0.7, 0.6, // ส.ค
      0.4, 0.5, // ก.ย
    ];

    return heights.map((height) {
      return Container(
        width: 8,
        height: 70 * height,
        decoration: BoxDecoration(
          color: Colors.blue.shade600,
          borderRadius: BorderRadius.circular(2),
        ),
      );
    }).toList();
  }

  // Profit/Loss Card (Blue)
  Widget _buildSalesCard(bool isVerySmall) {
    return Container(
      height: isVerySmall ? 100 : 120,
      decoration: BoxDecoration(
        gradient: dashboard_gradient_2,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(isVerySmall ? 12.0 : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'กำไร/ขาดทุน',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isVerySmall ? 11 : 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(
                  Icons.trending_up,
                  color: Colors.white,
                  size: isVerySmall ? 18 : 24,
                ),
              ],
            ),
            const SizedBox(height: 8),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                '฿ 41,000',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isVerySmall ? 28 : 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Profit Rate Card (Green)
  Widget _buildProfitRateCard(bool isVerySmall) {
    return Container(
      height: isVerySmall ? 100 : 120,
      decoration: BoxDecoration(
        gradient: dashboard_gradient_3,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(isVerySmall ? 12.0 : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'อัตรากำไร',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isVerySmall ? 11 : 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 8),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                '36%',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isVerySmall ? 36 : 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomCard() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple, Colors.deepPurple.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Title
            Text(
              'ยอดรวมทั้งหมด',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),

            // Main Amount
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                '฿100,000',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  height: 1.0,
                ),
              ),
            ),

            // Bottom Info Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // กำไรสุทธิ
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'กำไรสุทธิ',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '52,000',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // อัตรากำไร
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'อัตรากำไร',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '36%',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// DashboardCard - เก็บไว้สำหรับใช้งานอื่นในอนาคต
class DashboardCard extends StatelessWidget {
  final DashboardCardData data;
  const DashboardCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width * 0.2,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 244, 244, 244),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.width * 0.16,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    elevation: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: dashboard_gradient_1,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.18,
                      height: MediaQuery.of(context).size.width * 0.08,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        elevation: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: dashboard_gradient_2,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 50),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.18,
                      height: MediaQuery.of(context).size.width * 0.08,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        elevation: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: dashboard_gradient_3,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
