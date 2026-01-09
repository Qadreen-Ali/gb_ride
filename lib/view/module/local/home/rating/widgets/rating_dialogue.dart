import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import 'package:gb_ride/view/module/local/home/rating/driver_rating_screen.dart';


class RatingDialogue extends StatelessWidget {
  final IconData icon;

  const RatingDialogue({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Icon(icon, size: 14, color: GBColor.yellow);
  }
}

// Rating Dialog Widget - Shows after ride ends
class EndRideRatingDialog extends StatefulWidget {
  final String driverName;
  final String driverImage;

  const EndRideRatingDialog({
    super.key,
    required this.driverName,
    required this.driverImage,
  });

  @override
  State<EndRideRatingDialog> createState() => _EndRideRatingDialogState();
}

class _EndRideRatingDialogState extends State<EndRideRatingDialog> {
  int _rating = 0;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Driver Avatar
            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage(widget.driverImage),
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              'Rate ${widget.driverName}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Subtitle
            const Text(
              'How was your ride experience?',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Star Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                      size: 40,
                      color: index < _rating ? Colors.amber : Colors.grey,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                // Skip Button
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Rate Driver Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DriverRatingScreen(
                            driverName: widget.driverName,
                            driverImage: widget.driverImage,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: GBColor.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Rate Driver',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Helper function to show the rating dialog
void showEndRideRatingDialog(
  BuildContext context, {
  required String driverName,
  required String driverImage,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return EndRideRatingDialog(
        driverName: driverName,
        driverImage: driverImage,
      );
    },
  );
}
