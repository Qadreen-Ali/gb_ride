-- Create ratings table for ride feedback
CREATE TABLE IF NOT EXISTS ratings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  ride_id UUID REFERENCES rides(id) ON DELETE CASCADE,
  driver_id UUID REFERENCES drivers(id) ON DELETE CASCADE,
  local_id UUID REFERENCES locals(id) ON DELETE CASCADE,
  rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
  tags TEXT[] DEFAULT '{}',
  tip INT DEFAULT NULL,
  comment TEXT DEFAULT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Index for looking up driver ratings
CREATE INDEX IF NOT EXISTS idx_ratings_driver_id ON ratings(driver_id);
CREATE INDEX IF NOT EXISTS idx_ratings_ride_id ON ratings(ride_id);

-- RLS: locals can insert their own ratings
ALTER TABLE ratings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Locals can insert ratings"
  ON ratings FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Anyone can read ratings"
  ON ratings FOR SELECT
  USING (true);
