import 'package:flutter/material.dart';

class TrackingMapView extends StatelessWidget {
  const TrackingMapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 10)],
      ),
      child: Stack(
        children: [
          // Map Network Preview
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                'https://images.unsplash.com/photo-1524661135-423995f22d0b?auto=format&fit=crop&w=600&q=80',
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Start point indicator
          Positioned(
            bottom: 40,
            right: 60,
            child: _buildMapMarker(context, 'نقطة البدء (الرياض)', Colors.blue),
          ),
          // Current location indicator
          Positioned(
            top: 100,
            left: 120,
            child: _buildMapMarker(context, 'الشحنة حالياً', Colors.orange, isCurrent: true),
          ),
          // Destination indicator
          Positioned(
            top: 30,
            right: 180,
            child: _buildMapMarker(context, 'الوجهة (الدمام)', Colors.green),
          ),
        ],
      ),
    );
  }

  Widget _buildMapMarker(BuildContext context, String label, Color color, {bool isCurrent = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(6),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          child: Text(label, style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold)),
        ),
        SizedBox(height: 2),
        Icon(
          isCurrent ? Icons.local_shipping : Icons.location_on,
          color: color,
          size: isCurrent ? 24 : 20,
        ),
      ],
    );
  }
}


