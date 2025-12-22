import 'package:flutter/material.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import 'package:gb_ride/utils/constants/image_string.dart';

import '../view/module/student/booking/booking_screen.dart';
import '../view/module/student/home/home_screen.dart';
import '../view/module/student/ride/ride_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    RideScreen(),
    BookingScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Color _iconColor(int index) {
    return _selectedIndex == index ? Colors.white : Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _screens[_selectedIndex],

      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: GBColor.secondary,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: GBColor.primary,

            borderRadius: BorderRadius.circular(100),
          ),
          child: ClipRRect(
            borderRadius:BorderRadiusGeometry.circular(100),
            child: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onTabTapped,
              type: BottomNavigationBarType.fixed,
              backgroundColor: GBColor.primary,
              enableFeedback: false,

              /// Text colors
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.black,

              /// Text styles
              selectedLabelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),

              items: [
                BottomNavigationBarItem(
                  icon: Image.asset(
                    GBImagePath.home,
                    width: 30,
                    height: 30,
                    color: _iconColor(0),
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    GBImagePath.ride,
                    width: 30,
                    height: 30,
                    color: _iconColor(1),
                  ),
                  label: 'Ride',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    GBImagePath.booking,
                    width: 30,
                    height: 30,
                    color: _iconColor(2),
                  ),
                  label: 'Bookings',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
