import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/theme_web.dart';

class CardButton {
  static Widget buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTheme.thaiFont(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppTheme.textPrimary,
      ),
    );
  }

 static Widget buildCategoryCard({
  required String title,
  required Color color,
  required VoidCallback onTap,
}) {
  return SizedBox(
    width: 150,   // ✅ กำหนดความกว้างตายตัว
    height: 120,  // ✅ กำหนดความสูงตายตัว
    child: Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: _getGradientForColor(color),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: AppTheme.thaiFont(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  );
}


  static LinearGradient _getGradientForColor(Color color) {
    // ใช้ dashboard_gradient_1 สำหรับสีเขียว (Teal)
    if (color.toARGB32() == const Color(0xFF26A69A).toARGB32()) {
      return dashboard_gradient_1;
    }
    // ใช้ dashboard_gradient_2 สำหรับสีฟ้าอ่อน (Light Blue)
    else if (color.toARGB32() == const Color(0xFF29B6F6).toARGB32()) {
      return dashboard_gradient_2;
    }
    // ใช้ dashboard_gradient_3 สำหรับสีส้ม (Orange)
    else if (color.toARGB32() == const Color(0xFFFF9800).toARGB32()) {
      return dashboard_gradient_3;
    }
    // Default gradient ถ้าไม่ตรงกับสีที่กำหนด
    else {
      return dashboard_gradient_4;
    }
  }
}
