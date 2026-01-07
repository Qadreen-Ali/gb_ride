import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gb_ride/services/location_search_service.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import 'package:latlong2/latlong.dart';

class LocationSearchScreen extends StatefulWidget {
  final bool isPickup;
  final String? selectedLocationName;

  const LocationSearchScreen({
    super.key,
    required this.isPickup,
    this.selectedLocationName,
  });

  @override
  State<LocationSearchScreen> createState() =>
      _LocationSearchBottomSheetState();
}

class _LocationSearchBottomSheetState extends State<LocationSearchScreen> {
  final TextEditingController _controller = TextEditingController();

  List<LocationSuggestion> _results = [];
  Timer? _debounce;
  bool _loading = false;

  // 🔍 Search handler
  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () async {
      if (value.length < 2) {
        setState(() => _results = []);
        return;
      }

      setState(() => _loading = true);

      final res = await LocationSearchService.searchLocations(value);

      if (mounted) {
        setState(() {
          _results = res;
          _loading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 0,
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 10,
      ),
      decoration: const BoxDecoration(
        color: GBColor.secondary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ───── HEADER ─────
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),

          // const SizedBox(height: 12),

          // ───── SEARCH FIELD ─────
          Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: GBColor.secondary,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: GBColor.borderColor),
            ),
            child: Row(
              children: [
                Icon(
                  widget.isPickup ? Icons.radio_button_checked : Icons.search,
                  color: widget.isPickup ? Colors.red : Colors.white,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    autofocus: true,
                    style: const TextStyle(color: GBColor.black),
                    decoration: InputDecoration(
                      hintText: widget.isPickup
                          ? 'Search pickup location'
                          : 'Search destination location',
                      hintStyle: const TextStyle(color: GBColor.textFieldText),
                      border: InputBorder.none,
                    ),
                    onChanged: _onSearchChanged,
                  ),
                ),
                if (_controller.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      _controller.clear();
                      setState(() => _results = []);
                    },
                  ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // // ───── OTHER LOCATION FIELD (DISABLED) ─────
          // Container(
          //   height: 52,
          //   padding: const EdgeInsets.symmetric(horizontal: 12),
          //   decoration: BoxDecoration(
          //     color: Colors.grey.shade700,
          //     borderRadius: BorderRadius.circular(12),
          //   ),
          //   child: Row(
          //     children: [
          //       Icon(
          //         widget.isPickup
          //             ? Icons.location_on
          //             : Icons.radio_button_unchecked,
          //         color: widget.isPickup ? Colors.grey : Colors.red,
          //       ),
          //       const SizedBox(width: 8),
          //       Expanded(
          //         child: Text(
          //           widget.selectedLocationName ?? 'Not selected',
          //           style: const TextStyle(
          //             color: Colors.grey,
          //             overflow: TextOverflow.ellipsis,
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // const SizedBox(height: 12),

          // ───── CHOOSE ON MAP ─────
          ListTile(
            leading: const Icon(Icons.map, color: GBColor.primary),
            title: const Text(
              'Choose on map',
              style: TextStyle(color: Colors.blue),
            ),
            onTap: () => Navigator.pop(context, 'map'),
          ),

          const SizedBox(height: 8),

          // ───── RESULTS ─────
          if (_loading)
            const Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ),

          if (!_loading && _results.isNotEmpty)
            Flexible(
              child: ListView.builder(
                itemCount: _results.length,
                itemBuilder: (context, index) {
                  final item = _results[index];

                  return ListTile(
                    leading: const Icon(Icons.place, color: Colors.grey),
                    title: Text(
                      item.displayName.split(',').first,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      item.displayName,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    trailing: const Text(
                      '— km',
                      style: TextStyle(color: Colors.grey),
                    ),
                    onTap: () {
                      final pos = LatLng(item.latitude, item.longitude);

                      Navigator.pop(context, {
                        'latLng': pos,
                        'name': item.displayName.split(',').first,
                      });
                    },
                  );
                },
              ),
            ),

          if (!_loading && _results.isEmpty && _controller.text.isNotEmpty)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'No locations found',
                style: TextStyle(color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }
}
