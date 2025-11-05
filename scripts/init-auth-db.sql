-- Authentication Service Database Initialization Script

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_user_sessions_user_id ON user_sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_user_sessions_expires_at ON user_sessions(expires_at);

-- Insert default admin user (password: Admin123!)
-- Note: This is for development only, remove in production
INSERT INTO users (id, email, password_hash, first_name, last_name, date_of_birth, email_verified, created_at, updated_at)
VALUES (
    uuid_generate_v4(),
    'admin@eventbooking.com',
    '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi.',
    'System',
    'Administrator',
    '1990-01-01',
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
) ON CONFLICT (email) DO NOTHING;