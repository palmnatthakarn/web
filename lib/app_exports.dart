// Central export file for the entire application
// นำเข้าไฟล์นี้เพื่อเข้าถึง BLoC, Component, และ Widget ทั้งหมด
// Example: import 'package:flutter_web_app/app_exports.dart';

// ===== BLoCs =====
export 'blocs/blocs.dart';

// ===== Components =====
export 'component/components.dart';

// ===== Widgets =====
export 'widgets/widgets.dart';

// ===== Models =====
export 'models/model.dart';

// ===== Repositories =====
export 'repository/creditor_repository.dart';

// ===== Services =====
// export 'services/your_service.dart';

// ===== Utils =====
// export 'utils/your_utils.dart';

// ===== Constants =====
// export 'constants/your_constants.dart';

// ===== Theme =====
// export 'theme/app_theme.dart';

/// วิธีใช้งาน:
/// 
/// แทนที่จะเขียนแบบนี้:
/// ```dart
/// import 'package:flutter_web_app/blocs/main/app_bloc.dart';
/// import 'package:flutter_web_app/blocs/creditor/creditor_bloc.dart';
/// import 'package:flutter_web_app/component/all/card_boutton.dart';
/// import 'package:flutter_web_app/widgets/image_upload_box.dart';
/// ```
/// 
/// เขียนแค่นี้:
/// ```dart
/// import 'package:flutter_web_app/app_exports.dart';
/// ```
/// 
/// หรือถ้าต้องการเฉพาะบาง module:
/// ```dart
/// import 'package:flutter_web_app/blocs/blocs.dart';
/// import 'package:flutter_web_app/component/components.dart';
/// ```
