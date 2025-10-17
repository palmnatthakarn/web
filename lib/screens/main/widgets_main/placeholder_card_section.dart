import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_app/blocs/main/app_bloc.dart';
import 'package:flutter_web_app/blocs/main/bloc_state.dart';

import '../../../models/model.dart';

// Analytics and summary section with improved UX
class PlaceholderCardSection extends StatelessWidget {
  const PlaceholderCardSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return LayoutBuilder(
          builder: (context, constraints) {
            // Responsive breakpoints
            final isVerySmall = constraints.maxWidth < 150;
            final isSmall = constraints.maxWidth < 250;

            return Container(
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(isVerySmall ? 8.0 : 12.0),
                child: Column(
                  children: [
                    // Pie Chart Section
                    Expanded(
                      flex: 4,
                      child: _buildPieChart(constraints),
                    ),
                    SizedBox(height: isVerySmall ? 10.0 : 12.0),
                    // Summary Cards
                    Expanded(
                      flex: 6,
                      child: _buildSummaryCards(isVerySmall, isSmall),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Pie Chart Widget
  Widget _buildPieChart(BoxConstraints constraints) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: CustomPaint(
        size: Size.infinite,
        painter: PieChartPainter(),
      ),
    );
  }

  Widget _buildSummaryCards(bool isVerySmall, bool isSmall) {
    final spacing = isVerySmall ? 6.0 : 8.0;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSummaryItem(
            title: 'รายได้',
            value: '50,000฿',
            percentage: '50% ของทั้งหมด',
            color: const Color(0xFF4CAF50),
            icon: Icons.attach_money,
            isVerySmall: isVerySmall,
            isSmall: isSmall,
          ),
          SizedBox(height: spacing),
          _buildSummaryItem(
            title: 'กำไร่วย',
            value: '30,000฿',
            percentage: '30% ของทั้งหมด',
            color: const Color(0xFFEF5350),
            icon: Icons.calendar_today,
            isVerySmall: isVerySmall,
            isSmall: isSmall,
          ),
          SizedBox(height: spacing),
          _buildSummaryItem(
            title: 'ต้นทุน',
            value: '20,000฿',
            percentage: '20% ของทั้งหมด',
            color: const Color(0xFFFF9800),
            icon: Icons.monetization_on,
            isVerySmall: isVerySmall,
            isSmall: isSmall,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({
    required String title,
    required String value,
    required String percentage,
    required Color color,
    required IconData icon,
    required bool isVerySmall,
    required bool isSmall,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isVerySmall ? 10 : (isSmall ? 12 : 14),
        vertical: isVerySmall ? 8 : (isSmall ? 10 : 12),
      ),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(isVerySmall ? 8 : 10),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Row(
        children: [
          // Icon container (circular background)
          Container(
            width: isVerySmall ? 36 : (isSmall ? 42 : 48),
            height: isVerySmall ? 36 : (isSmall ? 42 : 48),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: isVerySmall ? 18 : (isSmall ? 22 : 26),
            ),
          ),
          SizedBox(width: isVerySmall ? 10 : (isSmall ? 12 : 14)),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: isVerySmall ? 11 : (isSmall ? 13 : 15),
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                // Value
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: isVerySmall ? 18 : (isSmall ? 22 : 26),
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                // Percentage
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    percentage,
                    style: TextStyle(
                      fontSize: isVerySmall ? 10 : (isSmall ? 11 : 13),
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Pie Chart Painter
class PieChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius =
        size.width < size.height ? size.width / 2.5 : size.height / 2.5;

    // Colors matching the image
    final greenColor = const Color(0xFF4CAF50);
    final redColor = const Color(0xFFEF5350);
    final orangeColor = const Color(0xFFFF9800);

    // Paint for the pie slices
    final greenPaint = Paint()
      ..color = greenColor
      ..style = PaintingStyle.fill;

    final redPaint = Paint()
      ..color = redColor
      ..style = PaintingStyle.fill;

    final orangePaint = Paint()
      ..color = orangeColor
      ..style = PaintingStyle.fill;

    // Draw pie slices (percentages: 50%, 30%, 20%)
    const startAngle = -90 * 3.14159 / 180; // Start from top

    // Green slice (รายได้ 50%)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      180 * 3.14159 / 180, // 50% = 180 degrees
      true,
      greenPaint,
    );

    // Red slice (กำไร่วย 30%)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle + (180 * 3.14159 / 180),
      108 * 3.14159 / 180, // 30% = 108 degrees
      true,
      redPaint,
    );

    // Orange slice (ต้นทุน 20%)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle + (288 * 3.14159 / 180),
      72 * 3.14159 / 180, // 20% = 72 degrees
      true,
      orangePaint,
    );

    // Draw white circle in center (donut effect)
    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius * 0.5, whitePaint);

    // Draw labels with better positioning
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    // Calculate responsive font sizes
    final titleFontSize = (size.width * 0.065).clamp(10.0, 16.0);
    final percentFontSize = (size.width * 0.085).clamp(14.0, 22.0);

    // รายได้ 50% (left side)
    textPainter.text = TextSpan(
      children: [
        TextSpan(
          text: 'รายได้\n',
          style: TextStyle(
            color: Colors.black87,
            fontSize: titleFontSize,
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
        ),
        TextSpan(
          text: '50%',
          style: TextStyle(
            color: greenColor,
            fontSize: percentFontSize,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
      ],
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx - radius - textPainter.width - 15,
        center.dy - textPainter.height / 2,
      ),
    );

    // กำไ่รวย 30% (top right)
    textPainter.text = TextSpan(
      children: [
        TextSpan(
          text: 'กำไ่รวย\n',
          style: TextStyle(
            color: Colors.black87,
            fontSize: titleFontSize,
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
        ),
        TextSpan(
          text: '30%',
          style: TextStyle(
            color: redColor,
            fontSize: percentFontSize,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
      ],
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx + radius + 15,
        center.dy - radius / 2 - textPainter.height / 2,
      ),
    );

    // ต้นทุน 20% (bottom right)
    textPainter.text = TextSpan(
      children: [
        TextSpan(
          text: 'ต้นทุน\n',
          style: TextStyle(
            color: Colors.black87,
            fontSize: titleFontSize,
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
        ),
        TextSpan(
          text: '20%',
          style: TextStyle(
            color: orangeColor,
            fontSize: percentFontSize,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
      ],
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx + radius + 15,
        center.dy + radius / 3 - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Legacy card component - kept for backward compatibility
class PlaceholderCard extends StatelessWidget {
  final PlaceholderData data;
  const PlaceholderCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Text(
            'Legacy Card Component',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
