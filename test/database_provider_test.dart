import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:money_tracker/models/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:money_tracker/models/ex_category.dart';
import 'package:money_tracker/models/expense.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

@GenerateMocks([Database])
import 'database_provider_test.mocks.dart';
import 'dbsetup.dart';

void main() {
  setupDatabase();

  group('DatabaseProvider', () {
    late DatabaseProvider dbProvider;
    late MockDatabase mockDatabase;

    setUp(()  async {
      mockDatabase = MockDatabase();
      dbProvider = DatabaseProvider();

      dbProvider.clearAllExpenses();

    });



    test('Initial values are correct', () {
      expect(dbProvider.categories, []);
      expect(dbProvider.expenses, []);
      expect(dbProvider.searchText, '');
    });

    test('Set searchText updates the searchText and notifies listeners', () {
      bool isNotified = false;

      dbProvider.addListener(() {
        isNotified = true;
      });

      dbProvider.searchText = 'new search text';

      expect(dbProvider.searchText, 'new search text');
      expect(isNotified, true);
    });

    test('fetchCategories returns and sets categories', () async {


      await dbProvider.fetchCategories();

      expect(dbProvider.categories.length, 6);
    });

    test('addExpense inserts expense and updates category', () async {
      final testCategory = ExpenseCategory(
        title: 'Food',
        entries: 1,
        totalAmount: 50.0,
        icon: Icons.local_pizza,
      );

      final testExpense = Expense(
        id: 1,
        title: 'Dinner',
        amount: 50.0,
        date: DateTime.now(),
        category: 'Food',
      );

      when(mockDatabase.insert(any, any)).thenAnswer((_) async => 1);

      dbProvider.categories.add(testCategory); // Initialize the category

      await dbProvider.addExpense(testExpense);

      expect(dbProvider.expenses.length, 1);
      expect(dbProvider.expenses[0].title, 'Dinner');
      expect(dbProvider.findCategory('Food').entries, 1);
      expect(dbProvider.findCategory('Food').totalAmount, 50.0);
    });

    test('deleteExpense removes expense and updates category', () async {
      final testCategory = ExpenseCategory(
        title: 'Transport',
        entries: 1,
        totalAmount: 0.0,
        icon: Icons.miscellaneous_services,
      );

      // final testExpense = Expense(
      //   id: 1,
      //   title: 'Dinner',
      //   amount: 50.0,
      //   date: DateTime.now(),
      //   category: 'Transport',
      // );

      // Add the initial category
      dbProvider.categories.add(testCategory);


      // Mock the insert and delete operations
      when(mockDatabase.insert(any, any)).thenAnswer((_) async => 1);
      when(mockDatabase.delete(any, where: anyNamed('where'), whereArgs: anyNamed('whereArgs')))
          .thenAnswer((_) async => 0);

      await dbProvider.deleteExpense(1, 'Transport', 50.0);

      expect(dbProvider.expenses.length, 0);


    });

    test('fetchExpenses returns expenses for a specific category', () async {
      final testCategory = ExpenseCategory(
        title: 'Food',
        entries: 0,
        totalAmount: 0.0,
        icon: Icons.miscellaneous_services,
      );

      final testExpense = Expense(
        id: 1,
        title: 'Dinner',
        amount: 50.0,
        date: DateTime.now(),
        category: 'Food',
      );

      dbProvider.categories.add(testCategory); // Initialize category



      await dbProvider.addExpense(testExpense);

      await dbProvider.fetchExpenses('Food');

      expect(dbProvider.expenses.length, 1);
      expect(dbProvider.expenses[0].title, 'Dinner');
    });

    test('fetchAllExpenses returns all expenses', () async {
      final testCategory = ExpenseCategory(
        title: 'Food',
        entries: 0,
        totalAmount: 0.0,
        icon: Icons.miscellaneous_services,
      );

      final testExpense = Expense(
        id: 1,
        title: 'Dinner',
        amount: 50.0,
        date: DateTime.now(),
        category: 'Food',
      );

      dbProvider.categories.add(testCategory); // Initialize category



      await dbProvider.addExpense(testExpense);


      await dbProvider.fetchAllExpenses();

      expect(dbProvider.expenses.length, 1);
      expect(dbProvider.expenses[0].title, 'Dinner');
    });


    test('fetchExpenses returns expenses for a specific category', () async {

      await dbProvider.fetchExpenses('Others');

      expect(dbProvider.expenses.length, 0);
    });


    test('findCategory returns the correct category', () {
      final testCategory = ExpenseCategory(title: 'Food', entries: 2, totalAmount: 100.0, icon: Icons.local_pizza);
      dbProvider.categories.add(testCategory);

      final category = dbProvider.findCategory('Food');

      expect(category.title, 'Food');
    });

    test('calculateEntriesAndAmount returns correct values', () {
      final testExpense1 = Expense(
        id: 1,
        title: 'Lunch',
        amount: 50.0,
        date: DateTime.now(),
        category: 'Food',
      );
      final testExpense2 = Expense(
        id: 2,
        title: 'Dinner',
        amount: 100.0,
        date: DateTime.now(),
        category: 'Food',
      );

      dbProvider.expenses.add(testExpense1);
      dbProvider.expenses.add(testExpense2);

      final result = dbProvider.calculateEntriesAndAmount('Food');

      expect(result['entries'], 2);
      expect(result['totalAmount'], 150.0);
    });

    test('calculateTotalExpenses returns correct sum', () {
      final testCategory1 = ExpenseCategory(title: 'Food', entries: 2, totalAmount: 150.0, icon: Icons.local_pizza);
      final testCategory2 = ExpenseCategory(title: 'Transport', entries: 1, totalAmount: 50.0, icon: Icons.train);

      dbProvider.categories.add(testCategory1);
      dbProvider.categories.add(testCategory2);

      final totalExpenses = dbProvider.calculateTotalExpenses();

      expect(totalExpenses, 200.0);
    });

    test('calculateWeekExpenses returns correct daily totals', () {
      final today = DateTime.now();
      final testExpense1 = Expense(
        id: 1,
        title: 'Lunch',
        amount: 50.0,
        date: today.subtract(Duration(days: 1)),
        category: 'Food',
      );
      final testExpense2 = Expense(
        id: 2,
        title: 'Dinner',
        amount: 100.0,
        date: today.subtract(Duration(days: 1)),
        category: 'Food',
      );

      dbProvider.expenses.add(testExpense1);
      dbProvider.expenses.add(testExpense2);

      final weekExpenses = dbProvider.calculateWeekExpenses();

      expect(weekExpenses.length, 7);
      expect(weekExpenses[1]['amount'], 150.0); // This should match the test data
    });
  });
}