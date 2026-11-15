-- Run this in Supabase SQL Editor.
-- This creates shared booking storage. Enable Auth/RLS before using with real guest data.
create extension if not exists pgcrypto;
create table if not exists public.bookings (
  id uuid primary key default gen_random_uuid(),
  guest_name text not null,
  from_place text not null,
  mobile text not null,
  guest_count integer not null check (guest_count > 0),
  room_count integer not null check (room_count > 0),
  room_numbers text not null,
  from_date date not null,
  to_date date not null check (to_date > from_date),
  checked_out boolean not null default false,
  checked_out_at timestamptz,
  created_at timestamptz not null default now()
);
alter table public.bookings enable row level security;
-- Recommended: create Supabase Auth users for authorised staff, then use authenticated policies.
-- Remove these policies if you want to enforce access only through server-side Edge Functions.
create policy "Authenticated staff can read bookings" on public.bookings for select to authenticated using (true);
create policy "Authenticated staff can add bookings" on public.bookings for insert to authenticated with check (true);
create policy "Authenticated staff can update bookings" on public.bookings for update to authenticated using (true) with check (true);
-- Do NOT enable anonymous access for production guest data.
