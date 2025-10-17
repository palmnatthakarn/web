import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../constants/app_strings.dart';

class UIService {
  static UIService? _instance;

  UIService._internal();

  factory UIService() {
    _instance ??= UIService._instance ?? UIService._internal();
    return _instance!;
  }

  /// Check if device is tablet
  bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width > AppConstants.tabletBreakpoint;
  }

  /// Get responsive padding
  EdgeInsets getResponsivePadding(BuildContext context) {
    final isTabletDevice = isTablet(context);
    return EdgeInsets.symmetric(
      horizontal: isTabletDevice
          ? AppConstants.tabletPadding
          : AppConstants.defaultPadding,
      vertical: AppConstants.defaultPadding,
    );
  }

  /// Create gradient decoration
  BoxDecoration createGradientDecoration({
    required List<Color> colors,
    AlignmentGeometry begin = Alignment.topCenter,
    AlignmentGeometry end = Alignment.bottomCenter,
    double borderRadius = 0,
    List<BoxShadow>? boxShadow,
  }) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: begin,
        end: end,
        colors: colors,
      ),
      borderRadius:
          borderRadius > 0 ? BorderRadius.circular(borderRadius) : null,
      boxShadow: boxShadow,
    );
  }

  /// Create card decoration
  BoxDecoration createCardDecoration({
    Color? color,
    double borderRadius = AppConstants.cardBorderRadius,
    bool withShadow = true,
  }) {
    return BoxDecoration(
      color: color ?? Colors.white,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: withShadow
          ? [
              BoxShadow(
                color:
                    Colors.grey.withOpacity(AppConstants.shadowOpacity),
                spreadRadius: 0,
                blurRadius: AppConstants.cardShadowBlur,
                offset: const Offset(0, AppConstants.cardShadowOffset),
              ),
              BoxShadow(
                color: Colors.grey
                    .withOpacity(AppConstants.shadowOpacity / 2),
                spreadRadius: 0,
                blurRadius: AppConstants.cardShadowOffset,
                offset: const Offset(0, 2),
              ),
            ]
          : null,
    );
  }

  /// Create section header decoration
  BoxDecoration createSectionHeaderDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Colors.grey.shade50,
          Colors.grey.shade100,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(AppConstants.cardBorderRadius),
        topRight: Radius.circular(AppConstants.cardBorderRadius),
      ),
      border: Border(
        bottom: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
    );
  }

  /// Create responsive grid
  Widget createResponsiveGrid({
    required List<Widget> children,
    int crossAxisCount = 2,
    double spacing = 12,
  }) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: spacing,
      mainAxisSpacing: spacing,
      childAspectRatio: 3,
      children: children,
    );
  }

  /// Create change indicator widget
  Widget createChangeIndicator(double changeAmount) {
    final isPositive = changeAmount >= 0;
    final color = isPositive ? Colors.green : Colors.red;
    final icon = isPositive ? Icons.keyboard_return : Icons.warning_outlined;
    final label = isPositive
        ? AppStrings.changeAmountLabel
        : AppStrings.insufficientAmountLabel;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color.shade100,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            '$label ${_formatCurrency(changeAmount.abs())}${AppStrings.currencyUnit}',
            style: TextStyle(
              color: color.shade100,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Create VAT mode indicator
  Widget createVatModeIndicator(bool isInclusive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isInclusive
            ? AppStrings.vatInclusiveLabel
            : AppStrings.vatExclusiveLabel,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Create quick action button
  Widget createQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Format currency (helper method)
  String _formatCurrency(double amount) {
    // This should ideally use the CalculationService, but to avoid circular dependency
    // we'll implement a simple version here
    return amount.toStringAsFixed(AppConstants.maxDecimalPlaces);
  }

  /// Create constrained content container
  Widget createConstrainedContent({
    required Widget child,
    double maxWidth = AppConstants.maxContentWidth,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: child,
    );
  }

  /// Create section spacing
  Widget createSectionSpacing() {
    return const SizedBox(height: AppConstants.sectionSpacing);
  }
}
