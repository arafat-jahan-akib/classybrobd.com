-- Run this once in your Supabase project's SQL Editor
-- (Dashboard → SQL Editor → New query → paste → Run)

create table if not exists public.orders (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  customer_name text not null,
  customer_phone text not null,
  customer_address text not null,
  notes text,
  items jsonb not null,
  total numeric not null,
  status text not null default 'new'
);

alter table public.orders enable row level security;

-- Explicit Data API grants (required on newer Supabase projects).
-- anon can only INSERT (place an order). authenticated (your admin login)
-- can SELECT and UPDATE (view + manage orders). Nobody can DELETE by default.
grant insert on public.orders to anon;
grant select, update on public.orders to authenticated;

-- Row Level Security policies (these decide which ROWS each grant can touch)
create policy "Public can submit orders"
  on public.orders
  for insert
  to anon
  with check (true);

create policy "Logged-in admins can view orders"
  on public.orders
  for select
  to authenticated
  using (true);

create policy "Logged-in admins can update orders"
  on public.orders
  for update
  to authenticated
  using (true);
