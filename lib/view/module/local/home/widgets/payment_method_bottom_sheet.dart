import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/image_string.dart';
import '../../../../../utils/constants/color_string.dart';
import '../../../../../utils/constants/text_string.dart';

class PaymentMethodBottomSheet extends StatelessWidget {
  final String selectedMethod;

  const PaymentMethodBottomSheet({
    super.key,
    required this.selectedMethod,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// DRAG HANDLE
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: GBColor.borderColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
             SizedBox(height: 16),

             Text(
              GBText.selectPaymentMethod,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: "Poppins",
              ),
            ),

             SizedBox(height: 18),
            Divider(color: GBColor.primary, height: 1),

            paymentTile(
              context,
              title: GBText.easyPaisa,
              icon: Icons.account_balance_wallet,
            ),
            Divider(color: GBColor.primary, height: 1),

            paymentTile(
              context,
              title: GBText.cash,
              icon: Icons.money,
            ),
            Divider(color: GBColor.primary, height: 1),

            paymentTile(
              context,
              title: GBText.card,
              imagePath: GBImagePath.card,
            ),

             // SizedBox(height: 6),
          ],
        ),
      ),
    );
  }

  Widget paymentTile(
      BuildContext context, {
        required String title,
        IconData? icon,
        String? imagePath,
      }) {
    final bool isSelected = selectedMethod == title;

    Widget leadingWidget;

    if (imagePath != null) {
      leadingWidget = Image.asset(
        imagePath,
        width: 24,
        height: 24,
      );
    } else if (icon != null) {
      leadingWidget = Icon(
        icon,
        size: 24,
        color: isSelected ? GBColor.primary : Colors.black,
      );
    } else {
      leadingWidget = const SizedBox();
    }

    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(vertical: 1.4),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),

      onTap: () => Navigator.pop(context, title),

      leading: leadingWidget,

      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: "Poppins",
          color: isSelected ? GBColor.primary : Colors.black,
        ),
      ),

      trailing: isSelected
          ? Icon(
        Icons.check_circle,
        color: GBColor.primary,
        size: 18,
      )
          : null,
    );
  }
}
