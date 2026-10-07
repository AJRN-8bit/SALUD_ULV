import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/themes/fonts_size.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/themes/shadows.dart';
import 'package:salud_ulv_app/src/features/presentation/shared/themes/themes.dart';
import 'package:url_launcher/url_launcher.dart';

class MapWidget extends StatelessWidget {
  final MapController mapController;
  final LatLng? startPoint;
  final LatLng? endPoint;
  final List<LatLng> routePoints;
  final bool interactive;
  final VoidCallback? mapReady;
  final double pointSize = 26;
  final bool satellite;
  final bool showCurrentLocation;

  const MapWidget({
    super.key,
    required this.mapController,
    this.startPoint,
    this.endPoint,
    this.routePoints = const [],
    this.interactive = true,
    this.mapReady,
    this.satellite = true,
    this.showCurrentLocation = true,
  });

  @override
  Widget build(BuildContext context) {
    // const cornerValue = WidgetCircleRadius.buttonRadius;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = context.colors;

    CameraFit? initialFit() {
      if (routePoints.length < 2) return null;

      final bounds = LatLngBounds.fromPoints(routePoints);

      // Zero-area bounds (all points identical) would produce Infinity/NaN zoom
      if (bounds.north == bounds.south && bounds.east == bounds.west) {
        return null;
      }

      return CameraFit.bounds(
        bounds: bounds,
        padding: const EdgeInsets.all(30),
        maxZoom: 18,
      );
    }

    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCameraFit: initialFit(),
        // Only used if there is no route
        initialCenter: startPoint ?? const LatLng(0, 0),
        initialZoom: 20,
        minZoom: 3,
        maxZoom: 28,
        onMapReady: mapReady,

        interactionOptions: InteractionOptions(
          flags: interactive ? InteractiveFlag.all : InteractiveFlag.none,
        ),
      ),

      children: [
        TileLayer(
          urlTemplate: satellite
              ? 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'
              : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.salud_ulv_app',
          tileBuilder: (!satellite && isDark) ? darkModeTileBuilder : null,
        ),

        // Ruta recorrida (opcional)
        if (routePoints.length > 1)
          PolylineLayer(
            polylines: [
              Polyline(
                points: routePoints,
                strokeWidth: 5,
                gradientColors: [
                  colors.primary,
                  colors.onPrimary,
                  colors.secondary,
                  colors.onSecondary,
                  colors.tertiary,
                  // colors.success,
                ], 
                // optional: where each color sits, from 0.0 to 1.0
                // colorsStop: [0.0, 1.0],
                strokeCap: StrokeCap.round,
                strokeJoin: StrokeJoin.round,
              ),
            ],
          ),

        // Marcadores de inicio / fin
        MarkerLayer(
          markers: [
            if (startPoint != null)
              Marker(
                point: startPoint!,
                width: pointSize,
                height: pointSize,
                child: _RoutePin(
                  icon: Icons.play_arrow_rounded,
                  color: colors.success,
                ),
              ),
            if (endPoint != null)
              Marker(
                point: endPoint!,
                width: pointSize,
                height: pointSize,
                child: _RoutePin(
                  icon: Icons.flag_rounded,
                  color: colors.warning,
                ),
              ),
          ],
        ),

        RichAttributionWidget(
          alignment: AttributionAlignment.bottomLeft,
          attributions: [
            TextSourceAttribution(
              'OpenStreetMap contributors',
              onTap: () =>
                  launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
            ),
          ],
        ),

        if(showCurrentLocation)
        CurrentLocationLayer(
          style: LocationMarkerStyle(
            markerAlignment: .center,
            marker: DefaultLocationMarker(child: Icon(Icons.location_pin, color: context.colors.primary,)),
            markerSize: Size(15, 15),
            markerDirection: .heading,
          ),
        
        ),
      ],
    );
  }
}

class _RoutePin extends StatelessWidget {
  final IconData icon;
  final Color? color;

  const _RoutePin({required this.icon, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? context.colors.onPrimary,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: context.shadows.smBoxShadow,
      ),
      child: Icon(icon, color: Colors.white, size: context.fontsSize.body),
    );
  }
}


void fitRouteToScreen(List<LatLng> routePoints, MapController mapController) {
  if (routePoints.isEmpty) return;

  if (routePoints.length == 1) {
    mapController.move(routePoints.first, 16);
    return;
  }

  final bounds = LatLngBounds.fromPoints(routePoints);

  mapController.fitCamera(
    CameraFit.bounds(
      bounds: bounds,
      padding: EdgeInsets.all(30),
      maxZoom: 18,
      // minZoom: 15
    ),
  );
}
