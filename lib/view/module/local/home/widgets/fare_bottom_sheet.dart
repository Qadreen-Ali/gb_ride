import 'package:gb_ride/utils/constants/image_string.dart';
import 'package:gb_ride/utils/constants/text_string.dart';
import 'package:gb_ride/view/module/local/home/widgets/payment_method_bottom_sheet.dart';
import '../../../../../common/text_field.dart';
import '../../../../../utils/constants/color_string.dart';
import '../../../../../utils/constants/primary_button.dart';
import 'package:flutter/material.dart';

class FareBottomSheet extends StatefulWidget {
  const FareBottomSheet({super.key});

  @override
  State<FareBottomSheet> createState() => _FareBottomSheetState();
}

class _FareBottomSheetState extends State<FareBottomSheet> {
  String selectedPayment = GBText.cash;

  void _openPaymentSheet() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => PaymentMethodBottomSheet(
        selectedMethod: selectedPayment,
      ),
    );

    if (result != null) {
      setState(() {
        selectedPayment = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// DRAG HANDLE
                Container(
                  width: 60,
                  height: 4,
                  decoration: BoxDecoration(
                    color: GBColor.borderColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 16),

                /// HEADER
                Row(
                  children: [
                    const Spacer(),
                    const Text(
                      GBText.offerYourFare,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: GBColor.primary,
                        ),
                        child: Icon(Icons.close, color: GBColor.secondary),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// FARE FIELD
                TTextField(
                  titleText: GBText.pkr,
                  hintText: GBText.pkr,
                  hintTextColor: Colors.black,
                  keyboardType: TextInputType.number,
                ),


                /// PAYMENT TYPE (CLICKABLE)
                GestureDetector(
                  onTap: _openPaymentSheet,
                  child: AbsorbPointer(
                    child: TTextField(
                      titleText: selectedPayment,
                      hintText: selectedPayment,
                      hintTextColor: Colors.black,
                      prefixIcon: Image(image: AssetImage(GBImagePath.card),width: 24,height: 24,),
                      suffixIcon: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                        size: 16,
                      ),
                      readOnly: true,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                /// DONE BUTTON
                PrimaryButton(
                  title: GBText.done,
                  onPressed: () => Navigator.pop(context),
                  backgroundColor: GBColor.primary,
                  textColor: Colors.white,
                ),

                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

