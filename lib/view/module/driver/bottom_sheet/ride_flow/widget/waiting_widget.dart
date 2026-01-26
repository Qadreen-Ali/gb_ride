import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/color_string.dart';

class WaitingWidget extends StatefulWidget {
  final Duration waitingTime;
  final int estimatedFare;

  const WaitingWidget({
    super.key,
    required this.waitingTime,
    required this.estimatedFare,
  });

  @override
  State<WaitingWidget> createState() => _WaitingWidgetState();
}

class _WaitingWidgetState extends State<WaitingWidget> {
  /// Format duration to mm:ss
  String _formatTime(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// Waiting Time
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 18,
                    color: GBColor.primary,
                  ),
                  const SizedBox(width: 6),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Waiting Time',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        _formatTime(widget.waitingTime),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: GBColor.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              /// Estimated Fare
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Estimated Fare',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    '${widget.estimatedFare} PKR',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: GBColor.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        Divider(height: 1, thickness: 1, color: Colors.grey.shade300),
      ],
    );
  }
}
