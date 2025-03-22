import 'package:flutter/material.dart';

class OwnerDetails extends StatelessWidget {
  final String name;
  final String email;
  final String phone;

  const OwnerDetails({
    required this.name,
    required this.email,
    required this.phone,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.email, size: 16, color: Colors.grey),
            const SizedBox(width: 8),
            Text(email, style: const TextStyle(color: Colors.grey)),
            const Spacer(),
            const Icon(Icons.phone, size: 16, color: Colors.grey),
            const SizedBox(width: 8),
            Text(phone, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ],
    );
  }
}