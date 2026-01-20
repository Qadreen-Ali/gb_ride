import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gb_ride/services/location_search_service.dart';
import 'package:gb_ride/utils/constants/color_string.dart';
import 'package:latlong2/latlong.dart';
import 'package:gb_ride/services/gb_poi_service.dart';
import 'package:gb_ride/models/gb_poi.dart';

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

  @override
  void initState() {
    super.initState();
    GbPoiService.loadPois(); // 🔥 load local GB POIs
  }

  List<LocationSuggestion> _results = [];
  Timer? _debounce;
  bool _loading = false;

  // 🔍 Search handler
  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () async {
      if (value.trim().length < 2) {
        setState(() => _results = []);
        return;
      }

      setState(() => _loading = true);

      // 🔥 1️⃣ LOCAL POI SEARCH (FAST)
      final List<GbPoi> localPois = GbPoiService.search(value);

      final localSuggestions = localPois.map((poi) {
        return LocationSuggestion(
          displayName: '${poi.name}, ${poi.city}',
          latitude: poi.lat,
          longitude: poi.lon,
          type: poi.type,
        );
      }).toList();

      // 🌐 2️⃣ LOCATIONIQ SEARCH (FALLBACK)
      final apiResults = await LocationSearchService.searchLocations(value);

      // 🧹 3️⃣ MERGE + REMOVE DUPLICATES
      final seen = <String>{};
      final mergedResults = [
        ...localSuggestions,
        ...apiResults,
      ].where((e) => seen.add(e.displayName)).toList();

      if (mounted) {
        setState(() {
          _results = mergedResults;
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
    return SafeArea(
      top: false,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            color: GBColor.secondary,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Center(
                child: Container(
                  width: 55,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 12),

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
                      widget.isPickup
                          ? Icons.radio_button_checked
                          : Icons.location_on,
                      color: widget.isPickup ? Colors.black : Colors.black,
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
                          hintStyle: const TextStyle(
                            color: GBColor.textFieldText,
                          ),
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
                leading: Image.asset(
                  'assets/images/gblocation.png',
                  width: 24,
                  height: 24,
                ),
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
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    itemCount: _results.length,
                    itemBuilder: (context, index) {
                      final item = _results[index];

                      return InkWell(
                        onTap: () {
                          final pos = LatLng(item.latitude, item.longitude);
                          Navigator.pop(context, {
                            'latLng': pos,
                            'name': item.displayName.split(',').first,
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 📍 ICON — BASELINE ALIGNED
                              Baseline(
                                baseline: 18, // 🔥 tweak if font size changes
                                baselineType: TextBaseline.alphabetic,
                                child: Icon(
                                  Icons.place,
                                  color: GBColor.primary,
                                  size: 20,
                                ),
                              ),

                              const SizedBox(width: 14),

                              // 📝 TEXT
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.displayName.split(',').first,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        height: 1.2,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.displayName,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 13,
                                        height: 1.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
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
        ),
      ),
    );
  }
}
