import 'package:ecom/Widgets/merchant/merchant_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class MerchantDashboard extends StatefulWidget {
  const MerchantDashboard({super.key});

  @override
  State<MerchantDashboard> createState() => _MerchantDashboardState();
}

class _MerchantDashboardState extends State<MerchantDashboard> {
  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Merchant Dashboard')),
      drawer: const MerchantDrawer(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Row(
              children: [
                Text("Overview", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 200),

                Text(DateFormat.yMMMd().format(now)),
              ],
            ),

            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
