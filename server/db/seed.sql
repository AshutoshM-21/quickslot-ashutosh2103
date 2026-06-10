-- Example seed data for multi-sport venues.
-- Adjust IDs/dates to match your database before running.

-- Example venue with multiple sports
-- INSERT INTO venues (name, location, sport, sports, description)
-- VALUES (
--   'Fitso Thubarahalli MKR Sports Arena',
--   'Thubarahalli, Bengaluru',
--   'Badminton',
--   'Badminton,Swimming,Table Tennis',
--   'Multi-sport arena with badminton courts, swimming pool, and table tennis.'
-- );

-- Example slots for venue_id = 1 on 2026-06-10
-- INSERT INTO slots (venue_id, slot_date, start_time, end_time, status, sport) VALUES
-- (1, '2026-06-10', '06:00:00', '07:00:00', 'AVAILABLE', 'Badminton'),
-- (1, '2026-06-10', '07:00:00', '08:00:00', 'AVAILABLE', 'Badminton'),
-- (1, '2026-06-10', '07:00:00', '08:00:00', 'AVAILABLE', 'Swimming'),
-- (1, '2026-06-10', '08:00:00', '09:00:00', 'AVAILABLE', 'Table Tennis');
