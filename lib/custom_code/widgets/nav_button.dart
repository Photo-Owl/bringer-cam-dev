// Automatic FlutterFlow imports
import 'dart:ui';

import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:async';

class NavButton extends StatefulWidget {
  final double? width;
  final double? height;
  final FutureOr<void> Function() onPressed;
  final IconData icon;
  final String label;
  final bool isSelected;
  const NavButton({
    super.key,
    this.width,
    this.height,
    required this.isSelected,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  State<NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<NavButton> {
  @override
  Widget build(BuildContext context) {
    final textColor = widget.isSelected
        ? const Color(0xFF1589FC)
        : FlutterFlowTheme.of(context).primaryText;
    return InkWell(
      onTap: widget.onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: widget.isSelected ? const Color(0xFFE0EFFF) : Colors.white,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(widget.icon, color: textColor),
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(
                widget.label,
                style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                      color: textColor,
                      fontWeight:
                          widget.isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
