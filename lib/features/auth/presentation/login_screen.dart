import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_provider.dart';

/// Provides a secure, modern authentication gateway for the application.
///
/// Implements form validation, async login logic, loading states,
/// and password visibility toggling for a polished user experience.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Input controllers to maintain text state across widget rebuilds
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // UI State
  bool _isLoading = false;
  bool _obscurePassword = true;

  // Brand colors — centralized for easy theming
  static const Color _primaryBrown = Color(0xFF8D6E63);
  static const Color _darkBrown = Color(0xFF5D4037);
  static const Color _lightBrown = Color(0xFFD7CCC8);
  static const Color _bgStart = Color(0xFFFBF9F7);
  static const Color _bgEnd = Color(0xFFF3EBE5);

  @override
  void dispose() {
    // CRITICAL: Prevents memory leaks in long-running sessions
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Coordinates the authentication workflow with the back-end provider.
  Future<void> _handleLogin() async {
    // Validate all form fields before proceeding
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    try {
      final email = _emailController.text.trim();
      final pass = _passwordController.text.trim();

      // Execute secure login via Riverpod StateNotifier
      await ref.read(authProvider.notifier).login(email, pass);

      // Guard: Ensure widget is still mounted after async operation
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/dashboard');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } finally {
      // Always reset loading state if still mounted
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        // Warm gradient background for a calm, safe atmosphere
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [_bgStart, _bgEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 28.0,
                vertical: 32.0,
              ),
              child: ConstrainedBox(
                // Limits max width for tablet/large screen comfort
                constraints: const BoxConstraints(maxWidth: 420),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ── Branding Section ──────────────────────────────
                      _buildBrandingHeader(size),
                      const SizedBox(height: 40),

                      // ── Login Card ────────────────────────────────────
                      Container(
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: _primaryBrown.withOpacity(0.12),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // ── Username Field ───────────────────────────
                            _buildSectionLabel('Username'),
                            const SizedBox(height: 8),
                            TextFormField(
                              // You can keep _emailController as the variable name or rename it to _usernameController
                              controller: _emailController,
                              // Changed to 'name' or 'text' for a generic keyboard without the '@' symbol
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              style: const TextStyle(
                                fontSize: 15,
                                color: _darkBrown,
                              ),
                              decoration: _inputDecoration(
                                label: 'Enter your username',
                                // Changed to a person icon to represent a user account
                                icon: Icons.person_outline_rounded,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter your username';
                                }
                                // Simple length check instead of complex email regex
                                if (value.trim().length < 3) {
                                  return 'Username must be at least 3 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            // ── Password Field ────────────────────────
                            _buildSectionLabel('Password'),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _handleLogin(),
                              style: const TextStyle(
                                fontSize: 15,
                                color: _darkBrown,
                              ),
                              decoration: _inputDecoration(
                                label: 'Enter your password',
                                icon: Icons.lock_outline_rounded,
                              ).copyWith(
                                // Password visibility toggle suffix
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: _primaryBrown,
                                    size: 20,
                                  ),
                                  onPressed: () => setState(
                                    () => _obscurePassword = !_obscurePassword,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),

                            // ── Forgot Password ───────────────────────
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  // TODO: Navigate to password reset screen
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(0, 36),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  'Forgot password?',
                                  style: TextStyle(
                                    color: _primaryBrown,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 28),

                            // ── Login Button ──────────────────────────
                            SizedBox(
                              height: 54,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _handleLogin,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _primaryBrown,
                                  foregroundColor: Colors.white,
                                  disabledBackgroundColor: _lightBrown,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Colors.white,
                                          ),
                                        ),
                                      )
                                    : const Text(
                                        'Log In',
                                        style: TextStyle(
                                          fontSize: 16,
                                          letterSpacing: 0.8,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ── Register Link ──────────────────────────────────
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account? ",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () =>
                                Navigator.pushNamed(context, '/register'),
                            child: const Text(
                              'Create one',
                              style: TextStyle(
                                color: _darkBrown,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the top logo + headline section.
  Widget _buildBrandingHeader(Size size) {
    return Column(
      children: [
        Container(
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            color: _primaryBrown.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.lock_person_rounded,
            size: 38,
            color: _primaryBrown,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Welcome Back',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: _darkBrown,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Sign in to your secure account',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  /// Builds a consistent field label.
  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: _darkBrown,
        letterSpacing: 0.2,
      ),
    );
  }

  /// Returns a consistent, modern [InputDecoration] for all form fields.
  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: label,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
      prefixIcon: Icon(icon, size: 20, color: _primaryBrown),
      filled: true,
      fillColor: const Color(0xFFFAF7F5),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _primaryBrown, width: 1.8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.8),
      ),
    );
  }
}
