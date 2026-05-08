import 'package:flutter/material.dart';

class DiscreetButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const DiscreetButton({
    super.key,
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    // Appears as a normal button, not alarming
    return TextButton(
      onPressed: onPressed,
      child: Text(label, style: const TextStyle(color: Colors.brown)),
    );
  }
}
