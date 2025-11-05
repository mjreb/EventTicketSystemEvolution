-- Notification Service Database Initialization Script

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_notification_templates_name ON notification_templates(name);
CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_template_id ON notifications(template_id);
CREATE INDEX IF NOT EXISTS idx_notifications_status ON notifications(status);
CREATE INDEX IF NOT EXISTS idx_notifications_sent_at ON notifications(sent_at);
CREATE INDEX IF NOT EXISTS idx_notifications_recipient_email ON notifications(recipient_email);

-- Insert default notification templates
INSERT INTO notification_templates (id, name, subject, html_content, text_content, created_at) VALUES
    (
        uuid_generate_v4(),
        'email_verification',
        'Verify Your Email Address',
        '<h2>Welcome to Event Booking System!</h2><p>Please click the link below to verify your email address:</p><p><a href="{{verification_link}}">Verify Email</a></p><p>This link will expire in 24 hours.</p>',
        'Welcome to Event Booking System! Please visit the following link to verify your email address: {{verification_link}} This link will expire in 24 hours.',
        CURRENT_TIMESTAMP
    ),
    (
        uuid_generate_v4(),
        'password_reset',
        'Reset Your Password',
        '<h2>Password Reset Request</h2><p>You have requested to reset your password. Click the link below to reset it:</p><p><a href="{{reset_link}}">Reset Password</a></p><p>This link will expire in 15 minutes.</p><p>If you did not request this, please ignore this email.</p>',
        'Password Reset Request. You have requested to reset your password. Visit the following link to reset it: {{reset_link}} This link will expire in 15 minutes. If you did not request this, please ignore this email.',
        CURRENT_TIMESTAMP
    ),
    (
        uuid_generate_v4(),
        'order_confirmation',
        'Order Confirmation - {{order_number}}',
        '<h2>Order Confirmation</h2><p>Thank you for your purchase! Your order {{order_number}} has been confirmed.</p><p><strong>Event:</strong> {{event_name}}</p><p><strong>Date:</strong> {{event_date}}</p><p><strong>Venue:</strong> {{venue_name}}</p><p><strong>Total:</strong> ${{total_amount}}</p><p>Your tickets are attached to this email.</p>',
        'Order Confirmation. Thank you for your purchase! Your order {{order_number}} has been confirmed. Event: {{event_name}}, Date: {{event_date}}, Venue: {{venue_name}}, Total: ${{total_amount}}. Your tickets are attached to this email.',
        CURRENT_TIMESTAMP
    ),
    (
        uuid_generate_v4(),
        'ticket_delivery',
        'Your Tickets for {{event_name}}',
        '<h2>Your Event Tickets</h2><p>Your tickets for {{event_name}} are ready!</p><p><strong>Event Date:</strong> {{event_date}}</p><p><strong>Venue:</strong> {{venue_name}}</p><p>Please find your tickets attached to this email. You can also access them anytime from your account.</p>',
        'Your Event Tickets. Your tickets for {{event_name}} are ready! Event Date: {{event_date}}, Venue: {{venue_name}}. Please find your tickets attached to this email. You can also access them anytime from your account.',
        CURRENT_TIMESTAMP
    )
ON CONFLICT (name) DO NOTHING;