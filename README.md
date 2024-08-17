# Money Tracker

Money Tracker is a Flutter-based application designed to help users manage their expenses and budget effectively. The app leverages providers for state management and uses SQLite (via `sqflite`) for local data storage. Comprehensive test cases have also been implemented to ensure the app's robustness and reliability.

## Features

- **Expense Tracking:** Log your daily expenses categorized by type (e.g., Food, Transport, etc.).
- **Budget Management:** Monitor your spending to stay within budget.
- **Category-wise Summaries:** View detailed summaries of expenses by category.
- **Historical Data:** Access past expenses and analyze spending patterns over time.
- **Local Notifications:** Daily Notifications for remainder of data 
- **Local Storage with SQLite:** Your data is stored locally on your device using SQLite, ensuring quick access and offline functionality.

## Technologies Used

- **Flutter:** The core framework for building the app.
- **Provider:** Used for state management, ensuring efficient and organized updates across the app.
- **SQLite (`sqflite`):** Handles all local database operations, including storing and retrieving expense data.
- **Mockito:** Utilized for mocking dependencies and writing unit tests for database operations and business logic.
- **Flutter Test:** Comprehensive unit and widget tests ensure the app’s functionality is robust and reliable.

## Getting Started

To get started with the Money Tracker app, follow these steps:

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/money-tracker.git
   cd money-tracker
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

## Running Tests

This project includes unit tests to validate the app's logic and behavior:

- **Unit Tests:** Test the business logic, including providers and database interactions.

To run the tests, use the following command:

```bash
flutter test
```

## Folder Structure

The project follows a structured folder organization:

- **`lib/models/`**: Contains data models like `Expense`, `ExpenseCategory`, and the `DatabaseProvider`.
- **`lib/screens/`**: Holds all the UI screens for the app.
- **`lib/widgets/`**: Reusable UI components.
- **`lib/constants/`**: Contains Constants.
- **`test/`**: Contains all the unit test cases for database provider.

## Contributing

Contributions are welcome! Feel free to open issues or submit pull requests to help improve the app.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgements

- [Flutter](https://flutter.dev/)
- [Provider](https://pub.dev/packages/provider)
- [Sqflite](https://pub.dev/packages/sqflite)
- [Mockito](https://pub.dev/packages/mockito)
