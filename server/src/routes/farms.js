import { Router } from 'express';

import { requireAuth } from '../auth.js';
import { query } from '../db.js';
import { orgIdForMember } from '../lib/orgScope.js';

export const farmsRouter = Router();
farmsRouter.use(requireAuth);

export function toFarmJson(row) {
  return {
    id: row.id,
    orgId: row.org_id,
    name: row.name,
    region: row.region,
    address: row.address,
    nearestStationCode: row.nearest_station_code,
    nearestStationName: row.nearest_station_name,
    riskLevel: row.risk_level,
    headline: row.headline,
    waterTemp: Number(row.water_temp),
    lastVisitDays: row.last_visit_days,
    assignedMemberName: row.assigned_member_name,
    ownerContact: row.owner_contact,
  };
}

farmsRouter.get('/', async (req, res) => {
  const orgId = await orgIdForMember(req.memberId);
  const { rows } = await query(
    `select f.*, m.name as assigned_member_name
     from farms f left join members m on m.id = f.assigned_member_id
     where f.org_id = $1 order by f.name`,
    [orgId],
  );
  res.json(rows.map(toFarmJson));
});

farmsRouter.get('/:id', async (req, res) => {
  const orgId = await orgIdForMember(req.memberId);
  const { rows } = await query(
    `select f.*, m.name as assigned_member_name
     from farms f left join members m on m.id = f.assigned_member_id
     where f.org_id = $1 and f.id = $2`,
    [orgId, req.params.id],
  );
  if (!rows[0]) return res.status(404).json({ error: '양식장을 찾을 수 없습니다.' });
  res.json(toFarmJson(rows[0]));
});
