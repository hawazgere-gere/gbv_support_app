/* * 🚨 High-Stakes Standalone SOS Board
 * Designed for immediate, unauthenticated access with haptic-ready UI.
 */
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gbv_support_app/features/sos/presentation/sos_provider.dart';
// Ensure these point to your actual provider and service paths
import '../services/sos_provider.dart';

class StandaloneSOSPage extends ConsumerStatefulWidget {
  const StandaloneSOSPage({super.key});

  @override
  ConsumerState<StandaloneSOSPage> createState() => _StandaloneSOSPageState();
}

class _StandaloneSOSPageState extends ConsumerState<StandaloneSOSPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _triggerAlert() async {
    // Calling the provider logic you defined earlier
    final success = await ref.read(sosProvider.notifier).sendSOS();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? "Emergency Alert Dispatched!" : "Dispatch Failed.",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: success ? Colors.green : Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSending = ref.watch(sosProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F), // Deep Obsidian
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white60),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // Background Pulsing Glow
          Center(
            child: ScaleTransition(
              scale: Tween(begin: 1.0, end: 1.3).animate(
                CurvedAnimation(
                    parent: _pulseController, curve: Curves.easeInOut),
              ),
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red.withOpacity(0.08),
                ),
              ),
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.gpp_maybe_rounded,
                  color: Colors.redAccent, size: 48),
              const SizedBox(height: 16),
              const Text(
                "EMERGENCY BROADCAST",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 60),

              // THE MAIN SOS TRIGGER
              Center(
                child: GestureDetector(
                  onLongPress: isSending ? null : _triggerAlert,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Loading Ring
                      if (isSending)
                        const SizedBox(
                          width: 240,
                          height: 240,
                          child: CircularProgressIndicator(
                            color: Colors.redAccent,
                            strokeWidth: 10,
                          ),
                        ),

                      // The Visual Button
                      Material(
                        elevation: 25,
                        shape: const CircleBorder(),
                        color: Colors.transparent,
                        child: Container(
                          width: 210,
                          height: 210,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.red.shade500,
                                Colors.red.shade900,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withOpacity(0.5),
                                blurRadius: 30,
                                spreadRadius: 5,
                              )
                            ],
                          ),
                          child: Center(
                            child: isSending
                                ? const Text(
                                    "SENDING...",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  )
                                : const Icon(
                                    Icons.emergency_share_rounded,
                                    size: 85,
                                    color: Colors.white,
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 70),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: Text(
                  "HOLD DOWN TO SEND SOS\nEmergency services and contacts will receive your live location.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white54,
                    height: 1.6,
                    fontSize: 14,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
