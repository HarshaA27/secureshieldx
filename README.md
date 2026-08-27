# SecureShield X - Mobile Cybersecurity & AI Threat Shield

A modern Flutter cybersecurity application providing real-time malware scanning, permission auditing, cyber fraud incident reporting, and AI-powered risk explanations for scanned applications.

---

## 🔒 LLM API Integration & Secure API Key Setup

SecureShield X generates real-time contextual security risk explanations for scanned applications using an HTTP REST API connection to LLMs (Google Gemini API or OpenAI API).

### How to set your API Key securely (NEVER hardcode keys in git):

#### Method 1: Local `.env` File (Recommended for Development)
1. Copy `.env.example` to `.env` in your project root:
   ```bash
   cp .env.example .env
   ```
2. Open `.env` and set your LLM API Key:
   ```env
   LLM_API_KEY=your_actual_gemini_or_openai_api_key
   LLM_API_PROVIDER=gemini
   LLM_MODEL=gemini-1.5-flash
   ```
3. Note: `.env` is automatically ignored in `.gitignore` so your API key will never be committed to repository history.

#### Method 2: `--dart-define` Flag (Recommended for CI/CD & Production Builds)
Pass your API key as a compile-time argument when running or building the app:
```bash
flutter run --dart-define=LLM_API_KEY=your_actual_api_key
flutter build apk --dart-define=LLM_API_KEY=your_actual_api_key
```

#### Method 3: In-App Settings Tester
Navigate to **Settings -> Scanner Sensitivity & Engines (LLM API)** in the app to enter a key and test the live HTTP connection.

---

## 🚀 Getting Started

1. Install dependencies:
   ```bash
   flutter pub get
   ```
2. Run the application:
   ```bash
   flutter run
   ```
