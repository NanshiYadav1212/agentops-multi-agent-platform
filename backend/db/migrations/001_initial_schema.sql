CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- =========================================================
-- USERS
-- =========================================================

CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL,
    role TEXT NOT NULL DEFAULT 'user',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- =========================================================
-- SESSIONS
-- =========================================================

CREATE TABLE IF NOT EXISTS sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token_jti TEXT UNIQUE NOT NULL,
    expires_at TIMESTAMPTZ NOT NULL,
    revoked BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_sessions_user_id
    ON sessions(user_id);

CREATE INDEX IF NOT EXISTS idx_sessions_token_jti
    ON sessions(token_jti);

-- =========================================================
-- ACTIVITY LOGS
-- =========================================================

CREATE TABLE IF NOT EXISTS activity_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    type TEXT NOT NULL,
    title TEXT NOT NULL,
    description TEXT NOT NULL DEFAULT '',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_activity_logs_created_at
    ON activity_logs(created_at DESC);

-- =========================================================
-- AGENT RUNS
-- =========================================================

CREATE TABLE IF NOT EXISTS agent_runs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    goal TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'running',
    tokens_used INTEGER NOT NULL DEFAULT 0,
    events JSONB NOT NULL DEFAULT '[]'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_agent_runs_user_id
    ON agent_runs(user_id);

CREATE INDEX IF NOT EXISTS idx_agent_runs_status
    ON agent_runs(status);

CREATE INDEX IF NOT EXISTS idx_agent_runs_created_at
    ON agent_runs(created_at DESC);

-- =========================================================
-- ASSISTANT MEMORY
-- =========================================================

CREATE TABLE IF NOT EXISTS assistant_memory (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    topic TEXT NOT NULL,
    summary TEXT NOT NULL,
    category TEXT,
    source TEXT,
    pinned BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_assistant_memory_user_id
    ON assistant_memory(user_id);

CREATE INDEX IF NOT EXISTS idx_assistant_memory_user_pinned
    ON assistant_memory(user_id, pinned DESC, created_at DESC);

-- =========================================================
-- USER API KEYS
-- =========================================================

CREATE TABLE IF NOT EXISTS user_api_keys (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    groq_key TEXT NOT NULL DEFAULT '',
    serpapi_key TEXT NOT NULL DEFAULT '',
    github_token TEXT NOT NULL DEFAULT '',
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_user_api_keys_user UNIQUE(user_id)
);

-- =========================================================
-- USER PREFERENCES
-- =========================================================

CREATE TABLE IF NOT EXISTS user_preferences (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    model TEXT NOT NULL DEFAULT 'llama-3.3-70b-versatile',
    web_search BOOLEAN NOT NULL DEFAULT TRUE,
    smart_cache BOOLEAN NOT NULL DEFAULT FALSE,
    smart_suggestion BOOLEAN NOT NULL DEFAULT TRUE,
    rag_threshold DOUBLE PRECISION NOT NULL DEFAULT 1.5,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_user_preferences_user UNIQUE(user_id)
);

-- =========================================================
-- UPLOADED FILES
-- =========================================================

CREATE TABLE IF NOT EXISTS uploaded_files (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    filename TEXT NOT NULL,
    chunk_count INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_uploaded_files_user_filename
        UNIQUE(user_id, filename)
);

CREATE INDEX IF NOT EXISTS idx_uploaded_files_user_id
    ON uploaded_files(user_id);

-- =========================================================
-- CACHED RUNS
-- =========================================================

CREATE TABLE IF NOT EXISTS cached_runs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    route TEXT NOT NULL,
    goal TEXT NOT NULL,
    result JSONB NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_cached_runs_lookup
    ON cached_runs(user_id, route, created_at DESC);

-- =========================================================
-- ORION DEVICES
-- =========================================================

CREATE TABLE IF NOT EXISTS orion_devices (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    device_name TEXT NOT NULL,
    os TEXT,
    version TEXT,
    verified BOOLEAN NOT NULL DEFAULT FALSE,
    last_seen TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_orion_device_user_name
        UNIQUE(user_id, device_name)
);

CREATE INDEX IF NOT EXISTS idx_orion_devices_user_id
    ON orion_devices(user_id);

-- =========================================================
-- ORION ACTIVITY
-- =========================================================

CREATE TABLE IF NOT EXISTS orion_activity (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    event_type TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_orion_activity_user_created
    ON orion_activity(user_id, created_at DESC);
