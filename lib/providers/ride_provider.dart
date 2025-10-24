// lib/providers/ride_provider.dart
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/ride.dart';

class RideProvider extends ChangeNotifier {
  Database? _db;
  List<Ride> _rides = [];

  List<Ride> get rides => _rides;

  Future<void> initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'rides_db.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE rides(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            imageUrl TEXT,
            description TEXT
          )
        ''');

        // Insert 5 initial rides
        await db.insert('rides', {
          'name': 'Roller Coaster',
          'imageUrl': 'https://cdn.pixabay.com/photo/2017/02/15/22/14/roller-coaster-2071460_1280.jpg',
          'description': 'รถไฟเหาะตีลังกาสุดมันส์ เหมาะกับสายแอดเวนเจอร์',
        });
        await db.insert('rides', {
          'name': 'Ferris Wheel',
          'imageUrl': 'https://cdn.pixabay.com/photo/2016/03/27/18/38/ferris-wheel-1281452_1280.jpg',
          'description': 'ชิงช้าสวรรค์ชมวิวจากมุมสูง เหมาะกับทุกเพศทุกวัย',
        });
        await db.insert('rides', {
          'name': 'Bumper Cars',
          'imageUrl': 'https://cdn.pixabay.com/photo/2016/08/30/13/20/fun-ride-1635746_1280.jpg',
          'description': 'รถบั๊มสุดฮา สนุกได้ทั้งครอบครัว',
        });
        await db.insert('rides', {
          'name': 'Pirate Ship',
          'imageUrl': 'https://cdn.pixabay.com/photo/2016/11/22/19/47/pirate-ship-1851222_1280.jpg',
          'description': 'เรือไวกิ้งเหวี่ยงสุดเหวี่ยง สนุกและหวาดเสียว!',
        });
        await db.insert('rides', {
          'name': 'Haunted House',
          'imageUrl': 'https://cdn.pixabay.com/photo/2015/11/07/11/43/haunted-house-1030347_1280.jpg',
          'description': 'บ้านผีสิงสุดระทึก เหมาะกับคนใจกล้า',
        });
      },
    );

    await load();
  }

  Future<void> load() async {
    if (_db == null) return;
    final maps = await _db!.query('rides');
    _rides = maps.map((m) => Ride.fromMap(m)).toList();
    notifyListeners();
  }

  Future<void> addRide(Ride ride) async {
    if (_db == null) return;
    await _db!.insert('rides', ride.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    await load();
  }

  Future<void> updateRide(Ride ride) async {
    if (_db == null) return;
    await _db!.update('rides', ride.toMap(), where: 'id = ?', whereArgs: [ride.id]);
    await load();
  }

  Future<void> deleteRide(int id) async {
    if (_db == null) return;
    await _db!.delete('rides', where: 'id = ?', whereArgs: [id]);
    await load();
  }
}
