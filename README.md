
============================================================
         TAGHYEER SHOP — Flutter Technical Assignment
         Taghyeer Technologies
============================================================

OVERVIEW
--------
Taghyeer Shop is a production-quality Flutter mobile application
built using Clean Architecture, GetX (MVVM), and the DummyJSON
open API. It covers all requirements from the technical assignment
including authentication, pagination, caching, theme management,
and error handling.


------------------------------------------------------------
TECH STACK
------------------------------------------------------------
- Flutter (Dart)
- State Management  : GetX (MVVM pattern)
- HTTP Client       : Dio (with interceptors)
- Local Storage     : SharedPreferences
- Image Caching     : cached_network_image
- Architecture      : Clean Architecture (Provider > Repository > Controller > View)


------------------------------------------------------------
DEPENDENCIES (pubspec.yaml)
------------------------------------------------------------
  get: ^4.6.6
  dio: ^5.4.0
  shared_preferences: ^2.2.2
  cached_network_image: ^3.3.1
  connectivity_plus: ^5.0.2


------------------------------------------------------------
HOW TO RUN
------------------------------------------------------------
1. Copy the extracted lib/ folder and pubspec.yaml into your
   Flutter project root (e.g. D:\office\taghyeer\)

2. Install dependencies:
     flutter pub get

3. Run the app:
     flutter run

   Or run on a specific device:
     flutter run -d <device_id>

   To see available devices:
     flutter devices


------------------------------------------------------------
LOGIN CREDENTIALS (DummyJSON Demo)
------------------------------------------------------------
  Username : emilys
  Password : emilyspass

These are pre-filled as a hint on the login screen.
The app hits: POST https://dummyjson.com/auth/login


------------------------------------------------------------
FOLDER STRUCTURE
------------------------------------------------------------
lib/
├── main.dart                        → App entry point, theme + session init
│
├── core/
│   ├── constants/
│   │   ├── api_endpoints.dart       → All API URL constants
│   │   └── app_constants.dart       → Storage keys, pagination limit
│   ├── network/
│   │   └── dio_client.dart          → Dio singleton, auth + log interceptors
│   ├── theme/
│   │   └── app_theme.dart           → Light & Dark ThemeData
│   └── utils/
│       └── storage_service.dart     → SharedPreferences wrapper
│
├── data/
│   ├── models/
│   │   ├── user_model.dart
│   │   ├── product_model.dart
│   │   └── post_model.dart
│   ├── providers/                   → Raw Dio API calls
│   │   ├── auth_provider.dart
│   │   ├── product_provider.dart
│   │   └── post_provider.dart
│   └── repositories/                → Business logic + error handling
│       ├── auth_repository.dart
│       ├── product_repository.dart
│       └── post_repository.dart
│
├── modules/
│   ├── auth/
│   │   ├── bindings/auth_binding.dart
│   │   ├── controllers/auth_controller.dart
│   │   └── views/login_view.dart
│   ├── home/
│   │   ├── bindings/home_binding.dart
│   │   ├── controllers/home_controller.dart
│   │   └── views/home_view.dart       → Bottom navigation shell
│   ├── products/
│   │   ├── bindings/product_binding.dart
│   │   ├── controllers/product_controller.dart
│   │   └── views/
│   │       ├── products_view.dart      → Paginated product list
│   │       └── product_detail_view.dart
│   ├── posts/
│   │   ├── bindings/post_binding.dart
│   │   ├── controllers/post_controller.dart
│   │   └── views/
│   │       ├── posts_view.dart         → Paginated posts list
│   │       └── post_detail_view.dart
│   └── settings/
│       ├── bindings/settings_binding.dart
│       ├── controllers/settings_controller.dart
│       └── views/settings_view.dart    → User info, theme toggle, logout
│
├── routes/
│   ├── app_routes.dart              → Route name constants
│   └── app_pages.dart               → GetPage route definitions
│
└── widgets/
    ├── app_loading_widget.dart      → Reusable loading state
    ├── app_error_widget.dart        → Reusable error state with retry
    └── app_empty_widget.dart        → Reusable empty state


------------------------------------------------------------
FEATURES IMPLEMENTED
------------------------------------------------------------

[AUTH]
  ✔ Login screen with username & password fields
  ✔ Form validation (empty fields, min length)
  ✔ Loading indicator during login request
  ✔ Error message displayed on failed login
  ✔ Demo credentials hint on login screen
  ✔ Token + user data saved to SharedPreferences on success
  ✔ Auto-login on app restart if session exists
  ✔ 401 response auto-redirects to login screen
  ✔ Logout clears all cached session data

[BOTTOM NAVIGATION]
  ✔ 3 tabs: Products, Posts, Settings
  ✔ IndexedStack preserves tab state
  ✔ Active/inactive icon states

[PRODUCTS TAB]
  ✔ Product list with thumbnail, title, price, rating, category
  ✔ Infinite scroll pagination (skip = 0, 10, 20...)
  ✔ Pagination loading indicator at list bottom
  ✔ Pull-to-refresh
  ✔ Loading / Error / Empty states
  ✔ Retry button on error
  ✔ Snackbar with retry on pagination failure
  ✔ Product detail screen (BONUS)
      - Full image, gallery strip
      - Title, brand, category, rating
      - Price with discount %, stock count

[POSTS TAB]
  ✔ Post list with title, body preview, tags, reactions, views
  ✔ Infinite scroll pagination (skip = 0, 10, 20...)
  ✔ Pagination loading indicator at list bottom
  ✔ Pull-to-refresh
  ✔ Loading / Error / Empty states
  ✔ Retry button on error
  ✔ Post detail screen (BONUS)
      - Full body text
      - Tags, likes, dislikes, views stats

[SETTINGS TAB]
  ✔ User profile card (avatar, full name, username, email)
  ✔ Avatar loaded from cached user image URL
  ✔ Fallback initials avatar if image unavailable
  ✔ Dark / Light mode toggle switch
  ✔ Theme persists across app restarts
  ✔ Logout button with confirmation dialog
  ✔ Logout clears cache and redirects to login

[ERROR HANDLING]
  ✔ No internet connection → clear message shown
  ✔ Connection/receive timeout → user-friendly message
  ✔ 400 / 401 / 403 / 404 / 500 → mapped error messages
  ✔ Empty API response → empty state widget shown
  ✔ Pagination failure → snackbar with retry option
  ✔ Image load failure → fallback icon shown

[THEME]
  ✔ Full Light theme (white cards, blue primary)
  ✔ Full Dark theme (dark navy backgrounds)
  ✔ Theme persists using SharedPreferences
  ✔ Instant theme switch without app restart


------------------------------------------------------------
API ENDPOINTS USED
------------------------------------------------------------
  POST  https://dummyjson.com/auth/login
  GET   https://dummyjson.com/products?limit=10&skip=0
  GET   https://dummyjson.com/products/:id
  GET   https://dummyjson.com/posts?limit=10&skip=0
  GET   https://dummyjson.com/posts/:id


------------------------------------------------------------
NOTES
------------------------------------------------------------
- No API key is required (DummyJSON is open)
- The app targets Android & iOS
- Minimum Flutter SDK: 3.0.0
- All images are cached automatically via cached_network_image
- The Dio client is a singleton — no duplicate instances
- Each module has its own Binding for lazy dependency injection


============================================================
                    END OF README
============================================================
