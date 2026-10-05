import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'user_profile.dart';

class EditProfileScreen extends StatefulWidget {
  final UserProfile profile;

  const EditProfileScreen({super.key, required this.profile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _usernameController;
  late TextEditingController _addressController;

  String? _selectedDefaultPayment;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.profile.email);
    _passwordController = TextEditingController();
    _usernameController = TextEditingController(text: widget.profile.username);
    _addressController = TextEditingController(text: widget.profile.address);
    _selectedImage = widget.profile.profileImage;
    _selectedDefaultPayment = widget.profile.defaultPaymentMethod;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _showImagePickerOptions() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF201358),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext ctx) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.white),
                title: const Text('Take a photo', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.white),
                title: const Text('Choose from gallery', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting image: $e')),
      );
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter an email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      final updatedProfile = UserProfile(
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        address: _addressController.text.trim(),
        profileImage: _selectedImage,
        defaultPaymentMethod: _selectedDefaultPayment,
      );

      Navigator.pop(context, updatedProfile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/fonts/ice_cream_bg.jpe',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: const Color(0xFF2A1653).withOpacity(0.72),
            ),
          ),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        _buildTopHeader(),
                        const SizedBox(height: 25),
                        Center(child: _buildAvatarSection()),
                        const SizedBox(height: 35),
                        _buildPillInputField(
                          controller: _emailController,
                          hintText: 'Edit email',
                          validator: _validateEmail,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 18),
                        _buildPillInputField(
                          controller: _passwordController,
                          hintText: 'Edit password',
                          isObscure: true,
                        ),
                        const SizedBox(height: 18),
                        _buildPillInputField(
                          controller: _usernameController,
                          hintText: 'Edit username',
                        ),
                        const SizedBox(height: 18),
                        _buildPillInputField(
                          controller: _addressController,
                          hintText: 'Edit address',
                        ),
                        const SizedBox(height: 18),
                        _buildDefaultPaymentDropdown(),
                        const SizedBox(height: 30),
                        _buildSaveButton(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
          onPressed: () => Navigator.pop(context),
          padding: const EdgeInsets.all(8),
          constraints: const BoxConstraints(),
        ),
        IconButton(
          icon: const Icon(Icons.settings_outlined, color: Colors.white, size: 26),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildAvatarSection() {
    return GestureDetector(
      onTap: _showImagePickerOptions,
      child: CircleAvatar(
        radius: 60,
        backgroundColor: const Color(0xFFD9D9D9),
        backgroundImage: _selectedImage != null ? FileImage(_selectedImage!) : null,
        child: _selectedImage == null
            ? const Icon(Icons.person, size: 70, color: Colors.white)
            : null,
      ),
    );
  }

  Widget _buildPillInputField({
    required TextEditingController controller,
    required String hintText,
    String? Function(String?)? validator,
    bool isObscure = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white54, fontSize: 15),
        suffixIcon: const Icon(Icons.edit, color: Colors.white70, size: 20),
        filled: true,
        fillColor: const Color(0xFF130932).withOpacity(0.85),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        errorStyle: const TextStyle(color: Colors.pinkAccent),
      ),
    );
  }

  Widget _buildDefaultPaymentDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF130932).withOpacity(0.85),
        borderRadius: BorderRadius.circular(30),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedDefaultPayment,
          hint: const Text('Default payment method', style: TextStyle(color: Colors.white54, fontSize: 15)),
          dropdownColor: const Color(0xFF140A3C),
          icon: const Icon(Icons.edit, color: Colors.white70, size: 20),
          isExpanded: true,
          style: const TextStyle(color: Colors.white, fontSize: 15),
          items: const [
            DropdownMenuItem(value: 'card', child: Text('Card payment')),
            DropdownMenuItem(value: 'cash', child: Text('Cash on delivery')),
            DropdownMenuItem(value: 'bank', child: Text('Bank transfer')),
          ],
          onChanged: (value) {
            setState(() {
              _selectedDefaultPayment = value;
            });
          },
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF130932).withOpacity(0.85),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.lightBlueAccent, width: 1.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: _saveChanges,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
            child: Text(
              'Save changes',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}