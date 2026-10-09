-- Kept membership applications, collected by join/index.html.
-- Run once in a dedicated Kept Supabase project (SQL editor or `supabase db push`).
-- Visitors can only insert. Nobody can read applications with the public key;
-- review them in the dashboard or with the service role.

create table if not exists public.applications (
  id bigint generated always as identity primary key,
  created_at timestamptz not null default now(),
  name text not null check (char_length(name) between 1 and 40),
  email text not null check (char_length(email) between 3 and 120 and email like '%@%'),
  today text not null check (char_length(today) between 10 and 1200),
  wants text[] not null default '{}' check (cardinality(wants) <= 4),
  iphone boolean not null default true,
  source text check (source is null or char_length(source) <= 200),
  status text not null default 'new' check (status in ('new', 'invited', 'declined', 'joined'))
);

alter table public.applications enable row level security;

drop policy if exists "Anyone can apply" on public.applications;
create policy "Anyone can apply" on public.applications
  for insert to anon
  with check (status = 'new');

-- One application per email; a resubmission is rejected rather than duplicated.
create unique index if not exists applications_email_key on public.applications (lower(email));
