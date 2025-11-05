-- Event Service Database Initialization Script

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_events_organizer_id ON events(organizer_id);
CREATE INDEX IF NOT EXISTS idx_events_event_date ON events(event_date);
CREATE INDEX IF NOT EXISTS idx_events_category ON events(category);
CREATE INDEX IF NOT EXISTS idx_events_status ON events(status);
CREATE INDEX IF NOT EXISTS idx_events_name ON events(name);

-- Insert sample event categories
INSERT INTO event_categories (id, name, description) VALUES
    (uuid_generate_v4(), 'Music', 'Concerts, festivals, and musical performances'),
    (uuid_generate_v4(), 'Sports', 'Sporting events and competitions'),
    (uuid_generate_v4(), 'Theater', 'Plays, musicals, and theatrical performances'),
    (uuid_generate_v4(), 'Conference', 'Business conferences and professional events'),
    (uuid_generate_v4(), 'Workshop', 'Educational workshops and training sessions'),
    (uuid_generate_v4(), 'Festival', 'Cultural festivals and celebrations'),
    (uuid_generate_v4(), 'Comedy', 'Stand-up comedy and comedy shows'),
    (uuid_generate_v4(), 'Art', 'Art exhibitions and gallery events')
ON CONFLICT (name) DO NOTHING;