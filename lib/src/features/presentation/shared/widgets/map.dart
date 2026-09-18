import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
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

  const MapWidget({
    super.key,
    required this.mapController,
    this.startPoint,
    this.endPoint,
    this.routePoints = const [],
    this.interactive = true,
    this.mapReady
  });



  @override
  Widget build(BuildContext context) {
    // const cornerValue = WidgetCircleRadius.buttonRadius;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = context.colors;

    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: const LatLng(0, 0),
        initialZoom: 12,
        minZoom: 3,
        maxZoom: 19,
        onMapReady: mapReady,

        interactionOptions: InteractionOptions(
          flags: interactive ? InteractiveFlag.all : InteractiveFlag.none,
        ),
      ),

      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.salud_ulv_app',

          tileBuilder: isDark ? darkModeTileBuilder : null,
        ),

        // Ruta recorrida (opcional)
        if (routePoints.length > 1)
          PolylineLayer(
            polylines: [
              Polyline(
                points: routePoints,
                strokeWidth: 4,
                color: colors.onSecondary,
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

        CurrentLocationLayer(
          style: LocationMarkerStyle(
            marker: DefaultLocationMarker(child: Icon(Icons.location_pin)),
            markerSize: Size(20, 20),
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
        boxShadow: context.shadows.smBoxShadow
      ),
      child: Icon(icon, color: Colors.white, size: 18),
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