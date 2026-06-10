-- Multi-sport support: per-slot sport + venue-level sports list.
-- Run once against your PostgreSQL database.

ALTER TABLE slots ADD COLUMN IF NOT EXISTS sport VARCHAR(50);
ALTER TABLE venues ADD COLUMN IF NOT EXISTS sports TEXT;

-- Backfill slot sport from the legacy venue.sport column.
UPDATE slots s
SET sport = v.sport
FROM venues v
WHERE s.venue_id = v.id
  AND s.sport IS NULL
  AND v.sport IS NOT NULL;

-- Backfill venue sports list from the legacy sport column.
UPDATE venues
SET sports = sport
WHERE sports IS NULL
  AND sport IS NOT NULL;

-- Default any remaining slots.
UPDATE slots
SET sport = 'Sports'
WHERE sport IS NULL;
