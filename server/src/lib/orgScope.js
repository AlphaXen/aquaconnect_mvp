import { query } from '../db.js';

// Every protected route scopes reads/writes to the caller's own
// organization — this is the hand-rolled equivalent of Supabase RLS policies
// now that we're on plain Postgres behind our own API.
export async function orgIdForMember(memberId) {
  const { rows } = await query('select org_id from members where id = $1', [memberId]);
  return rows[0]?.org_id ?? null;
}
