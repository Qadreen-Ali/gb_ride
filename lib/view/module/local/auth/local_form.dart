import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/global_appbar.dart';

void main(){runApp()}

class ProfileInformation extends StatelessWidget {
  const ProfileInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:GlobalAppBar(title: 'Profile Information',
      ) ,
    );
  }
}