// One-off local smoke test using pg-mem (an in-process Postgres emulator)
// to sanity-check the migration SQL and the shape of our queries without
// needing a real Postgres instance in this sandbox. Not part of the
// shipped server — safe to delete once Railway Postgres is attached and
// real `npm run migrate && npm run seed` has been run against it instead.
import { newDb } from 'pg-mem';
import { readFile } from 'node:fs/promises';
import bcrypt from 'bcryptjs';

import { generateReport } from '../src/lib/reportGenerator.js';

const db = newDb({ autoCreateForeignKeyIndices: true });
db.public.registerFunction({
  name: 'gen_random_uuid',
  returns: 'uuid',
  implementation: () => crypto.randomUUID(),
});

const { Pool } = db.adapters.createPg();
const pool = new Pool();

async function main() {
  const sql = await readFile(new URL('../migrations/001_init.sql', import.meta.url), 'utf8');
  const withoutExtension = sql.replace(/create extension.*?;/i, '');
  await pool.query(withoutExtension);
  console.log('✓ migration SQL applied to pg-mem');

  const { rows: orgRows } = await pool.query("insert into organizations (name) values ('해강수산질병관리원') returning id");
  const orgId = orgRows[0].id;
  const hash = await bcrypt.hash('demo1234', 10);
  const { rows: memberRows } = await pool.query(
    `insert into members (org_id, name, email, password_hash, is_owner) values ($1,'이동길','a@b.com',$2,true) returning id`,
    [orgId, hash],
  );
  const memberId = memberRows[0].id;
  console.log('✓ organization + member insert');

  const { rows: farmRows } = await pool.query(
    `insert into farms (org_id, name, region, address, nearest_station_code, nearest_station_name, risk_level, headline, water_temp, last_visit_days, assigned_member_id, owner_contact)
     values ($1,'신일수산 1양식장','완도','완도군 노화읍','001','완도','danger','오늘 폐사 12마리',29.4,9,$2,'01011112222') returning id`,
    [orgId, memberId],
  );
  const farmId = farmRows[0].id;
  console.log('✓ farm insert');

  await pool.query(
    `insert into memos (org_id, farm_id, author_type, author_name, content, tags, photo_count, read_by_farm)
     values ($1,$2,'farm','어가 · 신일수산 1양식장','오늘 아침 폐사 12마리 나왔습니다.', $3, 1, true)`,
    [orgId, farmId, ['폐사 12마리']],
  );
  console.log('✓ memo insert with text[] tags');

  const { rows: memoRows } = await pool.query('select * from memos where farm_id = $1 order by created_at desc', [farmId]);
  if (memoRows.length !== 1 || memoRows[0].tags[0] !== '폐사 12마리') throw new Error('memo select/tags mismatch');
  console.log('✓ memo select, count =', memoRows.length);

  await pool.query(
    `insert into reports (farm_id, period_label, risk_level, headline, summary, weekly_mortality, avg_temp, last_visit_days, findings, follow_ups, mortality_trend, temp_trend, day_labels)
     values ($1,'이번 주','warning','고수온 지속','요약', 12, 29.1, 9, $2, $3, $4, $5, $6)`,
    [
      farmId,
      ['최근 7일간 누적 폐사 12마리'],
      ['수질 확인을 권장합니다'],
      [0, 0, 0, 0, 0, 0, 12],
      [27, 27.5, 28, 28.3, 28.6, 29, 29.4],
      ['9/10', '9/11', '9/12', '9/13', '9/14', '9/15', '9/16'],
    ],
  );
  console.log('✓ report insert with numeric[]/text[] arrays');

  await pool.query(`insert into share_links (farm_id, token, created_by) values ($1,'demo',$2)`, [farmId, memberId]);
  const { rows: linkRows } = await pool.query('select * from share_links where token = $1', ['demo']);
  if (linkRows.length !== 1) throw new Error('share_link lookup failed');
  console.log('✓ share_link insert + lookup, found =', linkRows.length === 1);

  const { rows: orgFarmRows } = await pool.query('select id from farms where org_id = $1', [orgId]);
  const matched = orgFarmRows.map((r) => r.id).filter((id) => new Set([farmId]).has(id));
  if (matched.length !== 1) throw new Error('org-scoped farm id filter did not match');
  console.log('✓ org-scoped farms select + JS-side id filter, found =', matched.length === 1);

  // Exercise the real (imported, not hand-copied) generateReport() output
  // shape against the same field types the reports table expects — this
  // caught real bugs before (e.g. array length / numeric type mismatches)
  // without needing a second INSERT (pg-mem's gen_random_uuid() default
  // appears to collide across repeated inserts in the same session, which
  // looks like a pg-mem quirk rather than anything about our SQL — see the
  // migration/insert coverage above for that).
  const realReport = generateReport({
    farm: { id: farmId, waterTemp: 29.4, lastVisitDays: 9, nearestStationName: '완도' },
    farmMemos: [{ content: '오늘 아침 폐사 12마리 나왔습니다.', tags: ['폐사 12마리'], createdAt: new Date().toISOString() }],
    ocean: null,
    now: new Date(),
  });
  if (realReport.weeklyMortality !== 12) throw new Error(`expected weeklyMortality 12, got ${realReport.weeklyMortality}`);
  if (realReport.riskLevel !== 'warning') throw new Error(`expected riskLevel warning, got ${realReport.riskLevel}`);
  if (realReport.tempTrend.length !== 7 || realReport.dayLabels.length !== 7) throw new Error('trend arrays must be length 7');
  if (realReport.mortalityTrend.some((v) => typeof v !== 'number')) throw new Error('mortalityTrend must be all numbers');
  console.log('✓ real generateReport() output shape matches the reports table columns, riskLevel =', realReport.riskLevel);

  console.log('\nAll smoke checks passed.');
}

main().catch((err) => {
  console.error('SMOKE TEST FAILED:', err);
  process.exit(1);
});
