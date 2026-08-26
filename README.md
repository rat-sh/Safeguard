# SafeLPG - IoT LPG Monitoring & AI Safety System

SafeLPG is a safety-first IoT system designed to monitor Liquefied Petroleum Gas (LPG) levels, detect leaks in real-time, predict cylinder usage, and alert users via a companion mobile application.

---

## 🛠 System Architecture

```
  ┌──────────────┐
  │  ESP32 Node  │ (MQ-2 Gas, Temperature, PIR Motion, Reed Switch, Buzzer/Relay)
  └──────┬───────┘
         │ (HTTP POST + X-Device-API-Key)
         ▼
  ┌──────────────┐
  │ FastAPI Host │ (Runs AI Anomaly Detection, Rule validation)
  └──────┬───────┘
         │ (Supabase Service Role client)
         ▼
  ┌──────────────┐
  │   Supabase   │ (Postgres DB tables, RLS Policies, Realtime Publication)
  └──────┬───────┘
         │ (WebSockets Realtime Streams & REST API calls)
         ▼
  ┌──────────────┐
  │ Flutter App  │ (State Management via Riverpod, Dynamic Dashboard & History)
  └──────────────┘
```

---

## 📂 Project Structure

- **`safelpg_backend/`**: FastAPI REST API, database services, and AI anomaly detection logic.
- **`safelpg_flutter/`**: Riverpod-managed Flutter companion application showing live telemetry and historical trends.
- **`safelpg_backend/schema.sql`**: Database structure, trigger logic, indexes, and RLS policies for Supabase.

---

## ⚙️ Initial Setup

### 1. Database Setup (Supabase)
1. Create a new project in [Supabase](https://supabase.com).
2. Go to **SQL Editor** -> **New Query**.
3. Copy and paste the contents of `safelpg_backend/schema.sql`.
4. Click **Run** to set up tables (`devices`, `sensor_readings`, `alerts`), indexes, automatic triggers, and RLS policies.

### 2. Backend Setup (FastAPI)
Navigate to the backend directory:
```bash
cd safelpg_backend
```

Create a `.env` file in the root of `safelpg_backend/` containing:
```env
SUPABASE_URL=https://<your-project-ref>.supabase.co
SUPABASE_ANON_KEY=<your-anon-key>
SUPABASE_SERVICE_ROLE_KEY=<your-service-role-key>
DEVICE_API_KEY=<your-esp32-auth-key>
```

Initialize your virtual environment and install dependencies:
```bash
python -m venv venv
source venv/bin/activate  # On Windows use: venv\Scripts\activate
pip install -r requirements.txt
```

Start the local server:
```bash
uvicorn app.main:app --reload
```
API Documentation will be available at: `http://127.0.0.1:8000/docs`

### 3. Frontend Setup (Flutter)
Navigate to the Flutter app directory:
```bash
cd safelpg_flutter
```

To ensure security, **no credentials or API keys are hardcoded in the codebase**. They are injected at compile time. 

Fetch dependencies:
```bash
flutter pub get
```

Run the application on your simulator/device:
```bash
flutter run \
  --dart-define=SUPABASE_URL=https://<your-project-ref>.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=<your-anon-key> \
  --dart-define=FASTAPI_BASE_URL=http://<your-fastapi-server-ip>:8000 \
  --dart-define=DEVICE_ID=<your-registered-device-uuid>
```

---

## 🔒 Security Policies (RLS)
The database enforces strict Row-Level Security:
- **IoT Devices & FastAPI**: Interact using the `service_role` key to bypass RLS restrictions safely.
- **App Users**: Interact using their personal JWT context (`auth.uid()`). A user is strictly blocked from viewing telemetry or alerts belonging to devices owned by other user accounts.
