import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/ride.dart';
import '../models/ride_status.dart'; 

class RideProvider extends ChangeNotifier {
  Database? _db;
  List<Ride> _rides = [];

  List<Ride> get rides => _rides;

  Future<void> initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'rides_db.db');

    _db = await openDatabase(
      path,
      version: 2, 
      onCreate: (db, version) async {
        
        await db.execute('''
          CREATE TABLE rides(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            imageUrl TEXT,
            description TEXT,
            thrillLevel INTEGER NOT NULL DEFAULT 3,
            status TEXT NOT NULL DEFAULT 'available'
          )
        ''');

        
        await db.insert('rides', {
          'name': 'Roller Coaster',
          'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/6/65/Luna_Park_Melbourne_scenic_railway.jpg',
          'description': 'รถไฟเหาะตีลังกาสุดมันส์ เหมาะกับสายแอดเวนเจอร์',
          'thrillLevel': 5,
          'status': RideStatus.available.name,
        });
        await db.insert('rides', {
          'name': 'Ferris Wheel',
          'imageUrl': 'https://www.oktoberfest.de/sites/default/files/styles/facebook/public/2025-01/whatsapp_image_2025-01-13_at_15.01.26.jpeg?h=71976bb4',
          'description': 'ชิงช้าสวรรค์ชมวิวจากมุมสูง เหมาะกับทุกเพศทุกวัย',
          'thrillLevel': 1,
          'status': RideStatus.available.name,
        });
        await db.insert('rides', {
          'name': 'Bumper Cars',
          'imageUrl': 'https://i.ytimg.com/vi/qarl_jGdNIs/maxresdefault.jpg?sqp=-oaymwEmCIAKENAF8quKqQMa8AEB-AH-CYAC0AWKAgwIABABGFkgQShyMA8=&rs=AOn4CLB5Dmwo65cdxZ1RfxLF8aIBDoAOOQ',
          'description': 'รถบั๊มสุดฮา สนุกได้ทั้งครอบครัว',
          'thrillLevel': 2,
          'status': RideStatus.maintenance.name, 
        });
        await db.insert('rides', {
          'name': 'Pirate Ship',
          'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRBsH_1U1ihNWi3poJwH5ZdGezO75i2DQZdIA&s',
          'description': 'เรือไวกิ้งเหวี่ยงสุดเหวี่ยง สนุกและหวาดเสียว!',
          'thrillLevel': 4,
          'status': RideStatus.available.name,
        });
        await db.insert('rides', {
          'name': 'Haunted House',
          'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSpE-mU4QkpKwCK7ic0ds-pxi3eYjxLgVubHA&s',
          'description': 'บ้านผีสิงสุดระทึก เหมาะกับคนใจกล้า',
          'thrillLevel': 3,
          'status': RideStatus.closed.name, 
        });
      },
      
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          
          await db.execute('ALTER TABLE rides ADD COLUMN thrillLevel INTEGER NOT NULL DEFAULT 3');
          await db.execute("ALTER TABLE rides ADD COLUMN status TEXT NOT NULL DEFAULT 'available'");

          await db.update('rides', {'thrillLevel': 5}, where: 'name = ?', whereArgs: ['Roller Coaster']);
          await db.update('rides', {'thrillLevel': 1}, where: 'name = ?', whereArgs: ['Ferris Wheel']);
          await db.update('rides', {'thrillLevel': 2, 'status': RideStatus.maintenance.name}, where: 'name = ?', whereArgs: ['Bumper Cars']);
          await db.update('rides', {'thrillLevel': 4}, where: 'name = ?', whereArgs: ['Pirate Ship']);
          await db.update('rides', {'thrillLevel': 3, 'status': RideStatus.closed.name}, where: 'name = ?', whereArgs: ['Haunted House']);
        }
      },
    );

    await load();
  }

  Future<void> load() async {
    if (_db == null) return;
    final maps = await _db!.query('rides', orderBy: 'name ASC');
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