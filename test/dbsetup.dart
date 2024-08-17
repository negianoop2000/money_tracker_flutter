import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void setupDatabase() {
    // Initialize FFI
    sqfliteFfiInit();
    // Change the default factory
    databaseFactory = databaseFactoryFfi;
  }
