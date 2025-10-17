# CollapsiblePanelWidget - Single File Component

A complete collapsible panel widget with all features in one file. Perfect for creating responsive, resizable, and collapsible side panels.

## Features

- ✅ **Responsive Design**: Automatically adjusts to screen size
- ✅ **Resizable**: Drag to resize panel width
- ✅ **Collapsible**: Smooth collapse/expand animations
- ✅ **Customizable**: Custom buttons, colors, and dimensions
- ✅ **Single File**: Everything in one file for easy integration
- ✅ **Extension Methods**: Clean syntax with extension methods
- ✅ **Builder Pattern**: Dynamic button creation with state

## Quick Start

### Basic Usage

```dart
import 'package:your_app/component/all/collapsible_panel_widget.dart';

// Simple usage
CollapsiblePanelWidget(
  child: YourContentWidget(),
)
```

### With Custom Button

```dart
CollapsiblePanelWidget(
  customCollapseButtonBuilder: (isCollapsed, onTap) {
    return GestureDetector(
      onTap: onTap,
      child: CollapseButtonBuilder.gradient(
        gradient: LinearGradient(colors: [Colors.blue, Colors.purple]),
        tooltip: 'Toggle Panel',
        isCollapsed: isCollapsed,
      ),
    );
  },
  child: YourContentWidget(),
)
```

### Using Extension Method

```dart
YourContentWidget().asCollapsiblePanel(
  minWidth: 300,
  maxWidth: 600,
  onDividerDrag: (dx) => print('Resized by: $dx'),
)
```

## Parameters

| Parameter                     | Type                | Default        | Description                      |
| ----------------------------- | ------------------- | -------------- | -------------------------------- |
| `child`                       | `Widget`            | required       | Content to display inside panel  |
| `initiallyCollapsed`          | `bool`              | `false`        | Initial collapsed state          |
| `showResizableDivider`        | `bool`              | `true`         | Show/hide resizable divider      |
| `onDividerDrag`               | `Function(double)?` | `null`         | Callback when divider is dragged |
| `customWidth`                 | `double?`           | `null`         | Custom width (null = responsive) |
| `minWidth`                    | `double`            | `300.0`        | Minimum width constraint         |
| `maxWidth`                    | `double`            | `600.0`        | Maximum width constraint         |
| `backgroundColor`             | `Color?`            | `Colors.white` | Panel background color           |
| `collapseButtonTopMargin`     | `double`            | `100.0`        | Button position from top         |
| `customCollapseButton`        | `Widget?`           | `null`         | Static custom button             |
| `customCollapseButtonBuilder` | `Function?`         | `null`         | Dynamic button builder           |
| `onCollapseChanged`           | `Function(bool)?`   | `null`         | Collapse state callback          |

## Custom Buttons

### Gradient Button

```dart
CollapseButtonBuilder.gradient(
  gradient: LinearGradient(colors: [Colors.orange, Colors.red]),
  tooltip: 'Toggle Sidebar',
  isCollapsed: isCollapsed,
)
```

### Simple Button

```dart
CollapseButtonBuilder.simple(
  color: Colors.green,
  tooltip: 'Toggle',
  isCollapsed: isCollapsed,
  expandIcon: Icons.menu,
  collapseIcon: Icons.close,
)
```

## Integration Examples

### With BLoC

```dart
class MyPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyBloc, MyState>(
      builder: (context, state) {
        return CollapsiblePanelWidget(
          customWidth: state.panelWidth > 0 ? state.panelWidth : null,
          onDividerDrag: (dx) {
            context.read<MyBloc>().add(PanelResized(dx));
          },
          child: MyPanelContent(),
        );
      },
    );
  }
}
```

### With State Management

```dart
class MyScreen extends StatefulWidget {
  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  double _panelWidth = 0;
  bool _isCollapsed = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CollapsiblePanelWidget(
          customWidth: _panelWidth > 0 ? _panelWidth : null,
          initiallyCollapsed: _isCollapsed,
          onDividerDrag: (dx) {
            setState(() {
              _panelWidth = (_panelWidth + dx).clamp(300.0, 600.0);
            });
          },
          onCollapseChanged: (collapsed) {
            setState(() {
              _isCollapsed = collapsed;
            });
          },
          child: MyPanelContent(),
        ),
        Expanded(child: MyMainContent()),
      ],
    );
  }
}
```

## Responsive Breakpoints

The widget automatically calculates responsive width:

- **Large screens (>1200px)**: 35% of screen width
- **Medium screens (800-1200px)**: 40% of screen width
- **Small screens (<800px)**: 45% of screen width

All calculations respect `minWidth` and `maxWidth` constraints.

## Real-World Usage

### Barcode Screen Example

```dart
class BarcodeLeftPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BarcodeBloc, BarcodeState>(
      builder: (context, state) {
        return CollapsiblePanelWidget(
          customWidth: state.leftPanelWidth > 0 ? state.leftPanelWidth : null,
          onDividerDrag: (dx) {
            context.read<BarcodeBloc>().add(BarcodeLeftPanelDragged(dx));
          },
          customCollapseButtonBuilder: (isCollapsed, onTap) {
            return GestureDetector(
              onTap: onTap,
              child: CollapseButtonBuilder.gradient(
                gradient: dashboard_gradient_2,
                tooltip: 'ตาราง',
                isCollapsed: isCollapsed,
              ),
            );
          },
          child: BarcodeListContent(),
        );
      },
    );
  }
}
```

## File Structure

```
lib/component/all/
├── collapsible_panel_widget.dart          # Main component (single file)
├── collapsible_panel_widget_example.dart  # Usage examples
└── README_collapsible_panel_widget.md     # This documentation
```

## Migration from Multiple Files

If you were using the multi-file version, migration is simple:

**Before:**

```dart
import 'package:your_app/component/all/collapsible_components.dart';

CollapsiblePanelWithController(
  controller: controller,
  child: content,
)
```

**After:**

```dart
import 'package:your_app/component/all/collapsible_panel_widget.dart';

CollapsiblePanelWidget(
  child: content,
)
```

## Advantages of Single File Component

1. **Easy Integration**: Just import one file
2. **No Dependencies**: Self-contained component
3. **Better Performance**: No multiple file imports
4. **Simpler Maintenance**: Everything in one place
5. **Cleaner API**: Unified interface

## Tips

1. Use `customCollapseButtonBuilder` for dynamic buttons
2. Use `customCollapseButton` for static buttons
3. Set `customWidth` to override responsive calculation
4. Use extension methods for cleaner syntax
5. Handle `onCollapseChanged` for state synchronization

## Examples

See `collapsible_panel_widget_example.dart` for complete working examples including:

- Basic usage
- Custom buttons
- Extension methods
- State management
- BLoC integration
