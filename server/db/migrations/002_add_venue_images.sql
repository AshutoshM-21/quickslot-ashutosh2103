-- Venue cover images for home page and detail screens.
ALTER TABLE venues ADD COLUMN IF NOT EXISTS image_url TEXT;

-- Set images for your 3 venues (uses your Unsplash URLs).
UPDATE venues SET image_url = 'https://images.unsplash.com/photo-1626224583764-f87db24ac4ea?w=900&q=80&auto=format&fit=crop'
WHERE id = 1;

UPDATE venues SET image_url = 'https://plus.unsplash.com/premium_photo-1661868926397-0083f0503c07?w=900&q=80&auto=format&fit=crop'
WHERE id = 2;

UPDATE venues SET image_url = 'https://images.unsplash.com/photo-1531415074968-036ba1b575da?w=900&q=80&auto=format&fit=crop'
WHERE id = 3;

-- Fallback for any other venues by sport.
UPDATE venues
SET image_url = CASE
  WHEN LOWER(COALESCE(sports, sport, name, '')) LIKE '%badminton%'
    THEN 'https://images.unsplash.com/photo-1626224583764-f87db24ac4ea?w=900&q=80&auto=format&fit=crop'
  WHEN LOWER(COALESCE(sports, sport, name, '')) LIKE '%swim%'
    THEN 'https://images.unsplash.com/photo-1530549387789-4c1017266635?w=900&q=80&auto=format&fit=crop'
  WHEN LOWER(COALESCE(sports, sport, name, '')) LIKE '%football%'
    OR LOWER(COALESCE(sports, sport, name, '')) LIKE '%turf%'
    THEN 'https://plus.unsplash.com/premium_photo-1661868926397-0083f0503c07?w=900&q=80&auto=format&fit=crop'
  WHEN LOWER(COALESCE(sports, sport, name, '')) LIKE '%cricket%'
    THEN 'https://images.unsplash.com/photo-1531415074968-036ba1b575da?w=900&q=80&auto=format&fit=crop'
  ELSE 'https://images.unsplash.com/photo-1461896836934-ffe607ba8211?w=900&q=80&auto=format&fit=crop'
END
WHERE image_url IS NULL;
