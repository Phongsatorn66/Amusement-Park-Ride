import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/ride.dart';
import '../providers/ride_provider.dart';
import '../models/ride_status.dart';

class RideFormScreen extends StatefulWidget {
  final Ride? ride;
  const RideFormScreen({this.ride, super.key});
  @override
  State<RideFormScreen> createState() => _RideFormScreenState();
}

class _RideFormScreenState extends State<RideFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _imageCtrl;
  late TextEditingController _descCtrl;
  late int _thrillLevel;
  late RideStatus _status;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.ride?.name ?? '');
    _imageCtrl = TextEditingController(text: widget.ride?.imageUrl ?? '');
    _descCtrl = TextEditingController(text: widget.ride?.description ?? '');
    _thrillLevel = widget.ride?.thrillLevel ?? 3;
    _status = widget.ride?.status ?? RideStatus.available;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _imageCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.ride != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'แก้ไขเครื่องเล่น' : 'เพิ่มเครื่องเล่น')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'ชื่อเครื่องเล่น'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'กรุณากรอกชื่อ' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _imageCtrl,
                decoration: const InputDecoration(labelText: 'URL รูปภาพ'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'กรุณากรอก URL รูปภาพ' : null,
              ),
              const SizedBox(height: 8),
              if (_imageCtrl.text.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: SizedBox(
                    height: 160,
                    child: Image.network(
                      _imageCtrl.text,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Center(child: Text('ไม่สามารถโหลดภาพได้')),
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(labelText: 'รายละเอียด'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Text('ระดับความน่าตื่นเต้น: $_thrillLevel', style: const TextStyle(fontSize: 16)),
              Slider(
                value: _thrillLevel.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                label: _thrillLevel.toString(),
                onChanged: (v) => setState(() => _thrillLevel = v.round()),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<RideStatus>(
                initialValue: _status, 
                decoration: const InputDecoration(
                  labelText: 'สถานะเครื่องเล่น',
                  border: OutlineInputBorder(),
                ),
                items: RideStatus.values.map((s) {
                  return DropdownMenuItem(
                    value: s,
                    child: Text(getRideStatusText(s)),
                  );
                }).toList(),
                onChanged: (v) {
                  if (v != null) {
                    _status = v; 
                  }
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  final ride = Ride(
                    id: widget.ride?.id,
                    name: _nameCtrl.text.trim(),
                    imageUrl: _imageCtrl.text.trim(),
                    description: _descCtrl.text.trim(),
                    thrillLevel: _thrillLevel,
                    status: _status,
                  );
                  final provider = context.read<RideProvider>();
                  if (isEdit) {
                    await provider.updateRide(ride);
                  } else {
                    await provider.addRide(ride);
                  }
                  if (!context.mounted) return;
                  Navigator.pop(context);
                },
                child: Text(isEdit ? 'บันทึก' : 'เพิ่ม'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}