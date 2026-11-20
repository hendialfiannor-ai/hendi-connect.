# Hendi Connect — Foundation Build 1.0

Flutter starter project untuk aplikasi komunikasi Hendi Connect.

## Isi build ini

- Splash / welcome screen
- Form registrasi dan login demo
- Intro / welcome screen
- Navigasi Chat, Status, Community, Calls, Settings
- Tampilan awal AI Chat, AI Ejen, Chat Owner, Chat Admin
- Toggle Mode Bisnis, Mode Ketat, Auto Reply
- Pilihan tema hijau, merah, biru, ungu, gold

## Penting

Ini adalah **Foundation UI build**, bukan aplikasi chat produksi.
Autentikasi, backend, realtime messaging, E2EE, panggilan WebRTC/LiveKit,
push notification, backup, multi-device, AI API, dan Owner API belum
dihubungkan. Jangan gunakan password/PIN asli pada formulir demo.

## Build APK

Dari root proyek (folder yang berisi `pubspec.yaml`):

```bash
flutter pub get
flutter create --platforms=android .
flutter build apk --release
```

APK biasanya berada di:

`build/app/outputs/flutter-apk/app-release.apk`

## Telegram build bot

ZIP ini memiliki `pubspec.yaml` di root proyek. Upload ZIP ke bot Telegram,
lalu reply file ZIP tersebut dengan:

`/buildapk`

Jika bot mengharuskan struktur Android sudah tersedia sebelum build,
workflow perlu menjalankan `flutter create --platforms=android .`
sebelum `flutter build apk --release`.
