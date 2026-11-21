import 'package:flutter/material.dart';
import '../models/baby_profile_model.dart';

/// Reusable Baby Profile Header Pill displaying baby name, age, and sleeping state.
class BabyProfileHeaderPill extends StatelessWidget {
  final BabyProfileModel baby;
  final bool isSleeping;
  final VoidCallback? onTap;

  const BabyProfileHeaderPill({
    super.key,
    required this.baby,
    this.isSleeping = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const cardDark = Color(0xFF182238);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: cardDark,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: Colors.amber.shade200,
              child: const Icon(Icons.face_rounded, size: 18, color: Colors.black87),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${baby.name} (${baby.displayAge})',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down_rounded, color: Colors.white70, size: 18),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSleeping ? Colors.greenAccent : Colors.orangeAccent,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isSleeping ? 'Tidur Aktif' : 'Sedang Bangun',
                      style: TextStyle(
                        color: isSleeping ? Colors.greenAccent : Colors.orangeAccent,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
