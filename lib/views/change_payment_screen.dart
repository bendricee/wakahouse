import 'package:flutter/material.dart';

class ChangePaymentScreen extends StatefulWidget {
  const ChangePaymentScreen({super.key});

  @override
  State<ChangePaymentScreen> createState() => _ChangePaymentScreenState();
}

class _ChangePaymentScreenState extends State<ChangePaymentScreen> {
  int selectedPaymentIndex = 0;

  final List<Map<String, dynamic>> paymentMethods = [
    {
      'id': 0,
      'type': 'mobile_money',
      'cardNumber': '•••••••• 1222',
      'balance': 15625000, // 15,625,000 FCFA (equivalent to ~$31,250)
      'color': Color(0xFFFFCC00), // MTN Yellow
      'icon': Icons.phone_android,
      'provider': 'MTN MoMo',
    },
    {
      'id': 1,
      'type': 'mobile_money',
      'cardNumber': '•••••••• 1542',
      'balance': 27100000, // 27,100,000 FCFA (equivalent to ~$54,200)
      'color': Color(0xFFFF6600), // Orange Color
      'icon': Icons.phone_android,
      'provider': 'Orange Money',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                const Text(
                  'Change Payment',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),

                const SizedBox(height: 32),

                // Payment Cards
                ...paymentMethods.asMap().entries.map((entry) {
                  int index = entry.key;
                  Map<String, dynamic> method = entry.value;
                  return _buildPaymentCard(method, index);
                }),

                const SizedBox(height: 32),

                // Select Payment Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      _selectPayment();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7CB342),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Select Payment',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(Map<String, dynamic> method, int index) {
    bool isSelected = selectedPaymentIndex == index;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedPaymentIndex = index;
          });
        },
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            color: method['color'],
            borderRadius: BorderRadius.circular(16),
            border: isSelected
                ? Border.all(color: Colors.white, width: 3)
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Selection indicator
              if (isSelected)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Color(0xFF7CB342),
                      size: 16,
                    ),
                  ),
                ),

              // Card content
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Card number
                    Text(
                      method['cardNumber'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Balance and card type
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Balance',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              '${_formatBalance(method['balance'])} FCFA',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                        // Mobile Money provider icon
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            method['provider'] == 'MTN MoMo' ? 'MTN' : 'OM',
                            style: const TextStyle(
                              color: Color(0xFF2D3748),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatBalance(int balance) {
    if (balance >= 1000000) {
      double balanceInM = balance / 1000000;
      return '${balanceInM.toStringAsFixed(balanceInM.truncateToDouble() == balanceInM ? 0 : 1)}M';
    } else if (balance >= 1000) {
      double balanceInK = balance / 1000;
      return '${balanceInK.toStringAsFixed(balanceInK.truncateToDouble() == balanceInK ? 0 : 1)}K';
    }
    return balance.toString();
  }

  void _selectPayment() {
    final selectedMethod = paymentMethods[selectedPaymentIndex];

    // Close modal and return selected payment method
    Navigator.pop(context, selectedMethod);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Payment method ${selectedMethod['cardNumber']} selected',
        ),
        backgroundColor: const Color(0xFF7CB342),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
