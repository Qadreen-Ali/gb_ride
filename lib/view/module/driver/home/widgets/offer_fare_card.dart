import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import 'package:gb_ride/utils/constants/image_string.dart';
import 'package:gb_ride/utils/constants/primary_button.dart';
import 'package:gb_ride/view/module/driver/bottom_sheet/offer_fare_screen.dart';
import 'package:gb_ride/models/ride_model.dart';

class OfferFareCard extends StatefulWidget {
  final RideModel rideModel;
  final VoidCallback? onOfferTap;
  final VoidCallback? onOfferClose;

  const OfferFareCard({
    super.key,
    required this.rideModel,
    this.onOfferTap,
    this.onOfferClose,
  });

  @override
  State<OfferFareCard> createState() => _OfferFareCardState();
}

class _OfferFareCardState extends State<OfferFareCard> {
  @override
  Widget build(BuildContext context) {
    final ride = widget.rideModel;

    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.orange, width: 1.2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// LEFT SIDE
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// DRIVER INFO
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundImage: AssetImage(
                        ride.driverImagePath,
                      ),
                    ),
                    const SizedBox(width: 10),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              ride.driverName,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'Verified',
                                style: TextStyle(
                                  fontSize: 6,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          '(34 rides)',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                /// ROUTE INFO
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// DOTS
                    Column(
                      children: [
                        const Icon(
                          Icons.radio_button_checked,
                          color: Colors.green,
                          size: 14,
                        ),
                        Container(
                          height: 20,
                          margin: const EdgeInsets.only(top: 2),
                          child: CustomPaint(painter: _DottedLinePainter()),
                        ),
                        const Icon(
                          Icons.radio_button_checked,
                          color: Colors.orange,
                          size: 14,
                        ),
                      ],
                    ),

                    const SizedBox(width: 8),

                    /// LOCATIONS
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  ride.pickupLocation,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              _timeChip('${ride.etaMinutes} min'),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  ride.destinationLocation,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              _timeChip('${ride.etaMinutes * 2} min'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// RIGHT SIDE
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  const Text(
                    'offer fare',
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    ride.formattedFare,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.timer, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    '${ride.etaMinutes} min total',
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              PrimaryButton(
                onPressed: () async {
                  widget.onOfferTap?.call();

                  await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => OfferFareScreen(
                      rideModel: ride,
                    ),
                  );

                  if (mounted) {
                    widget.onOfferClose?.call();
                  }
                },
                title: 'Offer Fare',
                width: 120,
                height: 44,
                fontsize: 14,
                weight: FontWeight.w600,
                borderRadius: BorderRadius.circular(24),
                backgroundColor: GBColor.primary,
                textColor: GBColor.secondary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _timeChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(text, style: const TextStyle(fontSize: 10)),
    );
  }
}

class _DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = GBColor.lightBlue
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    double startY = 0;
    const dashHeight = 4;
    const dashSpace = 4;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
