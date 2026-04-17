import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/auth_provider.dart';
import '../utils/app_theme.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _form = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phCtrl = TextEditingController();
  final _emCtrl = TextEditingController();
  final _pwCtrl = TextEditingController();
  final _cpCtrl = TextEditingController();

  String? _error;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phCtrl.dispose();
    _emCtrl.dispose();
    _pwCtrl.dispose();
    _cpCtrl.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _error = null);

    final auth = context.read<AuthProvider>();
    final err = await auth.signUp(
      email: _emCtrl.text.trim(),
      password: _pwCtrl.text.trim(),
      name: _nameCtrl.text.trim(),
      phone: _phCtrl.text.trim(),
    );

    if (mounted) {
      if (err != null) {
        setState(() => _error = err);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Account Created Successfully")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Form(
            key: _form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Center(
                          child: Text('🍕', style: TextStyle(fontSize: 38))),
                    ),
                    const SizedBox(height: 14),
                    const Text('Create Account',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.primary)),
                    const SizedBox(height: 4),
                    const Text('Join the Pizza Lovers 39 family!',
                        style: TextStyle(color: AppTheme.textGrey)),
                  ]),
                ),
                const SizedBox(height: 28),
                if (_error != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 13)),
                  ),
                  const SizedBox(height: 16)
                ],
                const Text("Full Name", style: TextStyle(fontWeight: FontWeight.bold)),
                TextFormField(
                  controller: _nameCtrl,
                  decoration: InputDecoration(
                    hintText: "Enter your full name",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (v) => v == null || v.isEmpty ? "Required" : null,
                ),
                const SizedBox(height: 14),
                const Text("Phone", style: TextStyle(fontWeight: FontWeight.bold)),
                TextFormField(
                  controller: _phCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: "10-digit mobile number",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (v) => v == null || v.length != 10 ? "Invalid phone" : null,
                ),
                const SizedBox(height: 14),
                const Text("Email", style: TextStyle(fontWeight: FontWeight.bold)),
                TextFormField(
                  controller: _emCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "Enter your email",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (v) => v == null || !v.contains('@') ? "Invalid email" : null,
                ),
                const SizedBox(height: 14),
                const Text("Password", style: TextStyle(fontWeight: FontWeight.bold)),
                TextFormField(
                  controller: _pwCtrl,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Enter password",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (v) => v == null || v.length < 6 ? "Min 6 chars" : null,
                ),
                const SizedBox(height: 14),
                const Text("Confirm Password", style: TextStyle(fontWeight: FontWeight.bold)),
                TextFormField(
                  controller: _cpCtrl,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Re-enter password",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (v) => v != _pwCtrl.text ? "Passwords do not match" : null,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _signUp,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: isLoading
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Text("Create Account", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      ),
                      child: const Text("Login",
                          style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
