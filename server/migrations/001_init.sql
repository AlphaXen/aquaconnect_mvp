create extension if not exists pgcrypto;

create table organizations (
  id uuid primary key default gen_random_uuid(),
  name text not null
);

create table members (
  id uuid primary key default gen_random_uuid(),
  org_id uuid not null references organizations(id) on delete cascade,
  name text not null,
  email text not null unique,
  password_hash text not null,
  is_owner boolean not null default false,
  phone text,
  created_at timestamptz not null default now()
);

create table farms (
  id uuid primary key default gen_random_uuid(),
  org_id uuid not null references organizations(id) on delete cascade,
  name text not null,
  region text not null,
  address text not null,
  nearest_station_code text not null,
  nearest_station_name text not null,
  risk_level text not null default 'good' check (risk_level in ('danger', 'warning', 'good')),
  headline text not null default '',
  water_temp numeric not null default 0,
  last_visit_days integer not null default 0,
  assigned_member_id uuid references members(id) on delete set null,
  owner_contact text,
  created_at timestamptz not null default now()
);

create table memos (
  id uuid primary key default gen_random_uuid(),
  org_id uuid not null references organizations(id) on delete cascade,
  farm_id uuid references farms(id) on delete set null,
  author_type text not null check (author_type in ('institute', 'farm')),
  author_name text not null,
  content text not null,
  tags text[] not null default '{}',
  photo_count integer not null default 0,
  read_by_farm boolean not null default false,
  created_at timestamptz not null default now()
);
create index memos_farm_id_created_at_idx on memos(farm_id, created_at desc);
create index memos_org_id_created_at_idx on memos(org_id, created_at desc);

create table disease_info (
  id uuid primary key default gen_random_uuid(),
  scope text not null check (scope in ('domestic', 'overseas')),
  species text not null default '',
  title text not null,
  source text not null,
  published_at timestamptz not null
);

create table reports (
  id uuid primary key default gen_random_uuid(),
  farm_id uuid not null references farms(id) on delete cascade,
  period_label text not null,
  risk_level text not null check (risk_level in ('danger', 'warning', 'good')),
  headline text not null,
  summary text not null,
  weekly_mortality integer not null default 0,
  avg_temp numeric not null default 0,
  last_visit_days integer not null default 0,
  findings text[] not null default '{}',
  follow_ups text[] not null default '{}',
  mortality_trend numeric[] not null default '{}',
  temp_trend numeric[] not null default '{}',
  day_labels text[] not null default '{}',
  generated_at timestamptz not null default now()
);
create index reports_farm_id_generated_at_idx on reports(farm_id, generated_at desc);

create table share_links (
  id uuid primary key default gen_random_uuid(),
  farm_id uuid not null references farms(id) on delete cascade,
  token text not null unique,
  created_by uuid references members(id) on delete set null,
  created_at timestamptz not null default now(),
  expires_at timestamptz,
  revoked_at timestamptz
);
create index share_links_token_idx on share_links(token);
