# Form Components

This directory contains reusable form components that can be used throughout the application.

## Components

### 1. EnhancedRadioGroup
A customizable radio group widget with icons and enhanced styling.

**Usage:**
```dart
EnhancedRadioGroup(
  title: 'ประเภทภาษี',
  icon: Icons.receipt_outlined,
  color: Colors.blue,
  options: [
    'ราคาไม่รวมภาษี',
    'ราคารวมภาษี',
    'ภาษีอัตราศูนย์',
    'ไม่กระทบภาษี'
  ],
  selectedValue: _selectedTaxType,
  onChanged: (value) => setState(() {
    _selectedTaxType = value;
  }),
)
```

### 2. DatePickerField
A customizable date picker widget with Thai Buddhist calendar support.

**Usage:**
```dart
DatePickerField(
  label: 'วันที่เอกสาร',
  selectedDate: _selectedDate,
  onChanged: (date) => setState(() {
    _selectedDate = date;
  }),
  isRequired: true, // Optional, defaults to false
)
```

### 3. TimePickerField
A customizable time picker widget with consistent styling.

**Usage:**
```dart
TimePickerField(
  label: 'เวลา',
  selectedTime: _selectedTime,
  onChanged: (time) => setState(() {
    _selectedTime = time;
  }),
)
```

## Import

To use these components, import the form_components.dart file:

```dart
import 'package:flutter_web_app/component/all/form_components.dart';
```

This will give you access to all form components including:
- EnhancedRadioGroup
- DatePickerField
- TimePickerField
- SectionBuilder (from buildSection.dart)
- CardButton (from card_boutton.dart)

## Features

- **Consistent Styling**: All components follow the same design system
- **Responsive**: Components adapt to different screen sizes
- **Accessible**: Proper focus management and keyboard navigation
- **Customizable**: Easy to customize colors, icons, and styling
- **Thai Support**: Date picker includes Thai Buddhist calendar (พ.ศ.)