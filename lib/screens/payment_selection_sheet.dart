import 'package:flutter/material.dart';

class PaymentSelectionSheet extends StatefulWidget {
  final int orderTotal;
  final String? initialDefaultMethod;
  final Function(String method, bool saveAsDefault) onPaymentConfirmed;

  const PaymentSelectionSheet({
    super.key,
    required this.orderTotal,
    this.initialDefaultMethod,
    required this.onPaymentConfirmed,
  });

  @override
  State<PaymentSelectionSheet> createState() => _PaymentSelectionSheetState();
}

class _PaymentSelectionSheetState extends State<PaymentSelectionSheet> {
  late String selectedMethod;
  bool saveAsDefault = false;

  @override
  void initState() {
    super.initState();
    selectedMethod = widget.initialDefaultMethod ?? 'card';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        top: 20,
        left: 20,
        right: 20,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFB0A4D9), // Light purple container background
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildOptionTile(
              value: 'card',
              title: 'Card payment',
              subtitle: 'Visa, Mastercard, Verve',
              trailingIcon: Icons.credit_card,
            ),
            const SizedBox(height: 12),
            _buildOptionTile(
              value: 'bank',
              title: 'Bank transfer',
              subtitle: 'Pay directly from your bank',
              trailingIcon: Icons.account_balance,
            ),
            const SizedBox(height: 12),
            _buildOptionTile(
              value: 'cash',
              title: 'Cash on delivery',
              subtitle: 'Pay when your order arrives',
              trailingIcon: Icons.payments_outlined,
            ),
            const SizedBox(height: 16),

            // Checkbox for setting default payment method
            Row(
              children: [
                Checkbox(
                  value: saveAsDefault,
                  activeColor: Colors.deepPurple,
                  onChanged: (val) => setState(() => saveAsDefault = val ?? false),
                ),
                const Text(
                  'Set as default payment method',
                  style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Card form visible only when Card payment is selected
            if (selectedMethod == 'card') ...[
              _buildCardForm(),
              const SizedBox(height: 16),
            ],

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.onPaymentConfirmed(selectedMethod, saveAsDefault);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: Text(
                  selectedMethod == 'cash'
                      ? 'Place Order (Cash on Pickup)'
                      : 'Pay Now . ₦${widget.orderTotal}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required String value,
    required String title,
    required String subtitle,
    required IconData trailingIcon,
  }) {
    return InkWell(
      onTap: () => setState(() => selectedMethod = value),
      child: Row(
        children: [
          Radio<String>(
            value: value,
            groupValue: selectedMethod,
            activeColor: Colors.pinkAccent,
            onChanged: (val) {
              if (val != null) setState(() => selectedMethod = val);
            },
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15)),
                Text(subtitle, style: const TextStyle(color: Colors.black54, fontSize: 12)),
              ],
            ),
          ),
          Icon(trailingIcon, color: Color(0xFF808080), size: 28),
        ],
      ),
    );
  }

  Widget _buildCardForm() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildPillField(hint: 'Card number', keyboardType: TextInputType.number),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildPillField(hint: 'Expiry date', keyboardType: TextInputType.datetime)),
              const SizedBox(width: 8),
              Expanded(child: _buildPillField(hint: 'CVV', keyboardType: TextInputType.number, obscureText: true)),
            ],
          ),
          const SizedBox(height: 8),
          _buildPillField(hint: 'Name'),
        ],
      ),
    );
  }

  Widget _buildPillField({
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return TextField(
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white60, fontSize: 13),
        filled: true,
        fillColor: const Color(0xFF5B4D8A),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}