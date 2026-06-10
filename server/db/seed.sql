-- Example seed data for multi-sport venues with cover images.
-- Run migration 002_add_venue_images.sql first.

-- UPDATE venues SET
--   sports = 'Badminton,Swimming,Table Tennis',
--   image_url = 'https://images.unsplash.com/photo-1626224583764-f87db27ef38c?w=900&q=80'
-- WHERE id = 1;

-- Example slots for venue_id = 1 on 2026-06-10
-- INSERT INTO slots (venue_id, slot_date, start_time, end_time, status, sport) VALUES
-- (1, '2026-06-10', '06:00:00', '07:00:00', 'AVAILABLE', 'Badminton'),
-- (1, '2026-06-10', '07:00:00', '08:00:00', 'AVAILABLE', 'Badminton'),
-- (1, '2026-06-10', '07:00:00', '08:00:00', 'AVAILABLE', 'Swimming'),
-- (1, '2026-06-10', '08:00:00', '09:00:00', 'AVAILABLE', 'Table Tennis');
