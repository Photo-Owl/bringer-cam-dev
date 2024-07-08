import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EncryptedBanner extends StatelessWidget {
  const EncryptedBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        const Icon(
          Icons.lock_outlined,
          color: Colors.white,
          size: 15,
        ),
        Text(
          'All your photos are end to end encrypted',
          style: GoogleFonts.getFont(
            'Inter',
            fontSize: 12,
            height: 1.25,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
