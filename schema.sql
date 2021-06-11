CREATE TYPE approval AS ENUM (
  'pending',
  'approved',
  'rejected'
);

CREATE TABLE IF NOT EXISTS quotes (
  id SERIAL PRIMARY KEY,
  applicant_name text NOT NULL,
  insurance_start_date timestamptz NOT NULL,
  insurance_start_end timestamptz NOT NULL,
  insured_item_price numeric(16, 4) NOT NULL,
  approval approval NOT NULL
);
