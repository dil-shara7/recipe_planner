# MealMate – Recipe & Meal Planner

**Better Meals. Happier You.**

MealMate is a mobile app built with **Flutter** that helps users browse recipes, plan their meals for the week and build a shopping list automatically. The repository also contains a **Spring Boot + PostgreSQL** backend with **JWT** authentication and **Google sign-in**.

## Screenshots

<table>
  <tr>
    <th align="center" width="33%">Login</th>
    <th align="center" width="33%">Recipes</th>
    <th align="center" width="33%">Recipe details</th>
  </tr>
  <tr>
    <td align="center"><img src="screenshots/login.png" width="250" alt="Login"></td>
    <td align="center"><img src="screenshots/recipes.png" width="250" alt="Recipes"></td>
    <td align="center"><img src="screenshots/details.png" width="250" alt="Recipe details"></td>
  </tr>
  <tr>
    <th align="center">Meal plan</th>
    <th align="center">Favorites</th>
    <th align="center">Shopping list</th>
  </tr>
  <tr>
    <td align="center"><img src="screenshots/meal_plan.png" width="250" alt="Meal plan"></td>
    <td align="center"><img src="screenshots/favorites.png" width="250" alt="Favorites"></td>
    <td align="center"><img src="screenshots/shopping.png" width="250" alt="Shopping list"></td>
  </tr>
</table>

## Features

**App**
- Splash screen, register and login with password rules (at least 5 characters, a lowercase letter and a number)
- Google sign-in
- 19 built-in recipes with photos (Breakfast, Lunch, Dinner, Snacks)
- Search and category filter
- Recipe details with ingredients and numbered steps
- Add your own recipes and delete them again
- Favorites with a heart icon
- Weekly meal planner with Breakfast, Lunch, Dinner and Snacks slots
- Shopping list built from the week's meal plan, with matching ingredients added together, manual items and a progress bar
- Favorites, meal plan, shopping items and your own recipes are saved on the phone for each account
- Custom app icon and name

**Backend**
- REST API for recipes (create, read, update, delete)
- User registration and login with BCrypt password hashing
- JWT tokens issued by the server
- Google sign-in: the server verifies Google's ID token, creates the user and issues its own JWT
- PostgreSQL storage with Spring Data JPA

**Offline behaviour**
The app tries the backend first. If the server cannot be reached, login and registration fall back to an account stored on the phone (password kept as a SHA-256 hash), so the app also works when it is not connected to the backend.

## Tech stack

| Part | Technology |
|---|---|
| Mobile app | Flutter, Dart |
| Local storage | shared_preferences, crypto |
| Authentication | JWT (jjwt), BCrypt, Google Sign-In (OAuth 2.0) |
| Backend | Java 21, Spring Boot, Spring Data JPA |
| Database | PostgreSQL |
| Tools | Git, GitHub, VS Code |

## Project structure

```
recipe_planner/
  lib/
    data/        recipes, meal plan and shopping data
    models/      Recipe and Ingredient
    screens/     all app screens
    services/    auth, API and storage services
    widgets/     reusable widgets
  assets/
    images/      recipe photos
    icon/        app icon
  recipe-backend/   Spring Boot API (recipes, users, JWT, Google)
  test/             unit test
```

## API

| Method | Endpoint | Purpose |
|---|---|---|
| GET | `/recipes` | List all recipes |
| GET | `/recipes/{id}` | Get one recipe |
| POST | `/recipes` | Add a recipe |
| PUT | `/recipes/{id}` | Update a recipe |
| DELETE | `/recipes/{id}` | Delete a recipe |
| POST | `/auth/register` | Create an account, returns a JWT |
| POST | `/auth/login` | Log in, returns a JWT |
| POST | `/auth/google` | Verify a Google ID token, returns a JWT |
| GET | `/auth/me` | Current user (needs `Authorization: Bearer <token>`) |

## Run the backend

1. Install JDK 21 and PostgreSQL, then create a database named `recipe_db`.
2. In `recipe-backend`, create a file named `local.properties` (it is ignored by Git):

```
spring.datasource.password=your_database_password
app.jwt.secret=a-long-random-text-of-at-least-32-characters
app.google.client-id=your-web-client-id.apps.googleusercontent.com
```

3. Start the server:

```
cd recipe-backend
./mvnw spring-boot:run
```

The API runs at `http://localhost:8080`.

## Run the Flutter app

1. Install Flutter and the Android SDK.
2. Connect an Android phone with USB debugging on.
3. Forward the port so the phone can reach the backend on your PC:

```
adb reverse tcp:8080 tcp:8080
```

4. In the project folder:

```
flutter pub get
flutter run
```

For a standalone build that works without the cable:

```
flutter run --release
```

To create an installable APK:

```
flutter build apk --release
```

The file is created at `build/app/outputs/flutter-apk/app-release.apk`.

### Google sign-in setup

1. Create a project in Google Cloud and configure the OAuth consent screen.
2. Create an **Android** OAuth client (package name and SHA-1 of your signing key) and a **Web application** client.
3. Put the Web client ID in `lib/services/auth_service.dart` (`kGoogleWebClientId`) and in `recipe-backend/local.properties` (`app.google.client-id`).

## Tests

```
flutter test
```