# UA Air Alerts

Real-time air raid alerts monitoring for Ukraine.

## Features

- **Alerts Map** — interactive map of Ukraine showing active air raid alerts by region with color-coded overlays
- **Region Alerts** — check alert status for any specific region with animated UI feedback
- **Auto-detect location** — automatically determines your region using GPS
- **Background monitoring** — tracks your saved region and sends push notifications with alarm sound when an alert becomes active
- **Bilingual** — full support for Ukrainian and English languages
- **Offline-friendly** — response caching to minimize network usage and respect API rate limits

## Tech Stack

- Flutter 3.41+
- BLoC (Cubit) for state management
- go_router for navigation
- flutter_local_notifications + workmanager for background alerts
- flutter_cache_manager for API response caching
- geolocator + geocoding for location detection
- json_serializable for type-safe API parsing
- flutter_dotenv for secure token management

## Getting Started

1. Clone the repository
2. Create `.env` file in the root:
   ```
   API_TOKEN=your_api_token_here
   ```
3. Run:
   ```bash
   flutter pub get
   dart run build_runner build
   flutter run
   ```

## API

This app uses the [alerts.in.ua API](https://devs.alerts.in.ua/) for real-time air raid alert data.

## License

MIT
