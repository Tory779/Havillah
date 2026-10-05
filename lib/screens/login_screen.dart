import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFF2502C6), // Exact background color from Figma design
        child: Stack(
          children: [
            // Top Pinkish Wave Path: Color #A84E9A with 100% opacity
            Positioned(
              top: -63,
              left: 1,
              child: CustomPaint(
                size: const Size(395.5, 299.89),
                painter: _TopWavePainter(
                  color: const Color(0xFFA84E9A).withOpacity(1.0),
                ),
              ),
            ),

            // Middle Darker Wave Path: Color #A84E9A with 50% opacity layered over blue
            Positioned(
              top: -6.5,
              left: 3,
              child: CustomPaint(
                size: const Size(395.5, 299.89),
                painter: _TopWavePainter(
                  color: const Color(0xFFA84E9A).withOpacity(0.5),
                ),
              ),
            ),

            // Bottom Right Wave Path: Opacity 15%
            Positioned(
              top: 459.5,
              left: -44,
              child: CustomPaint(
                size: const Size(519, 306),
                painter: _BottomWavePainter(
                  color: Colors.white.withOpacity(0.15),
                ),
              ),
            ),

            // Main Content Area
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  children: [
                    const SizedBox(height: 280),

                    // Email Input Field
                    _buildTextField(
                      controller: _emailController,
                      label: 'Email',
                      icon: Icons.person,
                      obscureText: false,
                    ),
                    const SizedBox(height: 32),

                    // Password Input Field
                    _buildTextField(
                      controller: _passwordController,
                      label: 'Password',
                      icon: _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      obscureText: _obscurePassword,
                      onIconTap: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    const SizedBox(height: 98),

                    // Login Action Button (Dimensions: 181x44, Border Radius: 20)
                    _buildLoginButton(context),
                    const SizedBox(height: 66),

                    // Divider Text
                    const Text(
                      'Or continue with',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Social Login Buttons (Dimensions: 125x39, Opacity: 50%)
                    _buildSocialButtons(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool obscureText,
    VoidCallback? onIconTap,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        suffixIcon: IconButton(
          icon: Icon(icon, color: Colors.white, size: 22),
          onPressed: onIconTap,
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white70, width: 1.5),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2.5),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return Container(
      width: 181,
      height: 44,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF88BCFF), width: 1.0),
        gradient: const LinearGradient(
          colors: [Color(0xFF2D0CC0), Color(0xFF15065A)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: ElevatedButton(
        onPressed: () => context.go('/loading'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text(
          'Login',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialPill(
          label: 'Google',
          iconWidget: _buildGoogleLogo(),
        ),
        const SizedBox(width: 16),
        _buildSocialPill(
          label: 'Facebook',
          iconWidget: Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              color: Color(0xFF1877F2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.facebook, color: Colors.white, size: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialPill({
    required String label,
    required Widget iconWidget,
  }) {
    return Container(
      width: 125,
      height: 39,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          iconWidget,
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoogleLogo() {
    return Container(
      width: 20,
      height: 20,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: const Text(
        'G',
        style: TextStyle(
          color: Color(0xFF4285F4),
          fontWeight: FontWeight.w900,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _TopWavePainter extends CustomPainter {
  final Color color;

  _TopWavePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height * 0.70);
    path.quadraticBezierTo(
      size.width * 0.35,
      size.height * 0.95,
      size.width * 0.65,
      size.height * 0.55,
    );
    path.quadraticBezierTo(
      size.width * 0.85,
      size.height * 0.25,
      size.width,
      size.height * 0.15,
    );
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BottomWavePainter extends CustomPainter {
  final Color color;

  _BottomWavePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.20);
    path.quadraticBezierTo(
      size.width * 0.40,
      size.height * 0.80,
      size.width,
      size.height,
    );
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}