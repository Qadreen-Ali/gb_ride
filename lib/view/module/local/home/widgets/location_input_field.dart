import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:gb_ride/services/location_search_service.dart';
import 'package:latlong2/latlong.dart';

class LocationInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Color themeColor;
  final IconData iconData;
  final VoidCallback onMapIconPressed;
  final Function(LatLng position, String displayName) onLocationSelected;
  final VoidCallback onExpandSheet;

  const LocationInputField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.themeColor,
    required this.iconData,
    required this.onMapIconPressed,
    required this.onLocationSelected,
    required this.onExpandSheet,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: themeColor.withOpacity(0.1),
        border: Border.all(
          color: themeColor.withOpacity(0.3),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: themeColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                iconData,
                color: Colors.white,
                size: 20,
              ),
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
                if (search.isEmpty || search.length < 2) return [];
                return await LocationSearchService.searchLocations(search);
              },
              itemBuilder: (context, LocationSuggestion suggestion) {
                return ListTile(
                  dense: true,
                  leading: Icon(
                    Icons.location_on,
                    color: themeColor,
                    size: 20,
                  ),
                  title: Text(
                    suggestion.displayName.split(',').first,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    suggestion.displayName,
                    style: const TextStyle(fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
              onSelected: (LocationSuggestion suggestion) {
                final position = LatLng(
                  suggestion.latitude,
                  suggestion.longitude,
                );
                onLocationSelected(
                  position,
                  suggestion.displayName.split(',').first,
                );
              },
              emptyBuilder: (context) => const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'No locations found',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
              loadingBuilder: (context) => const Padding(
                padding: EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              errorBuilder: (context, error) => const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Error loading suggestions',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
              decorationBuilder: (context, child) {
                return Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(8),
                  child: child,
                );
              },
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.map,
              color: themeColor,
              size: 24,
            ),
            onPressed: onMapIconPressed,
            tooltip: 'Select on map',
          ),
        ],
      ),
    );
  }
}