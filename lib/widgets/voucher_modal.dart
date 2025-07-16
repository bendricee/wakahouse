import 'package:flutter/material.dart';
import '../views/add_voucher_screen.dart';

class VoucherModal {
  /// Show the Add Voucher modal bottom sheet
  static Future<String?> show({
    required BuildContext context,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: const AddVoucherScreen(),
      ),
    );
  }

  /// Show voucher modal with custom callback
  static Future<void> showWithCallback({
    required BuildContext context,
    required Function(String voucherCode) onVoucherApplied,
  }) async {
    final String? voucherCode = await show(context: context);
    
    if (voucherCode != null && voucherCode.isNotEmpty) {
      onVoucherApplied(voucherCode);
    }
  }
}
