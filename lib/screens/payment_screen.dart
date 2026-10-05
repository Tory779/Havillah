import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentScreen extends StatefulWidget {
 final int orderTotal;

  const PaymentScreen({super.key, required this.orderTotal});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedPaymentMethod = 'card';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF201358),
              Color(0xFF4529BE),
            ],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    _buildTopBar(context),
                    const SizedBox(height: 24),
                    _buildHeader(),
                    const SizedBox(height: 20),
                    _buildPaymentMethodSelector(),
                    const SizedBox(height: 20),
                    _buildCardDetailsForm(),
const SizedBox(height: 20),
_buildPayNowButton(),
const SizedBox(height: 12),
_buildSecurityFooter(),
const SizedBox(height: 20),
                   
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        Column(
          children: [
            RichText(
              text: TextSpan(
                style: GoogleFonts.holtwoodOneSc(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 2),
                children: [
                  TextSpan(text: 'H', style: GoogleFonts.holtwoodOneSc(color: Color(0xFFCC0505))),
                  TextSpan(text: 'A', style: GoogleFonts.holtwoodOneSc(color: Color(0xFF050FCC))),
                  TextSpan(text: 'V', style: GoogleFonts.holtwoodOneSc(color: Colors.white)),
                  TextSpan(text: 'I', style: GoogleFonts.holtwoodOneSc(color: Color(0xFF008223))),
                  TextSpan(text: 'L', style: GoogleFonts.holtwoodOneSc(color: Color(0xFFB30593))),
                  TextSpan(text: 'A', style: GoogleFonts.holtwoodOneSc(color: Color(0xFFF56111))),
                  TextSpan(text: 'H', style: GoogleFonts.holtwoodOneSc(color: Color(0xFFCC0505))),
                ],
              ),
            ),
            Text('ice cream', style: GoogleFonts.dancingScript(color: Colors.white70, fontSize: 20)),
          ],
        ),
        const SizedBox(width: 48),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Text('Payment', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(width: 8),
            Icon(Icons.credit_card, color: Colors.lightBlueAccent, size: 22),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          'Choose your preferred payment method and complete your payment.',
          style: TextStyle(color: Colors.white70, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildPaymentOption(
            value: 'card',
            label: 'Card payment',
            trailing: const Icon(Icons.credit_card, color: Colors.black54, size: 20),
          ),
          const Divider(height: 1, color: Colors.black12),
          _buildPaymentOption(
            value: 'bank',
            label: 'Bank transfer',
            trailing: const Icon(Icons.account_balance, color: Colors.black54, size: 20),
          ),
          const Divider(height: 1, color: Colors.black12),
          _buildPaymentOption(
            value: 'cash',
            label: 'Cash on delivery',
            trailing: const Icon(Icons.local_shipping_outlined, color: Colors.black54, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required String value,
    required String label,
    required Widget trailing,
  }) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: selectedPaymentMethod,
          activeColor: Colors.pinkAccent,
          onChanged: (newValue) {
            setState(() {
              selectedPaymentMethod = newValue!;
            });
          },
        ),
        Expanded(
          child: Text(label, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14)),
        ),
        trailing,
        const SizedBox(width: 4),
      ],
    );
  }
  Widget _buildCardDetailsForm() {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Text('Card details', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
            SizedBox(width: 8),
            Icon(Icons.credit_card, color: Colors.lightBlueAccent, size: 18),
          ],
        ),
        const SizedBox(height: 16),
        _buildFormField(hint: 'Card number', keyboardType: TextInputType.number),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildFormField(hint: 'Expiry date', keyboardType: TextInputType.datetime)),
            const SizedBox(width: 12),
            Expanded(child: _buildFormField(hint: 'CVV', keyboardType: TextInputType.number, obscureText: true)),
          ],
        ),
        const SizedBox(height: 12),
        _buildFormField(hint: 'Name'),
      ],
    ),
  );
}

Widget _buildFormField({
  required String hint,
  TextInputType keyboardType = TextInputType.text,
  bool obscureText = false,
}) {
  return TextField(
    keyboardType: keyboardType,
    obscureText: obscureText,
    style: const TextStyle(color: Colors.black),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.black45),
      filled: true,
      fillColor: Colors.grey[300],
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
  );
}
Widget _buildPayNowButton() {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () {
        // something sha
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: Text(
        'Pay Now  ₦${widget.orderTotal}',
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
      ),
    ),
  );
}

Widget _buildSecurityFooter() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Icon(Icons.verified_user_outlined, color: Colors.black, size: 28),
      const SizedBox(width: 6),
      Flexible(
        child: Text(
          'Your payment is secure and encrypted by 256 SSL bit technology',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.black, fontSize: 13),
        ),
      ),
    ],
  );
}
}