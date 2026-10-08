# Havilah Ice Cream App — Frontend

## What's included
- Complete UI for all 9 flavors, cart, orders, payment form
- State management via `CartProvider` and `FavoritesProvider`
- Navigation via `go_router` (shell) + `Navigator.push` (detail screens)
- All screens tested on Android device

## What's NOT included
- Backend API
- Real payment processing (form is UI-only)
- Multi-branch order routing

## API Integration Points

### 1. Login (`lib/screens/login_screen.dart`)
- Currently hardcoded; needs to call `POST /api/auth/login`
- Send: `{ email, password }`
- Expect: `{ userId, token, userProfile }`
- Store token in secure storage (flutter_secure_storage)

### 2. Add to Cart (`lib/providers/cart_provider.dart`)
- `addItem(flavor, size, scoops, quantity)` — currently local only
- Needs to POST to `POST /api/cart/add` when user confirms

### 3. Checkout (`lib/screens/orderreview_screen.dart`)
- "Done" button needs to POST cart to `POST /api/orders`
- Send: `{ userId, cartItems[], deliveryBranch, address }`
- Expect: `{ orderId, estimatedTime }`

### 4. Favorites (`lib/providers/favorites_provider.dart`)
- `toggleFavorite()` needs to sync with `POST /api/favorites/toggle`

## Setup

```bash
flutter pub get
flutter run
```

## Tech Stack
- Flutter/Dart
- Provider (state management)
- go_router (navigation)
