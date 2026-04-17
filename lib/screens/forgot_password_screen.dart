import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/auth_provider.dart';
import '../utils/app_theme.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotState();
}

class _ForgotState extends State<ForgotPasswordScreen> {
  final _emailCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _error;
  bool _sent = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendReset() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final auth = context.read<AuthProvider>();
    // ✅ CONNECTED TO FIREBASE via AuthProvider
    final err = await auth.sendPasswordResetEmail(_emailCtrl.text.trim());

    if (mounted) {
      if (err != null) {
        setState(() {
          _error = err;
          _isLoading = false;
        });
      } else {
        setState(() {
          _sent = true;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        title: const Text('Reset Password'),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: _sent ? _successView() : _formView(),
        ),
      ),
    );
  }

  Widget _formView() => Form(
    key: _formKey,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Icon(Icons.lock_reset_rounded, size: 100, color: AppTheme.primary),
        ),
        const SizedBox(height: 24),
        const Text('Forgot Password?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppTheme.textDark)),
        const SizedBox(height: 10),
        const Text(
            'Enter your registered email address below. Firebase will send you a secure link to reset your password.',
            style: TextStyle(color: AppTheme.textGrey, fontSize: 14, height: 1.5)),
        const SizedBox(height: 30),

        if (_error != null) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Row(children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 20),
              const SizedBox(width: 10),
              Expanded(child: Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 13))),
            ]),
          ),
          const SizedBox(height: 20),
        ],

        const Text('Email Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 8),
        TextFormField(
          controller: _emailCtrl,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: "example@gmail.com",
            prefixIcon: const Icon(Icons.email_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: (v) {
            if (v == null || v.isEmpty) return "Email is required";
            if (!v.contains('@') || !v.contains('.')) return "Enter a valid email address";
            return null;
          },
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _sendReset,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: _isLoading
                ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                : const Text('Send Reset Link', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    ),
  );

  Widget _successView() => Column(
    children: [
      const SizedBox(height: 40),
      const Center(
        child: Icon(Icons.mark_email_read_rounded, size: 100, color: Colors.green),
      ),
      const SizedBox(height: 30),
      const Text('Reset Email Sent!',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: AppTheme.textDark)),
      const SizedBox(height: 12),
      RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: const TextStyle(color: AppTheme.textGrey, fontSize: 15, height: 1.6),
          children: [
            const TextSpan(text: 'A password reset link has been sent to:\n'),
            TextSpan(text: _emailCtrl.text, style: const TextStyle(color: AppTheme.textDark, fontWeight: FontWeight.bold)),
            const TextSpan(text: '\n\nPlease check your inbox. If you don\'t see it, check your '),
            const TextSpan(text: 'Spam', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
            const TextSpan(text: ' folder.'),
          ],
        ),
      ),
      const SizedBox(height: 40),
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          child: const Text('Back to Login', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        ),
      ),
      const SizedBox(height: 20),
      TextButton(
        onPressed: () => setState(() => _sent = false),
        child: const Text('Didn\'t receive email? Try again', style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold)),
      ),
    ],
  );
}
