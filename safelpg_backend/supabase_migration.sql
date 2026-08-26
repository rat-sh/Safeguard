-- =============================================================================
-- SafeLPG Supabase Schema Migration
-- Run this in your Supabase SQL Editor (Dashboard → SQL Editor → New Query)
-- =============================================================================

-- Enable UUID generation extension (already on in Supabase by default)
CREATE EXTENSION IF NOT EXISTS "pgcrypto";


-- =============================================================================
-- TABLE: devices
-- Registered IoT devices, linked to a Supabase Auth user (device ownership)
-- =============================================================================
CREATE TABLE IF NOT EXISTS public.devices (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    owner_id    UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    name        TEXT NOT NULL DEFAULT 'My LPG Monitor',
    location    TEXT,                               -- e.g. "Kitchen", "Garage"
    api_key     TEXT NOT NULL UNIQUE,               -- shared with ESP32 as X-Device-API-Key
    is_active   BOOLEAN NOT NULL DEFAULT TRUE,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Index for fast owner lookups
CREATE INDEX IF NOT EXISTS idx_devices_owner_id ON public.devices(owner_id);

-- Auto-update updated_at on row change
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_devices_updated_at ON public.devices;
CREATE TRIGGER trg_devices_updated_at
    BEFORE UPDATE ON public.devices
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();


-- =============================================================================
-- TABLE: sensor_readings
-- Time-series table for all ESP32 sensor payloads
-- =============================================================================
CREATE TABLE IF NOT EXISTS public.sensor_readings (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    device_id           TEXT NOT NULL,              -- matches ESP32 device_id string
    gas_level           FLOAT NOT NULL,             -- LEL %
    gas_raw_adc         INT,                        -- raw MQ-2 ADC value
    temperature         FLOAT,                      -- Celsius
    humidity            FLOAT,                      -- %
    human_presence      BOOLEAN NOT NULL,           -- PIR
    distance_cm         FLOAT,                      -- HC-SR04
    regulator_state     BOOLEAN NOT NULL,           -- Reed switch (ON/OFF)
    door_open           BOOLEAN,                    -- Door/window reed switch
    relay_active        BOOLEAN,                    -- Auto shut-off relay
    buzzer_active       BOOLEAN,                    -- Local buzzer state
    battery_level       INT,                        -- 0–100 %
    gsm_signal_strength INT,                        -- SIM800L 0–31
    system_state        TEXT NOT NULL DEFAULT 'normal'
                            CHECK (system_state IN ('normal','warning','critical','power_cut')),
    timestamp           TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Composite index: fast per-device time-series queries for Flutter graphs
CREATE INDEX IF NOT EXISTS idx_sensor_device_timestamp
    ON public.sensor_readings(device_id, timestamp DESC);


-- =============================================================================
-- TABLE: alerts
-- AI-generated alerts stored for Flutter Smart Alert Centre
-- =============================================================================
CREATE TABLE IF NOT EXISTS public.alerts (
    id                   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    device_id            TEXT NOT NULL,
    severity             TEXT NOT NULL
                            CHECK (severity IN ('info','warning','critical')),
    message              TEXT NOT NULL,
    leak_probability     FLOAT CHECK (leak_probability BETWEEN 0.0 AND 1.0),
    contributing_factors JSONB,                     -- array of factor strings
    is_resolved          BOOLEAN NOT NULL DEFAULT FALSE,
    created_at           TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Index for Flutter Smart Alert Centre: per-device newest first, unresolved first
CREATE INDEX IF NOT EXISTS idx_alerts_device_created
    ON public.alerts(device_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_alerts_unresolved
    ON public.alerts(device_id, is_resolved)
    WHERE is_resolved = FALSE;


-- =============================================================================
-- ROW LEVEL SECURITY (RLS)
-- Ensures Flutter app users can only see their own device data
-- =============================================================================

-- devices: owner sees their own devices only
ALTER TABLE public.devices ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Owners can manage their own devices" ON public.devices;
CREATE POLICY "Owners can manage their own devices"
    ON public.devices
    FOR ALL
    USING (auth.uid() = owner_id)
    WITH CHECK (auth.uid() = owner_id);

-- sensor_readings: user can read readings for devices they own
ALTER TABLE public.sensor_readings ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Owners can read their device readings" ON public.sensor_readings;
CREATE POLICY "Owners can read their device readings"
    ON public.sensor_readings
    FOR SELECT
    USING (
        device_id IN (
            SELECT id::TEXT FROM public.devices WHERE owner_id = auth.uid()
        )
    );

-- Service Role bypass: FastAPI (service role key) can insert without RLS
-- This is automatic when using the service role key — no extra policy needed.

-- alerts: user can read and update (resolve) alerts for their devices
ALTER TABLE public.alerts ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Owners can read their device alerts" ON public.alerts;
CREATE POLICY "Owners can read their device alerts"
    ON public.alerts
    FOR SELECT
    USING (
        device_id IN (
            SELECT id::TEXT FROM public.devices WHERE owner_id = auth.uid()
        )
    );

DROP POLICY IF EXISTS "Owners can resolve their device alerts" ON public.alerts;
CREATE POLICY "Owners can resolve their device alerts"
    ON public.alerts
    FOR UPDATE
    USING (
        device_id IN (
            SELECT id::TEXT FROM public.devices WHERE owner_id = auth.uid()
        )
    );
