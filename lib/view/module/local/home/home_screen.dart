import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gb_ride/view/module/local/home/widgets/map_selection_overlay.dart';
import '../../../../utils/constants/color_string.dart';
import '../../driver/home/app_drawer/app_drawer.dart';
import '../../driver/home/widgets/map_markers.dart';
import '../../driver/home/widgets/top_bar.dart';
import 'controller/local_home_controller.dart';
import 'home_bottom_sheet.dart';

class LocalHomeScreen extends StatefulWidget {
  const LocalHomeScreen({super.key});

  @override
  State<LocalHomeScreen> createState() => _LocalHomeScreenState();
}



class _LocalHomeScreenState extends State<LocalHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final LocalHomeController c;

  bool get _isKeyboardOpen => MediaQuery.of(context).viewInsets.bottom > 0;

  @override
  void initState() {
    super.initState();
    c = LocalHomeController();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await c.init();
    });
  }

  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: c,
      builder: (context, _) {
        return Scaffold(
          key: _scaffoldKey,
          drawer:  ProfileDrawer(),
          resizeToAvoidBottomInset: true,
          body: Stack(
            children: [
              c.isLoadingLocation
                  ? const Center(child: CircularProgressIndicator())
                  : FlutterMap(
                mapController: c.mapController,
                options: MapOptions(
                  initialCenter: c.currentLocation,
                  initialZoom: 15.0,
                  onTap: (tapPos, latLng) => c.handleMapTap(latLng),
                  onPositionChanged: (position, hasGesture) {
                    if (hasGesture) {
                      c.onMapGesture(isKeyboardOpen: _isKeyboardOpen);
                    }
                  },
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.all,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                    'https://tiles.locationiq.com/v3/streets/r/{z}/{x}/{y}.png?key=pk.25e1a7ca81d6256515a0311e26fb2ec3',
                    userAgentPackageName: 'com.example.gb_ride',
                  ),
                  MapMarkers(
                    currentLocation: c.currentLocation,
                    pickupLocation: c.pickupLocation,
                    destinationLocation: c.destinationLocation,
                  ),
                  if (c.routes.isNotEmpty)
                    PolylineLayer(
                      polylines: c.routes.asMap().entries.map((entry) {
                        final index = entry.key;
                        final points = entry.value;
                        return Polyline(
                          points: points,
                          strokeWidth: index == 0 ? 6 : 4,
                          color: index == 0
                              ? Colors.blue
                              : Colors.blue.withValues(alpha: 0.4),
                          strokeCap: StrokeCap.round,
                          strokeJoin: StrokeJoin.round,
                        );
                      }).toList(),
                    ),
                ],
              ),

              if (c.isLoadingAddress)
                Positioned(
                  top: 100,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: 12),
                            Text('Loading address...'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

              if (c.isSelectingPickup || c.isSelectingDestination)
                MapSelectionOverlay(
                  isSelectingPickup: c.isSelectingPickup,
                  onCancel: c.cancelSelection,
                ),

              if (!c.isSelectingPickup && !c.isSelectingDestination)
                TopBar(
                  onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
                  onNotificationPressed: () {
                    Navigator.pushNamed(context, '/notification');
                  },
                ),

              if (!c.isSelectingPickup && !c.isSelectingDestination)
                Positioned(
                  right: 12,
                  bottom: 420,
                  child: FloatingActionButton.small(
                    backgroundColor: GBColor.secondary,
                    elevation: 4,
                    onPressed: c.useLiveLocationAsPickup,
                    child: const Icon(Icons.my_location, color: GBColor.primary),
                  ),
                ),

              // Bottom sheet (UI SAME)
              if (!c.isSelectingPickup && !c.isSelectingDestination)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: AnimatedSlide(
                    offset: c.showBottomSheet ? Offset.zero : const Offset(0, 1),
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                    child: HomeBottomSheet(
                      pickupController: c.pickupController,
                      destinationController: c.destinationController,
                      distanceKm: c.distanceKm,
                      etaMinutes: c.etaMinutes,

                      onPickupTap: () async {
                        await c.openLocationSearch(context: context, isPickup: true);
                      },
                      onDestinationTap: () async {
                        await c.openLocationSearch(context: context, isPickup: false);
                      },

                      onStartPickupSelection: c.startPickupSelection,
                      onStartDestinationSelection: c.startDestinationSelection,
                      onExpandSheet: () {},
                      pickupLocation: c.pickupLocation,
                      destinationLocation: c.destinationLocation,
                      selectedVehicle: c.selectedVehicle,
                      onVehicleSelect: (v) => c.setVehicle(v),
                      mapController: c.mapController,

                      onPickupSelected: (pos, name) => c.setPickup(pos, name),
                      onDestinationSelected: (pos, name) async {
                        await c.setDestination(pos, name);
                      },
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
