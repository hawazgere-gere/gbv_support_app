/* Top Comment: Implementation of a "Panic Exit" to ensure user safety 
   and clear navigation history.
*/
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/auth_provider.dart';

class QuickExitFAB extends ConsumerWidget {
  const QuickExitFAB({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      heroTag: 'quick_exit', // Unique tag to prevent hero animation errors
      tooltip: 'Quick Exit',
      backgroundColor: Colors.grey.shade800,
      onPressed: () {
        // 1. Logic: Logout the user to clear the session state
        ref.read(authProvider.notifier).logout();

        // 2. Navigation: Clear the entire stack and return to Welcome
        // This prevents the "Back" button from returning to the SOS/Secret screen.
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/welcome', (route) => false);

        // Feedback for your video script:
        // "This button instantly clears the app state and redirects to a neutral
        // entry point, adhering to Accessibility First and Safety design."
      },
      child: const Icon(Icons.close, color: Colors.white),
    );
  }
}
