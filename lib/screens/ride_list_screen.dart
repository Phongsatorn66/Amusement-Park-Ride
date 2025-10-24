// lib/screens/ride_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ride_provider.dart';
import '../models/ride.dart';
import '../screens/ride_form_screen.dart';
import '../widgets/ride_tile.dart';

class RideListScreen extends StatefulWidget {
  const RideListScreen({super.key});
  @override
  State<RideListScreen> createState() => _RideListScreenState();
}

class _RideListScreenState extends State<RideListScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  bool _isGrid = false;
  String _query = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final prov = Provider.of<RideProvider>(context, listen: false);
      prov.initDatabase();
    });

    _searchCtrl.addListener(() {
      setState(() => _query = _searchCtrl.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<Ride> _applyFilter(List<Ride> list) {
    if (_query.isEmpty) return list;
    return list.where((r) {
      final name = r.name.toLowerCase();
      final desc = r.description.toLowerCase();
      return name.contains(_query) || desc.contains(_query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เครื่องเล่นในสวนสนุก'),
        actions: [
          IconButton(
            tooltip: 'สลับมุมมอง',
            icon: Icon(_isGrid ? Icons.view_list : Icons.grid_view),
            onPressed: () => setState(() => _isGrid = !_isGrid),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(68),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 14),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchCtrl,
                            decoration: const InputDecoration(
                              hintText: 'ค้นหาเครื่องเล่น (ชื่อ/คำอธิบาย)',
                              border: InputBorder.none,
                              isCollapsed: true,
                            ),
                            textInputAction: TextInputAction.search,
                          ),
                        ),
                        if (_query.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              _searchCtrl.clear();
                              FocusScope.of(context).unfocus();
                            },
                            child: const Icon(Icons.close, color: Colors.grey),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Consumer<RideProvider>(
        builder: (context, prov, child) {
          final items = _applyFilter(prov.rides);

          if (prov.rides.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.search_off, size: 56, color: Colors.grey),
                  const SizedBox(height: 12),
                  Text('ไม่พบ "${_searchCtrl.text}"', style: const TextStyle(fontSize: 16)),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: _isGrid
                ? GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.95,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, idx) {
                      final r = items[idx];
                      return RideTile(
                        ride: r,
                        onEdit: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RideFormScreen(ride: r))),
                        onDelete: () async {
                          final provider = context.read<RideProvider>();
                          final ok = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('ยืนยันการลบ'),
                              content: Text('ต้องการลบ "${r.name}" หรือไม่?'),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('ยกเลิก')),
                                TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('ลบ')),
                              ],
                            ),
                          );
                          if (ok == true) await provider.deleteRide(r.id!);
                        },
                      );
                    },
                  )
                : ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, idx) {
                      final r = items[idx];
                      return RideTile(
                        ride: r,
                        onEdit: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RideFormScreen(ride: r))),
                        onDelete: () async {
                          final provider = context.read<RideProvider>();
                          final ok = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('ยืนยันการลบ'),
                              content: Text('ต้องการลบ "${r.name}" หรือไม่?'),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('ยกเลิก')),
                                TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('ลบ')),
                              ],
                            ),
                          );
                          if (ok == true) await provider.deleteRide(r.id!);
                        },
                      );
                    },
                  ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RideFormScreen())),
        icon: const Icon(Icons.add),
        label: const Text('เพิ่มเครื่องเล่น'),
      ),
    );
  }
}
