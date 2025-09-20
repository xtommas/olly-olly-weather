import 'package:flutter/material.dart';

class TemperatureUnitToggle extends StatelessWidget {
  final bool isCelsius;
  final ValueChanged<bool> onToggle;

  const TemperatureUnitToggle({
    super.key,
    required this.isCelsius,
    required this.onToggle,
  });

  Widget _buildUnitToggle(String label, bool isCelsiusOption) {
    final isSelected = isCelsius == isCelsiusOption;
    return GestureDetector(
      onTap: () => onToggle(isCelsiusOption),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [_buildUnitToggle('°C', true), _buildUnitToggle('°F', false)],
      ),
    );
  }
}
