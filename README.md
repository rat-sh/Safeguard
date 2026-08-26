# SafeLPG - IoT LPG Monitoring & AI Safety System

SafeLPG is a safety-first IoT ecosystem designed to mitigate household fire hazards and gas explosions. The system monitors Liquefied Petroleum Gas (LPG) levels, detects leaks, runs real-time AI anomaly classification, and pushes instantaneous telemetry updates to users via a Flutter mobile application.

---

## ❓ Why SafeLPG? (Project Motivation)

Traditional gas leak detectors only sound a local alarm. They fail when occupants are away, cannot cut off the gas line automatically, and do not track fuel consumption. 

SafeLPG solves these problems by providing:
1. **Automated Interventions**: The hardware node triggers a physical relay to shut off the gas flow immediately upon leak detection.
2. **AI-Powered Diagnostics**: A cloud backend analyzes raw data, filtering out brief transient fluctuations (e.g., kitchen cooking fumes) from genuine gas spikes.
3. **Real-time Mobile Monitoring**: Users can track LEL % (Lower Explosive Limit) levels, monitor sensor health, and receive alerts instantly anywhere.

---

## 📱 Mobile App Architecture (Flutter)

The mobile client is built following a **Clean Architecture (Feature-First)** directory structure. This ensures that features are highly modular, testable, and isolated.

```
safelpg_flutter/
├── lib/
│   ├── core/                  # Core global configuration & infrastructure
│   │   ├── config.dart        # Compile-time injected variables (URL, Keys)
│   │   ├── theme/             # App typography, theme styling, and colors
│   │   ├── navigation/        # GoRouter navigation configs & routes
│   │   ├── network/           # Supabase WebSockets & Dio API Client instances
│   │   ├── models/            # Dart Models deserializing backend schemas
│   │   └── providers/         # Riverpod providers for real-time streams
│   │
│   ├── features/              # Feature directories
│   │   ├── dashboard/         # Live Dashboard (Circular gauge, quick actions)
│   │   ├── alerts/            # Alert Centre (Timeline, alert details)
│   │   ├── history/           # History & Insights (Segmented fl_charts, summary cards)
│   │   └── settings/          # Device settings & contact lists
│   │
│   ├── shared/                # Core shared UI elements and common widgets
│   └── main.dart              # App entry point (initializes Supabase & ProviderScope)
```

### Flutter Design Patterns & Data Flow:
* **Presentation Layer**: Screens are implemented as `ConsumerWidget` or `ConsumerStatefulWidget` subscribing to specific Riverpod providers. UI components are kept stateless, rebuilding dynamically whenever database state changes.
* **State Management (Riverpod)**:
  * `latestReadingProvider`: A StreamProvider listening to the Supabase WebSocket stream for new database row inserts on `sensor_readings`.
  * `activeAlertsProvider`: A StreamProvider filtering unresolved alerts for the dashboard status indicators.
  * `historicalReadingsProvider`: A FutureProvider that fetches historical telemetry on-demand when switching time filters (24H, 7D, 30D, 90D).
* **Data & Client Layer**: 
  * `SupabaseService` initializes the database connection and exposes reactive stream getters.
  * `ApiClient` wraps the `Dio` client to handle direct HTTP requests (e.g., resolving alerts).

---

## 🤖 Backend API Architecture (FastAPI)

The backend is structured around a **Service-Route-Model** separation pattern. This decouples incoming HTTP request handling from business logic, database queries, and the AI modeling engine.

```
safelpg_backend/
├── app/
│   ├── api/                   # Router and endpoint handlers
│   │   └── routes/
│   │       ├── device.py      # ESP32 ingestion endpoint (/data)
│   │       ├── sensor.py      # Telemetry history endpoints (/history)
│   │       └── alerts.py      # Active alerts listing and resolution
│   │
│   ├── core/                  # Configurations and Security layer
│   │   ├── config.py          # Environment settings loader
│   │   └── security.py        # API key verification middleware
│   │
│   ├── db/                    # Database engine
│   │   └── session.py         # Supabase Client Singleton instantiation
│   │
│   ├── models/
│   │   └── schemas.py         # Pydantic schemas validating API request/response
│   │
│   └── services/              # Business logic & AI algorithms
│       ├── device_service.py  # Ingestion logic, database writes, and status checks
│       ├── alert_service.py   # Alarm creation and resolution workflows
│       └── ai_service.py      # Real-time gas leak anomaly detection algorithm
│
├── schema.sql                 # Supabase DB tables, indexes, and RLS scripts
├── requirements.txt           # Python backend dependencies list
└── .env                       # Local secrets (ignored in git)
```

### Ingestion & AI Pipeline Flow:
1. **Request validation**: The ESP32 posts data to `/api/v1/device/data` with a custom `X-Device-API-Key` header. FastAPI validates the incoming JSON against the Pydantic `SensorReading` schema.
2. **AI Processing**: The `ai_service` processes the raw ADC value and LEL %, matching it against dynamic risk weights (e.g., elevated gas combined with no human presence and regulator valve open triggers high-probability leak alarms).
3. **Database Persistence**: The service inserts the reading into Supabase. If the AI detects a leak anomaly, it triggers the creation of a database record in the `alerts` table.
4. **Actuator Handshake**: The API response returns the alert status and calculated severity. The ESP32 reads this response to trigger local buzzer alarms and safety relays in real-time.

---

## ⚡ Setup & Installation

### Step 1: Database Setup (Supabase)
1. Register/Login at [Supabase](https://supabase.com).
2. Create a new project.
3. Once the database is ready, navigate to the **SQL Editor** tab in the sidebar.
4. Click **New Query**.
5. Copy the entire contents of the file `safelpg_backend/schema.sql`.
6. Paste the SQL code into the editor and click **Run**. 
7. Create at least one user in the **Authentication** tab of your Supabase project (this user will own the monitor device).

---

### Step 2: Mobile Client Setup (Flutter)
1. Open a terminal and navigate to the flutter project directory:
   ```bash
   cd safelpg_flutter
   ```
2. Fetch the Flutter dependencies:
   ```bash
   flutter pub get
   ```
3. Run the application, injecting environment variables at compile-time to maintain credentials security. Replace the placeholders with your actual keys:
   * **Running on Android Emulator**:
     ```bash
     flutter run \
       --dart-define=SUPABASE_URL=https://<your-project-ref>.supabase.co \
       --dart-define=SUPABASE_ANON_KEY=<your-anon-key> \
       --dart-define=FASTAPI_BASE_URL=http://10.0.2.2:8000 \
       --dart-define=DEVICE_ID=<your-registered-device-uuid>
     ```
   * **Running on iOS Simulator / Localhost**:
     ```bash
     flutter run \
       --dart-define=SUPABASE_URL=https://<your-project-ref>.supabase.co \
       --dart-define=SUPABASE_ANON_KEY=<your-anon-key> \
       --dart-define=FASTAPI_BASE_URL=http://localhost:8000 \
       --dart-define=DEVICE_ID=<your-registered-device-uuid>
     ```
   * **Running on Physical Mobile Device**:
     ```bash
     flutter run \
       --dart-define=SUPABASE_URL=https://<your-project-ref>.supabase.co \
       --dart-define=SUPABASE_ANON_KEY=<your-anon-key> \
       --dart-define=FASTAPI_BASE_URL=http://<your-computer-ip-address>:8000 \
       --dart-define=DEVICE_ID=<your-registered-device-uuid>
     ```

---

### Step 3: Backend Setup (FastAPI)
1. Open a terminal and navigate to the backend directory:
   ```bash
   cd safelpg_backend
   ```
2. Create a virtual environment to manage dependencies:
   * **Linux/macOS**:
     ```bash
     python3 -m venv venv
     source venv/bin/activate
     ```
   * **Windows (Command Prompt)**:
     ```cmd
     python -m venv venv
     venv\Scripts\activate.bat
     ```
   * **Windows (PowerShell)**:
     ```powershell
     python -m venv venv
     .\venv\Scripts\Activate.ps1
     ```
3. Install the dependencies listed in `requirements.txt`:
   ```bash
   pip install --upgrade pip
   pip install -r requirements.txt
   ```
4. Create a `.env` configuration file in the root of the `safelpg_backend/` folder:
   ```env
   SUPABASE_URL=https://<your-project-ref>.supabase.co
   SUPABASE_ANON_KEY=<your-anon-key>
   SUPABASE_SERVICE_ROLE_KEY=<your-service-role-key>
   DEVICE_API_KEY=default-dev-key
   ```
5. Launch the backend server:
   ```bash
   uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
   ```
   * *Note: Using `--host 0.0.0.0` allows physical devices on the same Wi-Fi network to connect to your FastAPI server.*
