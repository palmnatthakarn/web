import 'package:flutter/material.dart';

class CustomTabBar_V2 extends StatelessWidget {
  final TabController tabController;

  const CustomTabBar_V2({required this.tabController});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: tabController,
      labelColor: Colors.blue,
      unselectedLabelColor: Colors.grey[600],
      indicatorColor: Colors.blue,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      unselectedLabelStyle: const TextStyle(fontSize: 14),
      tabs: const [
        Tab(text: 'เอกสาร'),
        Tab(text: 'รายการสินค้า'),
        //Tab(text: 'รวม'),
      ],
    );
  }
}
