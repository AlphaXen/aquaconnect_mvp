import crypto from 'node:crypto';

import { Router } from 'express';

import { requireAuth } from '../auth.js';
import { query } from '../db.js';
import { orgIdForMember } from '../lib/orgScope.js';

export const shareLinksRouter = Router();
shareLinksRouter.use(requireAuth);

const EXPIRY_MS = { '7d': 7 * 86400_000, '30d': 30 * 86400_000, unlimited: null };

function newToken() {
  return crypto.randomBytes(5).toString('hex').slice(0, 6);
}

function toShareLinkJson(row) {
  return {
    id: row.id,
    farmId: row.farm_id,
    token: row.token,
    createdAt: row.created_at,
    expiresAt: row.expires_at,
    revokedAt: row.revoked_at,
  };
}

shareLinksRouter.post('/', async (req, res) => {
  const orgId = await orgIdForMember(req.memberId);
  const { farmId, expiry = '30d' } = req.body ?? {};

  const { rows: farmRows } = await query('select id from farms where org_id = $1 and id = $2', [orgId, farmId]);
  if (!farmRows[0]) return res.status(404).json({ error: '양식장을 찾을 수 없습니다.' });

  const ms = EXPIRY_MS[expiry] ?? EXPIRY_MS['30d'];
  const expiresAt = ms == null ? null : new Date(Date.now() + ms).toISOString();

  const { rows } = await query(
    `insert into share_links (farm_id, token, created_by, expires_at) values ($1,$2,$3,$4) returning *`,
    [farmId, newToken(), req.memberId, expiresAt],
  );
  res.status(201).json(toShareLinkJson(rows[0]));
});

shareLinksRouter.get('/', async (req, res) => {
  const orgId = await orgIdForMember(req.memberId);
  const farmId = req.query.farmId ?? null;
  const { rows } = await query(
    `select sl.* from share_links sl join farms f on f.id = sl.farm_id
     where f.org_id = $1 and ($2::uuid is null or sl.farm_id = $2)
     order by sl.created_at desc`,
    [orgId, farmId],
  );
  res.json(rows.map(toShareLinkJson));
});
