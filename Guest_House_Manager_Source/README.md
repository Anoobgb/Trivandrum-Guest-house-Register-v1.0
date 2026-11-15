# Guest House Manager — Web + Android-ready PWA

A responsive booking dashboard that can be installed on Android and used in desktop/mobile browsers. It uses Supabase as the shared online database.

## Features
- Dashboard with current-month bookings, room-nights, current occupants and today's checkout alerts
- Booking register with search, month/year filters and sorting
- Protected new booking, checkout and Excel export (passcode `0007`)
- Month-wise, date-wise and year-wise reports
- Excel `.xlsx` export
- PWA install support and an Android wrapper path using Capacitor

## Important security note
The requested `0007` passcode is currently a client-side convenience gate, not strong security. Anyone who can inspect the website source can discover it. The Supabase SQL uses authenticated-user policies, so **do not publish guest data until Supabase Auth is configured and the app is updated to sign staff in**. For production, enforce passcode/role checks on a server-side Edge Function and use individual staff accounts. Never put a Supabase service-role key in browser code.

## 1. Create the shared database
1. Create a project at https://supabase.com.
2. Open SQL Editor and run `supabase-schema.sql`.
3. In Authentication, create accounts for staff who are allowed to use the app.
4. Copy `config.example.js` to `config.js`, then enter your Supabase Project URL and anon/public key.
5. Deploy the folder to an HTTPS static host (for example Netlify, Vercel, or GitHub Pages). Include `config.js` in the deployed files.
6. The app includes an email/password sign-in screen using Supabase Auth. Create staff accounts in Supabase Authentication before use; the schema intentionally denies anonymous access.

## 2. Android installation
The web app is a PWA: open the deployed HTTPS URL in Chrome on Android and choose **Install app** / **Add to Home screen**.

For a standalone APK, wrap this same web app with Capacitor:
```bash
npm create @capacitor/app@latest
# Set the webDir to the deployed/build output containing index.html
npm install @capacitor/android
npx cap add android
npx cap sync android
npx cap open android
```
Build a signed APK from Android Studio. The APK and web app use the same Supabase project, so records sync between devices.

## 3. Local preview
Serve this folder from a local web server (not file://):
```bash
python3 -m http.server 8080
```
Then open http://localhost:8080. Without `config.js`, the interface displays setup required and will not save records.

## Booking rules
- Checkout date must be after check-in date.
- Room-overlap warnings are shown before saving, but the user can override them.
- Room numbers can be entered as comma-separated values.
- The day count is the number of nights between check-in and checkout.
