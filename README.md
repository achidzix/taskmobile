# taskmobile
 Flutter mobile app for managing tasks

 # Flutter Task Management App

This Flutter application is a mobile task management tool that interacts with a remote Spring Boot backend API. It features offline functionality, manual synchronization, and secure authentication using JWT (JSON Web Tokens).

## Features

*   **Task Management:**
    *   Create, view, update, and delete tasks.
    *   Offline access to tasks.
    *   Manual synchronization with the remote server.
*   **User Authentication:**
    *   Secure login using JWT.
    *   Secure storage of authentication tokens.
*   **Offline Functionality:**
    *   Tasks are stored locally using a local database (e.g., SQLite).
    *   App can be used even without an internet connection.
*   **Manual Synchronization:**
    *   Users can manually trigger synchronization to update local data with the server and vice versa.
    *   Conflict resolution is implemented to handle data conflicts.
*   **Online/Offline Detection:**
    *   The app detects network connectivity and adapts its behavior accordingly.

## Technologies Used

*   Flutter
*   Dart
*   `dio` (for HTTP requests)
*   `json_serializable`, `json_annotation` (for JSON serialization)
*   `sqflite` (for local database)
*   `path_provider` (for file paths)
*   `connectivity_plus` (for network connectivity)
*   `flutter_secure_storage` (for secure storage)
*   `bloc`, `provider` (for state management)

## Prerequisites

*   Flutter SDK installed and configured.
*   A running instance of the Spring Boot backend API (see [Backend README](https://github.com/achidzix/taskmanagement.git) - *replace with the actual link*).

## Setup and Running

1.  **Clone the repository:**

    ```bash
    git clone [repository URL]
    ```

2.  **Navigate to the project directory:**

    ```bash
    cd [project directory]
    ```

3.  **Install dependencies:**

    ```bash
    flutter pub get
    ```

4.  **Configure API endpoints:**

    *   Open `lib/services/DomainService.dart` (or a similar configuration file) and set the base URL of your Spring Boot backend:

    ```dart
    class DomainService {
      static const String urlBase = 'YOUR_SPRING_BOOT_API_URL'; // e.g., 'http://10.0.2.2:8081' for local emulator
    }
    ```

5.  **Run the app:**

    ```bash
    flutter run
    ```

## App Architecture

The app follows a layered architecture:

*   **Data Models:** Represent the data structures (e.g., `Task`, `User`).
*   **Data Providers/Repositories:** Handle data access, including API calls and local database operations.
*   **Bloc/Provider/Riverpod (State Management):** Manages the app's state and business logic.
*   **UI Components:** Build the user interface.

## Synchronization Logic

The synchronization process involves the following steps:

1.  **Upload Local Changes:** Any locally created, updated, or deleted tasks are sent to the server.
2.  **Download Remote Updates:** The latest tasks from the server are fetched and the local database is updated.
3.  **Conflict Resolution:** If a task has been modified both locally and remotely, a conflict resolution strategy is applied (e.g., last write wins, merge, user prompt).

## Security

*   JWT is used for authentication.
*   The JWT token is stored securely using `flutter_secure_storage`.
*   HTTPS is recommended for all communication with the backend.

## Error Handling

The app includes error handling for network requests, database operations, and synchronization conflicts.

## Future Enhancements

*   Implement more sophisticated conflict resolution strategies.
*   Add background synchronization.
*   Implement push notifications for task updates.
*   Add unit and integration tests.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request.

## License

[MIT License](LICENSE) (or specify your license)
