import 'package:flutter/material.dart';

class PetInfoChip extends StatelessWidget {
  final String label;
  final String value;

  const PetInfoChip({
    required this.label,
    required this.value,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text('$label: $value'),
    );
  }
}