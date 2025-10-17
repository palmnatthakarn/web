import 'package:flutter/material.dart';

/// A complete collapsible panel widget with all features in one file
///
/// Features:
/// - Responsive width calculation
/// - Resizable with drag divider
/// - Collapse/expand animation
/// - Customizable appearance
/// - Easy integration with any content
class CollapsiblePanelWidget extends StatefulWidget {
  /// The content widget to display inside the panel
  final Widget child;

  /// Initial collapsed state
  final bool initiallyCollapsed;

  /// Whether to show the resizable divider
  final bool showResizableDivider;

  /// Callback when the divider is dragged
  final void Function(double dx)? onDividerDrag;

  /// Custom width for the panel (if null, uses responsive calculation)
  final double? customWidth;

  /// Minimum width constraint
  final double minWidth;

  /// Maximum width constraint
  final double maxWidth;

  /// Background color of the panel
  final Color? backgroundColor;

  /// Position of the collapse button from top
  final double collapseButtonTopMargin;

  /// Custom collapse button widget
  final Widget? customCollapseButton;

  /// Builder for custom collapse button that receives current state
  final Widget Function(bool isCollapsed, VoidCallback onTap)?
      customCollapseButtonBuilder;

  /// Callback when collapse state changes
  final void Function(bool isCollapsed)? onCollapseChanged;

  /// Divider width
  final double dividerWidth;

  /// Divider handle height
  final double dividerHandleHeight;

  /// Divider hover color
  final Color? dividerHoverColor;

  /// Divider default color
  final Color? dividerDefaultColor;

  /// Divider handle color
  final Color? dividerHandleColor;

  const CollapsiblePanelWidget({
    super.key,
    required this.child,
    this.initiallyCollapsed = false,
    this.showResizableDivider = true,
    this.onDividerDrag,
    this.customWidth,
    this.minWidth = 300.0,
    this.maxWidth = 600.0,
    this.backgroundColor = Colors.white,
    this.collapseButtonTopMargin = 100.0,
    this.customCollapseButton,
    this.customCollapseButtonBuilder,
    this.onCollapseChanged,
    this.dividerWidth = 4.0,
    this.dividerHandleHeight = 120.0,
    this.dividerHoverColor,
    this.dividerDefaultColor,
    this.dividerHandleColor,
  });

  @override
  State<CollapsiblePanelWidget> createState() => _CollapsiblePanelWidgetState();
}

class _CollapsiblePanelWidgetState extends State<CollapsiblePanelWidget> {
  late bool _isCollapsed;
  double _currentWidth = 0; // 0 means use responsive calculation
  bool _isDividerHovered = false;

  @override
  void initState() {
    super.initState();
    _isCollapsed = widget.initiallyCollapsed;
    _currentWidth = widget.customWidth ?? 0;
  }

  void _toggleCollapse() {
    setState(() {
      _isCollapsed = !_isCollapsed;
    });
    widget.onCollapseChanged?.call(_isCollapsed);
  }

  void _adjustWidth(double delta) {
    if (_isCollapsed) return;

    setState(() {
      _currentWidth =
          (_currentWidth + delta).clamp(widget.minWidth, widget.maxWidth);
    });

    widget.onDividerDrag?.call(delta);
  }

  double _calculatePanelWidth(BuildContext context) {
    if (_isCollapsed) return 0;

    // Use current width if set (from dragging)
    if (_currentWidth > 0) {
      return _currentWidth.clamp(widget.minWidth, widget.maxWidth);
    }

    // Responsive calculation
    final screenWidth = MediaQuery.of(context).size.width;
    double panelWidth;

    if (screenWidth > 1200) {
      panelWidth = screenWidth * 0.35; // 35% for large screens
    } else if (screenWidth > 800) {
      panelWidth = screenWidth * 0.4; // 40% for medium screens
    } else {
      panelWidth = screenWidth * 0.45; // 45% for small screens
    }

    return panelWidth.clamp(widget.minWidth, widget.maxWidth);
  }

  Widget _buildCollapseButton() {
    // Use builder if provided (preferred method)
    if (widget.customCollapseButtonBuilder != null) {
      return widget.customCollapseButtonBuilder!(_isCollapsed, _toggleCollapse);
    }

    // Fallback to static widget
    if (widget.customCollapseButton != null) {
      return GestureDetector(
        onTap: _toggleCollapse,
        child: widget.customCollapseButton!,
      );
    }

    return Container(
      width: 16,
      height: 60,
      margin: EdgeInsets.only(top: widget.collapseButtonTopMargin),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: InkWell(
        onTap: _toggleCollapse,
        child: Center(
          child: Icon(
            _isCollapsed
                ? Icons.keyboard_arrow_right
                : Icons.keyboard_arrow_left,
            color: Colors.grey[600],
            size: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildResizableDivider() {
    if (!widget.showResizableDivider) {
      return const SizedBox.shrink();
    }

    return MouseRegion(
      cursor: SystemMouseCursors.resizeColumn,
      onEnter: (_) => setState(() => _isDividerHovered = true),
      onExit: (_) => setState(() => _isDividerHovered = false),
      child: GestureDetector(
        onPanUpdate: (details) => _adjustWidth(details.delta.dx),
        child: Container(
          width: widget.dividerWidth,
          color: _isDividerHovered
              ? (widget.dividerHoverColor ??
                  Colors.blue.withOpacity(0.15))
              : (widget.dividerDefaultColor ?? Colors.grey[300]),
          child: Center(
            child: Container(
              width: 2,
              height: widget.dividerHandleHeight,
              color: widget.dividerHandleColor ?? Colors.grey[400],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final panelWidth = _calculatePanelWidth(context);

    return Row(
      children: [
        // Main panel content
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: panelWidth,
          child: _isCollapsed
              ? const SizedBox.shrink()
              : Row(
                  children: [
                    // Panel content
                    Expanded(
                      child: Container(
                        color: widget.backgroundColor,
                        child: widget.child,
                      ),
                    ),

                    // Resizable divider (only when not collapsed)
                    if (!_isCollapsed) _buildResizableDivider(),
                  ],
                ),
        ),

        // Collapse/Expand button
        _buildCollapseButton(),
      ],
    );
  }
}

/// Extension methods for easy usage
extension CollapsiblePanelExtensions on Widget {
  /// Wrap this widget in a CollapsiblePanelWidget
  Widget asCollapsiblePanel({
    bool initiallyCollapsed = false,
    bool showResizableDivider = true,
    void Function(double dx)? onDividerDrag,
    double? customWidth,
    double minWidth = 300.0,
    double maxWidth = 600.0,
    Color? backgroundColor = Colors.white,
    double collapseButtonTopMargin = 100.0,
    Widget? customCollapseButton,
    Widget Function(bool isCollapsed, VoidCallback onTap)?
        customCollapseButtonBuilder,
    void Function(bool isCollapsed)? onCollapseChanged,
  }) {
    return CollapsiblePanelWidget(
      initiallyCollapsed: initiallyCollapsed,
      showResizableDivider: showResizableDivider,
      onDividerDrag: onDividerDrag,
      customWidth: customWidth,
      minWidth: minWidth,
      maxWidth: maxWidth,
      backgroundColor: backgroundColor,
      collapseButtonTopMargin: collapseButtonTopMargin,
      customCollapseButton: customCollapseButton,
      customCollapseButtonBuilder: customCollapseButtonBuilder,
      onCollapseChanged: onCollapseChanged,
      child: this,
    );
  }
}

/// Helper class for creating custom collapse buttons
class CollapseButtonBuilder {
  /// Create a gradient collapse button
  static Widget gradient({
    required Gradient gradient,
    String? tooltip,
    double width = 16,
    double height = 60,
    bool isCollapsed = false,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: tooltip != null
          ? Tooltip(
              message: tooltip,
              child: Center(
                child: Icon(
                  isCollapsed
                      ? Icons.keyboard_arrow_right
                      : Icons.keyboard_arrow_left,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            )
          : Center(
              child: Icon(
                isCollapsed
                    ? Icons.keyboard_arrow_right
                    : Icons.keyboard_arrow_left,
                color: Colors.white,
                size: 14,
              ),
            ),
    );
  }

  /// Create a simple colored collapse button
  static Widget simple({
    Color? color,
    String? tooltip,
    double width = 16,
    double height = 60,
    bool isCollapsed = false,
    IconData? expandIcon,
    IconData? collapseIcon,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color ?? Colors.grey[200],
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: tooltip != null
          ? Tooltip(
              message: tooltip,
              child: Center(
                child: Icon(
                  isCollapsed
                      ? (expandIcon ?? Icons.keyboard_arrow_right)
                      : (collapseIcon ?? Icons.keyboard_arrow_left),
                  color: Colors.grey[600],
                  size: 14,
                ),
              ),
            )
          : Center(
              child: Icon(
                isCollapsed
                    ? (expandIcon ?? Icons.keyboard_arrow_right)
                    : (collapseIcon ?? Icons.keyboard_arrow_left),
                color: Colors.grey[600],
                size: 14,
              ),
            ),
    );
  }
}
