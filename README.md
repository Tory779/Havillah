# Havilah Ice Cream App (Frontend)

Flutter frontend for Havilah's online ice cream ordering app. Customers browse flavours, build an order and go through checkout. Multiple branches are planned. The UI follows the Figma designs.

**This repo is the frontend only.** There is no backend, no real authentication and no real payment processing yet. See "Where the backend plugs in" below.

## Status

Frontend is complete and has been tested on an Android phone. Only designer-requested changes remain. iOS/cross-platform testing and app store release have not been done.

## Screens

| Screen | Class | Notes |
|---|---|---|
| Login | `LoginScreen` | UI only. The Login button just navigates to `/loading`. Google/Facebook buttons are placeholders. |
| Loading / splash | `LoadingScreen` | Route `/loading`. "Choose your flavour" goes to `/`. |
| Home | `HomeScreen` | Shows the popular flavours. Cart icon opens `OrderReviewScreen`. |
| All flavours | `AllFlavours` | Grid of all 9 flavours. |
| Flavour detail | `FlavourDetailScreen` (`flavourdetail_screen.dart`) | Size, scoops, quantity, live total, Add to cart, favourite. |
| Cart / order review | `OrderReviewScreen` (`orderreview_screen.dart`) | Reads live from `CartProvider`. "Done" opens `PaymentScreen`. |
| Payment | `PaymentScreen` | UI only. Takes the order total through its `orderTotal` field. |
| Favourites | `FavoritesScreen` | Reads from `FavoritesProvider`. |
| Profile | `ProfileScreen` | Inside the bottom-nav shell. |

## Tech

- Flutter / Dart (exact package versions are in `pubspec.yaml`)
- `provider` for state management
- `go_router` for top-level navigation
- `google_fonts` (`GoogleFonts.baloo2`, font choice still pending Figma confirmation)

## Run it

```bash
flutter pub get
flutter run
```

## How the app is organised

**Navigation.** `go_router` is set up in `main.dart`. A `ShellRoute` wraps `/`, `/favorites` and `/profile` in a persistent scaffold with the bottom navigation bar. `/login` and `/loading` are top-level routes outside the shell. `AllFlavours`, `OrderReviewScreen` and `PaymentScreen` use plain `Navigator.push` on purpose, so they sit on top of the shell without the bottom nav bar.

**State.** `CartProvider` and `FavoritesProvider` (both `ChangeNotifier`s) are registered in `main.dart` with `MultiProvider`.

- `CartProvider` holds the cart lines, plus `subtotal` / `total` getters. Each cart line stores its already-computed price (unit price x quantity), and `subtotal` sums those prices.
- `FavoritesProvider` holds favourited flavours (name, description, image, badge colour). It is held in memory only and is not synced anywhere.

**Flavour data.** A `Flavour` class (name, description, imageUrl, badgeColor, isPopular) and one `const List<Flavour> allFlavours`. Adding a flavour means adding one entry to that list.

## Pricing rules (currently calculated inside the app)

| Tub | Base price | Scoops allowed |
|---|---|---|
| Small | ₦0 | 1 to 2 |
| Medium | ₦500 | 1 to 3 |
| Large | ₦700 | 4 to 6 |

- Every scoop costs ₦2,500, whatever the tub size.
- Line total = (tub base + scoops x 2,500) x quantity.
- The delivery fee is calculated in `OrderReviewScreen` (`_deliveryFee`).

**Backend note:** the server must recalculate prices itself when an order comes in. Never trust totals sent from the app.

## Where the backend plugs in

| Area | Where in the code | Today | Needs |
|---|---|---|---|
| Login | `LoginScreen` | Navigates to `/loading`, no auth | Real authentication and token storage. `HomeScreen`'s cart icon also builds a hardcoded `'Guest'` `UserProfile` that should become the real user. |
| Flavours | `allFlavours` | Hardcoded list | Fetch from the API |
| Cart | `CartProvider` | In memory | Validate against server prices at checkout (a server-side cart is optional) |
| Checkout | `PaymentScreen`, "Pay Now" | UI only | Create the order, start the payment, handle the result. Note that `OrderReviewScreen`'s "Done" button only navigates to `PaymentScreen`. |
| Favourites | `FavoritesProvider` | In memory | Sync per user |
| Branches | not built | none | Branch selection UI and data (needs design) |

A suggested approach: add a small API/service layer and call it from the providers, so the screens themselves barely need to change.

## Payments

The card form in `PaymentScreen` is UI only. Use a PCI-DSS compliant gateway (for example Paystack or Flutterwave) with card tokenization for the actual charge. Raw card numbers must never reach Havilah's own backend or database. The card-brand icons (Visa / Mastercard / Verve) are generic placeholders.

## Known gaps

- Real image URLs exist only for Strawberry, Cotton Candy and Oreos. The other six flavours (Chocolate, Vanilla, Caramel, Coconut, Cookies & Cream, Choco Chips) show a placeholder icon.
- Font choice (`baloo2`) is pending confirmation from the designer.
- Android phone testing only. iOS and release builds are not done.

## Working on this repo

- Branch off `main` for any new work and open a pull request instead of pushing straight to `main`.
- UI changes should go through the frontend developer (Oluoma), since the screens follow the designer's Figma.
- A proposed API contract is in [`API_SPEC.md`](API_SPEC.md).
