import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smartride/data/models/ride_record.dart';

class HistoryMapScreen extends StatelessWidget {
  const HistoryMapScreen({super.key, required this.rides});

  final List<RideRecord> rides;

  @override
  Widget build(BuildContext context) {
    final polylines = <Polyline>{};
    final markers = <Marker>{};

    for (var i = 0; i < rides.length; i++) {
      final ride = rides[i];
      final lat = -33.45 + (i * 0.002);
      final lng = -70.66 + (i * 0.002);
      final origin = LatLng(lat - 0.01, lng - 0.01);
      final destination = LatLng(lat, lng);

      polylines.add(
        Polyline(
          polylineId: PolylineId('ride_$i'),
          points: [origin, destination],
          width: 5,
          color: const Color(0xFFE94F1C),
        ),
      );

      markers.add(
        Marker(
          markerId: MarkerId('dest_$i'),
          position: destination,
          infoWindow: InfoWindow(
            title: ride.destination,
            snippet: 'Net Profit: \$${ride.netProfit.toStringAsFixed(0)}',
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Route History')),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(-33.4489, -70.6693),
          zoom: 11,
        ),
        polylines: polylines,
        markers: markers,
      ),
    );
  }
}
