import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import '../models/data_model.dart';
import '../utils/performance_utils.dart';

class ApiClient {
  final Dio _dio;

  ApiClient({String? baseUrl})
      : _dio = Dio(BaseOptions(
          baseUrl: baseUrl ?? 'https://api.example.com',
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 3),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ));

  Future<Response> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } catch (e) {
      throw Exception('API request failed: $e');
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } catch (e) {
      throw Exception('API request failed: $e');
    }
  }

  Future<Response> put(String path, {dynamic data}) async {
    try {
      return await _dio.put(path, data: data);
    } catch (e) {
      throw Exception('API request failed: $e');
    }
  }

  Future<Response> delete(String path) async {
    try {
      return await _dio.delete(path);
    } catch (e) {
      throw Exception('API request failed: $e');
    }
  }
}

class Repository {
  // เพิ่มฟังก์ชันสำหรับ Purchase
  Future<List<dynamic>> fetchProducts() async {
    // Mock data สำหรับ products
    return [];
  }

  Future<List<dynamic>> fetchCartItems() async {
    // Mock data สำหรับ cart items
    return [];
  }
}

class ReportRepository {
  final ApiClient _apiClient = ApiClient();

  // Cache สำหรับข้อมูล local
  static List<Data>? _cachedReports;
  static Meta? _cachedMeta;

  // ใช้ API หรือ fallback ไป local files
  Future<({List<Data> reports, Meta meta})> fetchReports({int page = 1}) async {
    PerformanceUtils.startTimer('fetchReports');

    try {
      final response = await _apiClient.get(
        '/reports',
        queryParameters: {'page': page},
      ).timeout(Duration(seconds: 3));

      final List<Data> reports = (response.data['data'] as List)
          .map((item) => Data.fromJson(item))
          .toList();

      final meta = Meta.fromJson(response.data['meta']);

      PerformanceUtils.stopTimer('fetchReports');
      return (reports: reports, meta: meta);
    } catch (e) {
      debugPrint('API failed: $e, falling back to local data');

      // ใช้ cache ถ้ามี
      if (_cachedReports != null && _cachedMeta != null) {
        PerformanceUtils.stopTimer('fetchReports');
        debugPrint('Using cached data: ${_cachedReports!.length} reports');
        return (reports: _cachedReports!, meta: _cachedMeta!);
      }

      final result = await _fetchLocalReports();
      PerformanceUtils.stopTimer('fetchReports');
      return result;
    }
  }

  // โหลดจาก 4 ไฟล์ JSON ที่มีอยู่ (ปรับปรุงประสิทธิภาพ)
  Future<({List<Data> reports, Meta meta})> _fetchLocalReports() async {
    PerformanceUtils.startTimer('fetchLocalReports');

    // ใช้ cache ถ้ามีแล้ว
    if (_cachedReports != null && _cachedMeta != null) {
      PerformanceUtils.stopTimer('fetchLocalReports');
      return (reports: _cachedReports!, meta: _cachedMeta!);
    }

    final List<String> filePaths = [
      'assets/reports.json',
      'assets/รายงานการขายตามวันที่ หน้า 1.json',
      'assets/รายงานการขายตามวันที่ หน้า 2.json',
      'assets/รายงานการขายตามวันที่ หน้า 3.json',
    ];

    final List<Data> allReports = [];
    Meta? combinedMeta;
    int totalRecords = 0;

    // โหลดทีละไฟล์แทนการใช้ Future.wait เพื่อลด memory usage
    for (int i = 0; i < filePaths.length; i++) {
      final path = filePaths[i];
      try {
        PerformanceUtils.startTimer('loadFile_$i');
        final response = await rootBundle.loadString(path);
        final jsonData = json.decode(response);
        final dataField = jsonData['data'];

        if (dataField != null) {
          final List dataList = dataField is List ? dataField : [];
          // ใช้ map แทน loop เพื่อประสิทธิภาพ
          final reports = dataList
              .cast<Map<String, dynamic>>()
              .map((item) => Data.fromJson(item))
              .toList();
          allReports.addAll(reports);
          totalRecords += dataList.length;
        }

        if (combinedMeta == null && jsonData['meta'] != null) {
          combinedMeta = Meta.fromJson(jsonData['meta']);
        }

        PerformanceUtils.stopTimer('loadFile_$i', printResult: false);
      } catch (e) {
        debugPrint('Error loading file $path: $e');
        continue; // ข้ามไฟล์ที่มีปัญหา
      }
    }

    final meta = combinedMeta ??
        Meta(page: 1, size: totalRecords, total: totalRecords, totalPage: 1);

    // Cache ผลลัพธ์
    _cachedReports = allReports;
    _cachedMeta = meta;

    PerformanceUtils.stopTimer('fetchLocalReports');
    debugPrint('✅ Loaded ${allReports.length} reports from local files');

    return (reports: allReports, meta: meta);
  }

  // เพิ่มฟังก์ชันล้าง cache
  static void clearCache() {
    _cachedReports = null;
    _cachedMeta = null;
  }
}
