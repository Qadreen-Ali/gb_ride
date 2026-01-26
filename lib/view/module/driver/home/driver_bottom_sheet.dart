import 'package:flutter/material.dart';
import 'package:gb_ride/view/module/driver/home/widgets/offer_fare_card.dart';

class DriverBottomSheet extends StatefulWidget {
  final VoidCallback? onOfferTap;
  final VoidCallback? onOfferClose;

  const DriverBottomSheet({super.key, this.onOfferTap, this.onOfferClose});

  @override
  State<DriverBottomSheet> createState() => _DriverBottomSheetState();
}

class _DriverBottomSheetState extends State<DriverBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                children: [
                  OfferFareCard(
                    onOfferTap: widget.onOfferTap,
                    onOfferClose: widget.onOfferClose,
                  ),
                  OfferFareCard(
                    onOfferTap: widget.onOfferTap,
                    onOfferClose: widget.onOfferClose,
                  ),
                  OfferFareCard(
                    onOfferTap: widget.onOfferTap,
                    onOfferClose: widget.onOfferClose,
                  ),
                  OfferFareCard(
                    onOfferTap: widget.onOfferTap,
                    onOfferClose: widget.onOfferClose,
                  ),
                  OfferFareCard(
                    onOfferTap: widget.onOfferTap,
                    onOfferClose: widget.onOfferClose,
                  ),
                  OfferFareCard(
                    onOfferTap: widget.onOfferTap,
                    onOfferClose: widget.onOfferClose,
                  ),
                  OfferFareCard(
                    onOfferTap: widget.onOfferTap,
                    onOfferClose: widget.onOfferClose,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
