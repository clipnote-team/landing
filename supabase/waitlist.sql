create table if not exists public.waitlist (
  email text primary key,
  source text not null default '기타',
  created_at timestamptz not null default now(),
  constraint waitlist_email_format check (position('@' in email) > 1)
);

alter table public.waitlist enable row level security;

revoke all on public.waitlist from anon;
revoke all on public.waitlist from authenticated;

grant usage on schema public to anon;
grant insert on table public.waitlist to anon;

drop policy if exists waitlist_insert_anon on public.waitlist;
create policy waitlist_insert_anon
on public.waitlist
for insert
to anon
with check (
  position('@' in email) > 1
  and position('.' in split_part(email, '@', 2)) > 1
  and char_length(trim(source)) > 0
);
