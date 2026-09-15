import { Router } from 'express';

import { requireAuth } from '../auth.js';
import { query } from '../db.js';
import { orgIdForMember } from '../lib/orgScope.js';

export const memosRouter = Router();
memosRouter.use(requireAuth);

function toMemoJson(row) {
  return {
    id: row.id,
    orgId: row.org_id,
    farmId: row.farm_id,
    farmName: row.farm_name,
    authorType: row.author_type,
    authorName: row.author_name,
    content: row.content,
    tags: row.tags ?? [],
    photoCount: row.photo_count,
    readByFarm: row.read_by_farm,
    createdAt: row.created_at,
  };
}

memosRouter.get('/', async (req, res) => {
  const orgId = await orgIdForMember(req.memberId);
  const farmId = req.query.farmId ?? null;
  const { rows } = await query(
    `select mm.*, f.name as farm_name
     from memos mm left join farms f on f.id = mm.farm_id
     where mm.org_id = $1 and ($2::uuid is null or mm.farm_id = $2)
     order by mm.created_at desc`,
    [orgId, farmId],
  );
  res.json(rows.map(toMemoJson));
});

memosRouter.post('/', async (req, res) => {
  const orgId = await orgIdForMember(req.memberId);
  const { farmId = null, content, tags = [], photoCount = 0 } = req.body ?? {};
  if (!content || !content.trim()) {
    return res.status(400).json({ error: '메모 내용을 입력해주세요.' });
  }

  const { rows: memberRows } = await query('select name from members where id = $1', [req.memberId]);
  const authorName = `수산질병관리원 · ${memberRows[0]?.name ?? ''}`;

  const { rows } = await query(
    `insert into memos (org_id, farm_id, author_type, author_name, content, tags, photo_count)
     values ($1, $2, 'institute', $3, $4, $5, $6)
     returning *`,
    [orgId, farmId, authorName, content, tags, photoCount],
  );

  let farmName = null;
  if (rows[0].farm_id) {
    const { rows: farmRows } = await query('select name from farms where id = $1', [rows[0].farm_id]);
    farmName = farmRows[0]?.name ?? null;
  }

  res.status(201).json(toMemoJson({ ...rows[0], farm_name: farmName }));
});
