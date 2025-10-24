// lib/widgets/ride_tile.dart
import 'package:flutter/material.dart';
import '../models/ride.dart';

class RideTile extends StatelessWidget {
  final Ride ride;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const RideTile({
    super.key,
    required this.ride,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // nice color accent
    final accent = Colors.blue.shade700;
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(12),
      color: Theme.of(context).cardColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onEdit,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              _buildImage(),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ride.name,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      ride.description,
                      style: const TextStyle(fontSize: 13),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accent,
                            minimumSize: const Size(0, 36),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                          ),
                          onPressed: onEdit,
                          icon: const Icon(Icons.edit, size: 18),
                          label: const Text('แก้ไข', style: TextStyle(fontSize: 14)),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(minimumSize: const Size(0, 36)),
                          onPressed: onDelete,
                          icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                          label: const Text('ลบ', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    // Try network, fallback to icon
    if (ride.imageUrl.isEmpty) {
      return _placeholder();
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        ride.imageUrl,
        width: 92,
        height: 92,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(),
        loadingBuilder: (ctx, child, progress) {
          if (progress == null) return child;
          return SizedBox(
            width: 92,
            height: 92,
            child: Center(
              child: CircularProgressIndicator(value: progress.expectedTotalBytes != null
                ? progress.cumulativeBytesLoaded / (progress.expectedTotalBytes ?? 1)
                : null),
            ),
          );
        },
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 92,
      height: 92,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.photo, size: 36, color: Colors.grey),
    );
  }
}
