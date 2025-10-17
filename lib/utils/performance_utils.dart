import 'dart:async';
import 'package:flutter/foundation.dart';

class PerformanceUtils {
  static final Map<String, Stopwatch> _stopwatches = {};
  
  /// เริ่มจับเวลา
  static void startTimer(String key) {
    _stopwatches[key] = Stopwatch()..start();
  }
  
  /// หยุดจับเวลาและแสดงผล
  static int stopTimer(String key, {bool printResult = true}) {
    final stopwatch = _stopwatches[key];
    if (stopwatch == null) return 0;
    
    stopwatch.stop();
    final elapsed = stopwatch.elapsedMilliseconds;
    
    if (printResult) {
      print('⏱️ $key took ${elapsed}ms');
    }
    
    _stopwatches.remove(key);
    return elapsed;
  }
  
  /// Debounce function สำหรับลดการเรียก API บ่อยเกินไป
  static Timer? _debounceTimer;
  
  static void debounce(Duration delay, VoidCallback callback) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(delay, callback);
  }
  
  /// Throttle function สำหรับจำกัดการเรียกฟังก์ชัน
  static DateTime? _lastThrottleTime;
  
  static bool throttle(Duration duration) {
    final now = DateTime.now();
    if (_lastThrottleTime == null || 
        now.difference(_lastThrottleTime!) >= duration) {
      _lastThrottleTime = now;
      return true;
    }
    return false;
  }
  
  /// แสดงข้อมูล memory usage (สำหรับ debug)
  static void logMemoryUsage(String context) {
    // ใน production ควรใช้ tools อื่นสำหรับ memory profiling
    print('📊 Memory check at: $context');
  }
}

/// Extension สำหรับ Future เพื่อเพิ่ม timeout และ retry
extension FutureExtensions<T> on Future<T> {
  /// เพิ่ม timeout พร้อม custom error message
  Future<T> withTimeout(Duration timeout, {String? errorMessage}) {
    return this.timeout(
      timeout,
      onTimeout: () => throw TimeoutException(
        errorMessage ?? 'Operation timed out after ${timeout.inSeconds}s',
        timeout,
      ),
    );
  }
  
  /// Retry mechanism
  Future<T> retry(int maxAttempts, {Duration delay = const Duration(seconds: 1)}) async {
    int attempts = 0;
    while (attempts < maxAttempts) {
      try {
        return await this;
      } catch (e) {
        attempts++;
        if (attempts >= maxAttempts) rethrow;
        await Future.delayed(delay);
      }
    }
    throw StateError('Max retry attempts reached');
  }
}