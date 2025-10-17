#!/usr/bin/env dart
// Component Checker - ตรวจสอบ Component ทั้งหมดที่มีในโปรเจค
// Run: dart lib/scripts/check_components.dart

import 'dart:io';

void main() {
  print('🔍 กำลังตรวจสอบ BLoC และ Components...\n');

  checkBlocs();
  checkComponents();
  checkWidgets();
  checkScreens();

  print('\n✅ ตรวจสอบเสร็จสิ้น!');
  print('📚 อ่านเอกสารเพิ่มเติม:');
  print('   - lib/ARCHITECTURE.md');
  print('   - lib/QUICK_REFERENCE.md');
  print('   - lib/README_ORGANIZATION.md');
}

void checkBlocs() {
  print('📦 BLoCs:');
  final blocDir = Directory('lib/blocs');

  if (!blocDir.existsSync()) {
    print('   ❌ ไม่พบโฟลเดอร์ blocs/');
    return;
  }

  final dirs = blocDir
      .listSync()
      .whereType<Directory>()
      .map((d) => d.path.split(Platform.pathSeparator).last)
      .where((name) => !name.startsWith('.'))
      .toList();

  for (var dir in dirs) {
    print('   ✓ $dir/');
  }

  // Check barrel file
  final barrelFile = File('lib/blocs/blocs.dart');
  if (barrelFile.existsSync()) {
    print('   ✓ blocs.dart (Barrel File) ✨');
  } else {
    print('   ⚠️  blocs.dart ยังไม่มี Barrel File');
  }
  print('');
}

void checkComponents() {
  print('🧩 Components:');
  final componentDir = Directory('lib/component/all');

  if (!componentDir.existsSync()) {
    print('   ❌ ไม่พบโฟลเดอร์ component/all/');
    return;
  }

  final files = componentDir
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .map((f) => f.path.split(Platform.pathSeparator).last)
      .toList();

  for (var file in files) {
    if (file == 'README.md') continue;
    print('   ✓ $file');
  }

  // Check barrel file
  final barrelFile = File('lib/component/components.dart');
  if (barrelFile.existsSync()) {
    print('   ✓ components.dart (Barrel File) ✨');
  } else {
    print('   ⚠️  components.dart ยังไม่มี Barrel File');
  }
  print('');
}

void checkWidgets() {
  print('🎨 Custom Widgets:');
  final widgetDir = Directory('lib/widgets');

  if (!widgetDir.existsSync()) {
    print('   ❌ ไม่พบโฟลเดอร์ widgets/');
    return;
  }

  final files = widgetDir
      .listSync()
      .whereType<File>()
      .where(
          (f) => f.path.endsWith('.dart') && !f.path.endsWith('widgets.dart'))
      .map((f) => f.path.split(Platform.pathSeparator).last)
      .toList();

  for (var file in files) {
    print('   ✓ $file');
  }

  // Check barrel file
  final barrelFile = File('lib/widgets/widgets.dart');
  if (barrelFile.existsSync()) {
    print('   ✓ widgets.dart (Barrel File) ✨');
  } else {
    print('   ⚠️  widgets.dart ยังไม่มี Barrel File');
  }
  print('');
}

void checkScreens() {
  print('📱 Screen Widgets:');
  final screenDir = Directory('lib/screens/main/widgets_main');

  if (!screenDir.existsSync()) {
    print('   ❌ ไม่พบโฟลเดอร์ screens/main/widgets_main/');
    return;
  }

  final files = screenDir
      .listSync()
      .whereType<File>()
      .where((f) =>
          f.path.endsWith('.dart') && !f.path.endsWith('widgets_main.dart'))
      .map((f) => f.path.split(Platform.pathSeparator).last)
      .toList();

  for (var file in files) {
    print('   ✓ $file');
  }

  // Check barrel file
  final barrelFile = File('lib/screens/main/widgets_main/widgets_main.dart');
  if (barrelFile.existsSync()) {
    print('   ✓ widgets_main.dart (Barrel File) ✨');
  } else {
    print('   ⚠️  widgets_main.dart ยังไม่มี Barrel File');
  }
}
