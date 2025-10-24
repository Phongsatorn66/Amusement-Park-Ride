import 'package:flutter/material.dart';
import '../models/ride.dart';
import '../models/ride_status.dart'; 

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
    final accent = Colors.blue.shade700;
    final bool isClosed = ride.status == RideStatus.closed;
    final Color statusColor = getRideStatusColor(ride.status);

    return Opacity(
      opacity: isClosed ? 0.6 : 1.0,
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: isClosed ? null : onEdit, 
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
                      const SizedBox(height: 6),

                      Row(
                        children: List.generate(5, (i) {
                          return Icon(
                            i < ride.thrillLevel ? Icons.star_rounded : Icons.star_border_rounded,
                            color: i < ride.thrillLevel ? Colors.orange.shade600 : Colors.grey.shade400,
                            size: 20,
                          );
                        }),
                      ),
                      const SizedBox(height: 6),

                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: statusColor.withAlpha(38), 
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          getRideStatusText(ride.status),
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
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
                            onPressed: isClosed ? null : onEdit, // 7. ปิดปุ่มแก้ไขถ้า 'ปิด'
                            icon: const Icon(Icons.edit, size: 18),
                            label: const Text('แก้ไข', style: TextStyle(fontSize: 14)),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(minimumSize: const Size(0, 36)),
                            onPressed: onDelete, // (ปุ่มลบยังกดได้)
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
      ),
    );
  }

  Widget _buildImage() {
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