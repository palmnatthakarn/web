import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_app/repository/repository.dart';
import 'package:intl/intl.dart';
import '../../models/data_model.dart';
import 'event.dart';
import 'state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final ReportRepository repository;

  ReportBloc(this.repository) : super(ReportInitial()) {
    print('🧠 ReportBloc created');
    on<SearchReportsEvent>((event, emit) {
      if (isClosed) return;
      
      if (state is ReportLoaded) {
        final current = state as ReportLoaded;

        final keyword = event.keyword.toLowerCase();
        final filtered = current.reports.where((item) {
          final dateStr = DateFormat('yyyy-MM-dd').format(item.docDate).toLowerCase();
          final amountStr = item.totalAmount.toString();
          return dateStr.contains(keyword) || amountStr.contains(keyword);
        }).toList();

        if (!isClosed) {
          emit(current.copyWith(filteredReports: filtered));
        }
      }
    });
    // เพิ่มใน constructor ของ ReportBloc
    on<UpdateFilteredReportsEvent>((event, emit) {
      if (isClosed) return;
      
      print('🔄 UpdateFilteredReportsEvent received: ${event.filteredReports.length} items');

      if (state is ReportLoaded) {
        final current = state as ReportLoaded;

        print('📊 Current state: ${current.reports.length} reports, ${current.filteredReports.length} filtered');
        print('🔄 Updating filtered reports to: ${event.filteredReports.length} items');

        final newState = current.copyWith(
          filteredReports: event.filteredReports,
          currentPage: 1,
        );

        if (!isClosed) {
          emit(newState);
          print('✅ UpdateFilteredReportsEvent completed');
        }
      } else {
        print('❌ UpdateFilteredReportsEvent: State is not ReportLoaded');
      }
    });

// แก้ไขส่วน LoadReportsEvent
    on<LoadReportsEvent>((event, emit) async {
      print('🟡 LoadReportsEvent triggered');

      // ป้องกันการโหลดซ้ำถ้ากำลังโหลดอยู่
      if (state is ReportLoading) {
        print('⚠️ Already loading, skipping...');
        return;
      }

      // ตรวจสอบว่า BLoC ยังไม่ถูก close
      if (isClosed) {
        print('⚠️ BLoC is closed, skipping LoadReportsEvent');
        return;
      }

      emit(ReportLoading());

      try {
        print('🟡 Calling repository.fetchReports()...');
        final stopwatch = Stopwatch()..start();
        
        final result = await repository.fetchReports().timeout(Duration(seconds: 30));
        
        // ตรวจสอบอีกครั้งหลังจาก async operation
        if (isClosed) {
          print('⚠️ BLoC was closed during async operation');
          return;
        }
        
        final reports = result.reports;
        final meta = result.meta;

        stopwatch.stop();
        print('⏱️ Data loaded in ${stopwatch.elapsedMilliseconds}ms');
        print('✅ Repository returned: ${reports.length} reports');
        print('📊 Meta: page=${meta.page}, size=${meta.size}, total=${meta.total}');

        if (reports.isEmpty) {
          print('⚠️ Warning: No reports found in data');
          if (!isClosed) {
            emit(ReportError('ไม่พบข้อมูลรายงาน'));
          }
          return;
        }

        print('📄 Sample report: ${reports.first.docDate} - ${reports.first.totalAmount}');

        if (!isClosed) {
          emit(ReportLoaded(
            reports,
            allReports: reports,
            currentPage: meta.page,
            itemsPerPage: meta.size,
            selectedIndexes: {0, 1, 2, 3, 4, 5, 6, 7, 8},
          ));
          print('✅ ReportLoaded state emitted successfully');
        }
      } catch (e, stack) {
        print('❌ LoadReportsEvent ERROR: $e');
        print('📛 STACK: $stack');
        if (!isClosed) {
          emit(ReportError('เกิดข้อผิดพลาดในการโหลดข้อมูล: ${e.toString()}'));
        }
      }
    });

    on<FilterReportsEvent>((event, emit) {
      if (state is ReportLoaded) {
        final current = state as ReportLoaded;

        final filtered = current.reports.where((item) {
          final date = item.docDate;
          final matchMonth = event.month == null || date.month == event.month;
          final matchYear = event.year == null || date.year == event.year;
          return matchMonth && matchYear;
        }).toList();

        emit(ReportLoaded(current.reports, filtered: filtered));
      }
    });
    on<SetStepEvent>((event, emit) {
      if (state is ReportLoaded) {
        final current = state as ReportLoaded;
        emit(current.copyWith(currentStep: event.currentStep));
      }
    });
    // แก้ไข SetDateRangeEvent
    on<SetDateRangeEvent>((event, emit) {
      if (isClosed) return;
      
      print('📅 SetDateRangeEvent: ${event.startDate} to ${event.endDate}');

      if (state is ReportLoaded) {
        final current = state as ReportLoaded;

        final newState = current.copyWith(
          startDate: event.startDate,
          endDate: event.endDate,
        );

        if (!isClosed) {
          emit(newState);
          print('✅ Date range updated in state');
        }
      } else {
        print('📅 Date range set for initial state');
      }
    });

    on<SelectReportType>((event, emit) {
      if (state is ReportLoaded) {
        final current = state as ReportLoaded;
        emit(current.copyWith(selectedReportType: event.reportType));
      }
    });
    on<UpdateCardDataEvent>((event, emit) {
      if (state is ReportLoaded) {
        final current = state as ReportLoaded;
        // สร้าง newCardData โดยคัดลอกข้อมูลเดิม
        final newCardData = Map<int, dynamic>.from(current.cardData);
        // อัพเดทข้อมูลสำหรับ step ที่ระบุ
        newCardData[event.stepIndex] = event.data;

        emit(current.copyWith(
          cardData: newCardData,
        ));
      }
    });
    on<ToggleInStockFilterEvent>((event, emit) {
      if (state is ReportLoaded) {
        final current = state as ReportLoaded;
        List<Data> filtered = current.allReports;
        // แก้ไข type comparison error
        filtered = filtered
            .where((item) => current.productSelected.contains(item))
            .toList();
        if (event.showOnlyInStock) {
          filtered = filtered.where((item) => item.totalAmount > 0).toList();
        }
        emit(current.copyWith(
          showOnlyInStock: event.showOnlyInStock,
          filteredReports: filtered,
        ));
      }
    });

    on<ApplyFilterEvent>((event, emit) {
      if (state is ReportLoaded) {
        final current = state as ReportLoaded;
        emit(current.copyWith(selectedIndexes: event.selectedIndexes));
      }
    });

    on<ClearFilterEvent>((event, emit) {
      if (state is ReportLoaded) {
        final current = state as ReportLoaded;
        emit(current.copyWith(selectedIndexes: {}));
      }
    });

    on<ResetFilterToDefaultEvent>((event, emit) {
      if (state is ReportLoaded) {
        final current = state as ReportLoaded;
        emit(current.copyWith(selectedIndexes: {0, 2})); // ตัวอย่าง default
      }
    });

    on<ChangePageEvent>((event, emit) {
      if (state is ReportLoaded) {
        final current = state as ReportLoaded;
        emit(current.copyWith(currentPage: event.page));
      }
    });

    on<ChangeItemsPerPageEvent>((event, emit) {
      if (state is ReportLoaded) {
        final current = state as ReportLoaded;
        emit(
            current.copyWith(currentPage: 1, itemsPerPage: event.itemsPerPage));
      }
    });


  }
}
