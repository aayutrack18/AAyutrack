# AAYUTRACK — Authentication Module
### Member 3 | Authentication Team | Frontend UI Sprint

---

## 📁 File Structure

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_constants.dart      # All string constants, spacing, route names
│   │   └── app_router.dart         # Named route generator with transitions
│   └── theme/
│       └── app_theme.dart          # AppColors, AppTextStyles, AppTheme
│
├── features/
│   └── auth/
│       └── presentation/
│           ├── screens/
│           │   ├── welcome_screen.dart          # Hero welcome with features
│           │   ├── login_screen.dart            # Phone + country code input
│           │   └── otp_verification_screen.dart # 6-box OTP + resend timer
│           └── widgets/
│               └── auth_widgets.dart            # All reusable auth UI widgets
│
└── main.dart                        # Entry point + Splash gate
```

---

## 🚀 Screens

| Screen | File | Description |
|--------|------|-------------|
| Splash | `main.dart` → `_SplashGate` | Animated logo loader, auto-transitions |
| Welcome | `welcome_screen.dart` | Hero blue gradient, feature chips, CTA card |
| Login | `login_screen.dart` | Country picker, phone field, send OTP |
| OTP | `otp_verification_screen.dart` | 6-box input, resend timer, success flow |

---

## 🎨 Design System

### Colors (`AppColors`)
| Token | Hex | Usage |
|-------|-----|-------|
| `primary` | `#0A5FBF` | Buttons, borders, filled states |
| `primaryDark` | `#083E82` | Gradient dark stop |
| `accent` | `#00C6AE` | Success states, feature highlights |
| `background` | `#F4F7FB` | Scaffold background |
| `surface` | `#FFFFFF` | Cards, bottom sheets |
| `surfaceVariant` | `#EAF1FB` | Input fields, chips |

### Typography (`AppTextStyles`)
- **Font**: Nunito (via `google_fonts` package)
- `displayMedium` — Screen headings
- `headlineLarge` — Section titles
- `labelLarge` — Button text
- `bodyLarge` — Subtitles, hints

---

## 🧩 Reusable Widgets (`auth_widgets.dart`)

| Widget | Props | Use |
|--------|-------|-----|
| `AayuPrimaryButton` | label, onPressed, isLoading, icon | Primary CTA with press animation |
| `AayuBrandLogo` | dark, size | Logo + AAYUTRACK text |
| `SecureBadge` | label | Shield icon security indicator |
| `AuthSectionHeader` | title, subtitle | Screen heading block |
| `CountryCodeSelector` | flag, code, onTap | Country picker trigger |
| `InfoChip` | icon, text, color | Feature/compliance badge row |

---

## 🔗 Navigation Flow

```
_SplashGate (2s)
      ↓  pushReplacement (fade)
WelcomeScreen
      ↓  pushNamed('/login')  [slide right]
LoginScreen
      ↓  pushNamed('/otp', args: {phone})  [slide right]
OtpVerificationScreen
      ↓  TODO: pushReplacementNamed('/dashboard')
```

---

## ⚙️ Setup

```bash
# 1. Get dependencies
flutter pub get

# 2. Run on device / emulator
flutter run

# 3. Build APK (for hackathon demo)
flutter build apk --release
```

---

## 🔜 Backend Integration Points (Member 3 — Next Sprint)

When Firebase is ready, add implementation in:

```
features/auth/
├── data/
│   ├── repositories/   ← FirebaseAuthRepository
│   └── datasources/    ← FirebaseAuthRemoteDataSource
└── domain/
    ├── repositories/   ← AuthRepository (abstract)
    └── usecases/       ← SendOtpUseCase, VerifyOtpUseCase, GetCurrentUserUseCase
```

**Files to update:**
- `login_screen.dart` → Replace `Future.delayed` with `ref.read(sendOtpProvider)`
- `otp_verification_screen.dart` → Replace `Future.delayed` with `ref.read(verifyOtpProvider)`
- `main.dart` → Add `ProviderScope` wrapper + `FirebaseApp.initializeApp()`

---

## ✅ Hackathon Checklist

- [x] Splash screen with brand animation
- [x] Welcome screen with hero layout
- [x] Phone number input with country picker
- [x] 6-box OTP input with focus management
- [x] Resend timer (30s countdown)
- [x] Named route navigation with custom transitions
- [x] Reusable widget library
- [x] Design system (colors + typography)
- [ ] Firebase Auth (next sprint)
- [ ] Riverpod state management (next sprint)
- [ ] Session persistence (next sprint)