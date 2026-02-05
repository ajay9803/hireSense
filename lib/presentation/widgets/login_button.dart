import 'package:flutter/material.dart';

Widget _ssoButton({
  required IconData icon,
  required String text,
  required Color iconColor,
}) {
  return Expanded(
    child: Container(
      height: 44,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE2E8F0)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
        ],
      ),
    ),
  );
}
