/* 
 * Top Comment: High-stakes SOS interface featuring a haptic-feedback 
 * trigger and real-time dispatch status visualization.
 */
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'sos_provider.dart';

class SosScreen extends ConsumerStatefulWidget {
  const SosScreen({super.key});

  @override
  ConsumerState<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends ConsumerState<SosScreen>
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
    final success = await ref.read(sosProvider.notifier).sendSOS();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(success ? "SOS Alert Dispatched!" : "Failed to send alert."),
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
      backgroundColor: const Color(0xFF0F0F0F), // Deep obsidian
      body: Stack(
        children: [
          // Background Glow
          Center(
            child: ScaleTransition(
              scale: Tween(begin: 1.0, end: 1.2).animate(_pulseController),
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red.withOpacity(0.05),
                ),
              ),
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.warning_amber_rounded,
                  color: Colors.redAccent, size: 40),
              const SizedBox(height: 10),
              const Text(
                "EMERGENCY BROADCAST",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2),
              ),
              const SizedBox(height: 60),

              // The Main SOS Trigger
              Center(
                child: GestureDetector(
                  onLongPress: isSending ? null : _triggerAlert,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Loading Ring
                      if (isSending)
                        const SizedBox(
                          width: 220,
                          height: 220,
                          child: CircularProgressIndicator(
                            color: Colors.redAccent,
                            strokeWidth: 8,
                          ),
                        ),

                      // The Button
                      Material(
                        elevation: 20,
                        shape: const CircleBorder(),
                        color: Colors.red.shade900,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.red.shade400,
                                Colors.red.shade900
                              ],
                            ),
                          ),
                          child: Center(
                            child: isSending
                                ? const Text("SENDING...",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold))
                                : const Icon(Icons.emergency_share,
                                    size: 80, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 60),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "HOLD DOWN TO SEND SOS\nYour location will be shared with emergency contacts.",
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(color: Colors.grey, height: 1.5, fontSize: 13),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
