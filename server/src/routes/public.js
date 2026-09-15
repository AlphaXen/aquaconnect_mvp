import { Router } from 'express';

import { query } from '../db.js';
import { toFarmJson } from './farms.js';
import { buildAndPersistReport, latestReportRow, toReportJson } from './reports.js';

// No requireAuth here on purpose: this is what a farm owner opens from a
// share link on their own phone, with no AquaConnect account.
export const publicRouter = Router();

publicRouter.get('/reports/:token', async (req, res) => {
  const { rows } = await query('select * from share_links where token = $1', [req.params.token]);
  const link = rows[0];

  const isActive = link && !link.revoked_at && (!link.expires_at || new Date(link.expires_at) > new Date());
  if (!isActive) return res.status(404).json({ error: '링크가 만료되었거나 존재하지 않습니다.' });

  const { rows: farmRows } = await query('select f.*, m.name as assigned_member_name from farms f left join members m on m.id = f.assigned_member_id where f.id = $1', [link.farm_id]);
  const farm = farmRows[0];
  if (!farm) return res.status(404).json({ error: '링크가 만료되었거나 존재하지 않습니다.' });

  let reportRow = await latestReportRow(farm.id);
  const report = reportRow ? toReportJson(reportRow) : await buildAndPersistReport(farm);

  res.json({
    farm: toFarmJson(farm),
    report,
    link: { id: link.id, farmId: link.farm_id, token: link.token, createdAt: link.created_at, expiresAt: link.expires_at, revokedAt: link.revoked_at },
  });
});
