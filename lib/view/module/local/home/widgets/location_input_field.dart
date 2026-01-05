import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:gb_ride/services/location_search_service.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import 'package:latlong2/latlong.dart';

class LocationInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Color themeColor;     // secondary color
  final Color borderColor;    // border color
  final Color iconColor;    // border color
  final IconData iconData;
  final VoidCallback onMapIconPressed;
  final Function(LatLng position, String displayName) onLocationSelected;
  final VoidCallback onExpandSheet;

  const LocationInputField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.themeColor,
    required this.borderColor,
    required this.iconData,
    required this.onMapIconPressed,
    required this.onLocationSelected,
    required this.onExpandSheet, required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: themeColor.withOpacity(0.08), // secondary color background
        border: Border.all(
          color: borderColor,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Icon(
              iconData,
              color:iconColor,
              size: 22,
            ),
          ),

          Expanded(
            child: TypeAheadField<LocationSuggestion>(
              controller: controller,
              builder: (context, controller, focusNode) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  onTap: onExpandSheet,
                );
              },

              suggestionsCallback: (search) async {
                if (search.length < 2) return [];
                return await LocationSearchService.searchLocations(search);
              },

              itemBuilder: (context, suggestion) {
                return ListTile(
                  dense: true,
                  leading: Icon(Icons.location_on,
                      color: themeColor, size: 20),
                  title: Text(
                    suggestion.displayName.split(',').first,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  subtitle: Text(
                    suggestion.displayName,
                    style: const TextStyle(fontSize: 11),
                  ),
                );
              },

              onSelected: (suggestion) {
                onLocationSelected(
                  LatLng(suggestion.latitude, suggestion.longitude),
                  suggestion.displayName.split(',').first,
                );
              },

              decorationBuilder: (context, child) {
                return Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(8),
                  child: child,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

