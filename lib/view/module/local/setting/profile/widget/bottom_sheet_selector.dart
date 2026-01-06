import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/color_string.dart';

Future<void> showSelectionBottomSheet({
  required BuildContext context,
  required String title,
  required List<String> options,
  required ValueChanged<String> onSelected,
}) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: GBColor.secondary,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) {
      return SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              ...options.map(
                (item) => InkWell(
                  borderRadius: BorderRadius.circular(8),
                  splashColor: GBColor.primary.withValues(alpha: 0.2),
                  highlightColor: GBColor.primary.withValues(alpha: 0.1),
                  onTap: () {
                    Navigator.pop(context);
                    onSelected(item);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 8,
                    ),
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: GBColor.lineColor, width: 0.8),
                      ),
                    ),
                    child: Text(
                      item,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
