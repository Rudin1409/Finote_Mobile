# ANDROID MIGRATION BLUEPRINT: Finote Mobile

**Status:** READY FOR MIGRATION
**Source Project:** Flutter (Finote_Mobile)
**Target Project:** Native Android (Kotlin + Jetpack Compose)

## 1. Introduction
This document serves as the **primary source of truth** for the AI agent tasked with rebuilding the "Finote Mobile" application in Native Android. It contains all necessary context, architectural decisions, and feature specifications derived from the original Flutter codebase.

**INSTRUCTION TO AI:**
If you are reading this file in a new Android Studio project, your goal is to reconstruct the application described below using **Kotlin** and **Jetpack Compose**. Do not ask for the old Flutter code unless absolutely necessary; use this blueprint as your specification.

## 2. Tech Stack & Architecture

| Component | Flutter (Old) | Android Native (New) |
| :--- | :--- | :--- |
| **Language** | Dart | **Kotlin** |
| **UI Framework** | Flutter Widgets | **Jetpack Compose** (Material 3) |
| **Architecture** | Provider / MVC | **MVVM** (Model-View-ViewModel) |
| **DI** | (Implicit/Provider) | **Hilt** (Recommended) or Koin |
| **Async** | Future / Stream | **Coroutines / Flow** |
| **Navigation** | Navigator / GoRouter | **Jetpack Navigation Compose** |
| **Network** | http / dio | **Retrofit + OkHttp** |
| **Local DB** | (None/Hive/Sqflite?) | **Room Database** (if needed) |
| **Charts** | fl_chart | **Vico** or **MPAndroidChart** |

### Recommended Project Structure (Clean Architecture)
```text
app/src/main/java/com/example/finote
├── core/
│   ├── di/              # Hilt Modules
│   ├── network/         # Retrofit setup
│   ├── theme/           # Type, Color, Shape (Material 3)
│   └── util/            # Extensions, Result wrappers
├── data/
│   ├── local/           # Room DAO, Entities
│   ├── remote/          # API Services, DTOs
│   └── repository/      # Repository Implementations
├── domain/
│   ├── model/           # Domain Data Classes
│   ├── repository/      # Repository Interfaces
│   └── usecase/         # Business Logic
└── presentation/
    ├── MainActivity.kt
    ├── navigation/      # NavHost, Screen Routes
    ├── components/      # Reusable Composables (Buttons, Inputs)
    ├── theme/           # Theme.kt
    └── features/
        ├── auth/        # LoginScreen, RegisterScreen, AuthViewModel
        ├── home/        # HomeScreen, HomeViewModel
        ├── transaction/ # AddTransactionScreen, TransactionViewModel
        └── analysis/    # AiAnalysisScreen, AnalysisViewModel
```

## 3. Feature Specifications

### A. Authentication (`features/auth`)
*   **Functionality:** User Login and Registration.
*   **Backend:** Firebase Authentication (Email/Password, Google Sign-In).
*   **UI:**
    *   Login Screen: Email field, Password field, "Login" button, "Register" link, Google Sign-In button.
    *   Register Screen: Name, Email, Password, Confirm Password.
*   **Logic:** Use `FirebaseAuth` instance. Handle success/error states using `Result<T>` sealed class.

### B. Home Dashboard (`features/home`)
*   **Functionality:** Overview of financial status.
*   **UI Elements:**
    *   **Summary Cards:** Total Balance, Income, Expense.
    *   **Chart:** Line chart or Bar chart showing spending trends (Use Vico/MPAndroidChart).
    *   **Recent Transactions:** List of last 5 transactions.
    *   **Floating Action Button (FAB):** To add new transaction.

### C. Transactions (`features/income`, `features/expense`, `features/debt`, `features/savings`)
*   **Functionality:** CRUD (Create, Read, Update, Delete) for financial records.
*   **Data Model:**
    ```kotlin
    data class Transaction(
        val id: String,
        val type: TransactionType, // INCOME, EXPENSE, DEBT, SAVING
        val amount: Double,
        val category: String,
        val source: String, // 'cash', 'bank', 'digital-wallet'
        val date: Long,
        val description: String?
    )
    ```
*   **Backend:** Cloud Firestore. Collection: `users/{userId}/transactions`.

### D. AI Analysis (`features/ai_analysis`)
*   **Functionality:** AI-powered financial advice.
*   **Integration:** Gemini API (via `google_generative_ai` SDK for Android).
*   **UI:** Chat interface or Report view. Input: User's transaction data. Output: Text advice.

### E. Settings (`features/settings`)
*   **Functionality:** Theme toggle, Profile management, Logout.

## 4. Dependencies (build.gradle.kts)
You will need to add these dependencies:

```kotlin
// Firebase
implementation(platform("com.google.firebase:firebase-bom:32.x.x"))
implementation("com.google.firebase:firebase-analytics")
implementation("com.google.firebase:firebase-auth")
implementation("com.google.firebase:firebase-firestore")

// Jetpack Compose
implementation(platform("androidx.compose:compose-bom:2024.02.00"))
implementation("androidx.compose.ui:ui")
implementation("androidx.compose.material3:material3")
implementation("androidx.navigation:navigation-compose:2.7.7")

// Hilt (Dependency Injection)
implementation("com.google.dagger:hilt-android:2.50")
kapt("com.google.dagger:hilt-android-compiler:2.50")

// Coroutines
implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.7.3")

// Charts (Example: Vico)
implementation("com.patrykandpatrick.vico:compose-m3:1.14.0")

// Google Generative AI (Gemini)
implementation("com.google.ai.client.generativeai:generativeai:0.2.0")
```

## 5. Detailed Screen Specifications (CRITICAL FOR REBUILD)

### 5.1 Login Screen (`LoginScreen.kt`)
*   **UI Components:**
    *   `Text`: "Welcome Back!", "Login to your account to continue."
    *   `TextField`: Email (Hint: "Enter your email").
    *   `TextField`: Password (Hint: "Enter your password", with visibility toggle).
    *   `TextButton`: "Forgot Password?" (Navigates to ForgotPasswordScreen).
    *   `Button`: "LOGIN" (Primary color: `#37C8C3`).
    *   `Row`: "Don't have an account?" + "Sign Up" (Navigates to SignUpScreen).
*   **Logic:**
    *   Call `FirebaseAuth.signInWithEmailAndPassword`.
    *   **Check `user.isEmailVerified`**. If false, sign out and show Dialog: "Email Belum Terverifikasi".
    *   If verified, navigate to `MainScreen`.

### 5.2 Sign Up Screen (`SignUpScreen.kt`)
*   **UI Components:**
    *   `Text`: "Register", "Buat akun untuk mulai..."
    *   `TextField`: Name (Icon: Person).
    *   `TextField`: Email (Icon: Email).
    *   `TextField`: Password (Icon: Lock, Obscure).
    *   `Button`: "DAFTAR".
*   **Logic:**
    *   Call `FirebaseAuth.createUserWithEmailAndPassword`.
    *   Call `user.updateProfile(displayName = name)`.
    *   **Firestore:** Create document in `users/{uid}` with fields: `uid`, `email`, `displayName`, `createdAt`.
    *   Call `user.sendEmailVerification()`.
    *   Show Dialog: "Link verifikasi telah dikirim...". Navigate to Login on OK.

### 5.3 Income/Transaction Screen (`IncomeScreen.kt`)
*   **UI Components:**
    *   **Carousel (PageView):** 3 Cards.
        1.  **Tunai (Cash):** Green color.
        2.  **Bank:** Teal color (`#45C8B4`). Shows masked card number `**** **** **** ****`.
        3.  **Dompet Digital:** Purple color.
    *   **Switch:** Toggle balance visibility (`Rp ****` vs actual amount).
    *   **List:** "RIWAYAT PEMASUKAN". Shows transactions where `type == 'income'`.
    *   **FAB:** "+" button to open `AddIncomeForm`.
*   **Logic (Calculation):**
    *   Fetch all transactions from Firestore.
    *   Loop through transactions to calculate totals for each source:
        *   If `source == 'cash'`, add to Tunai.
        *   If `source == 'bank'`, add to Bank.
        *   If `source == 'digital-wallet'`, add to Dompet Digital.
*   **Add Transaction Form (BottomSheet):**
    *   Fields: Amount (Number), Description (Text), Category (Dropdown), Source (Dropdown: Tunai, Bank, E-Wallet), Date (DatePicker).
    *   Save to Firestore: `users/{uid}/transactions`.

### 5.4 Financial Report Screen (`FinancialReportScreen.kt`)
*   **UI Components:**
    *   **Period Selector:** 3 Tabs (Harian, Bulanan, Tahunan).
    *   **Summary Cards:** Total Income (Green), Total Expense (Red).
    *   **Button:** "ANALISIS DENGAN AI" (Icon: `auto_awesome`).
    *   **Chart:** Bar Chart showing Income vs Expense per unit (Day/Week/Month).
*   **Logic:**
    *   **Filtering:** Filter transactions based on selected period (This Week, This Month, This Year).
    *   **AI Analysis:**
        *   **Current Flutter Logic:** Uses rule-based `if/else` (e.g., `if income > expense`).
        *   **NEW ANDROID LOGIC (Upgrade):** Use **Gemini API**. Send the transaction summary (Total Income, Total Expense, Top Categories) to Gemini and ask for financial advice. Display the result in a Dialog.

### 5.5 Settings Screen (`SettingsScreen.kt`)
*   **UI Components:**
    *   **Profile Header:** CircleAvatar, Name, Email (from `FirebaseAuth.currentUser`).
    *   **Menu List:**
        *   Edit Profile (Opens BottomSheet).
        *   Ubah Password.
        *   Hapus Akun.
    *   **Logout Button:** Red text/icon.
*   **Logic:**
    *   Logout: `FirebaseAuth.signOut()`, navigate to Login.

## 6. Migration Steps for the AI

1.  **Initialize Project:** Create a new "Empty Activity" project in Android Studio. Select **Kotlin** and **Build Configuration Language: Kotlin DSL**.
2.  **Setup Dependencies:** Copy the dependencies listed above into `app/build.gradle.kts`. Sync Gradle.
3.  **Setup Firebase:** Connect the app to the existing Firebase project (download `google-services.json`).
4.  **Create Core Structure:** Set up the package structure (`core`, `data`, `domain`, `presentation`).
5.  **Implement Theme:** Configure `Theme.kt` to match the Finote brand colors.
6.  **Build Auth:** Implement Login/Register screens and connect to Firebase Auth.
7.  **Build Home:** Implement the Dashboard UI.
8.  **Iterate:** Continue with Transactions and AI features.

---
**End of Blueprint**
