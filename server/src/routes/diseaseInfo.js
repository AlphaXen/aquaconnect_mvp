import { Router } from 'express';

import { requireAuth } from '../auth.js';
import { query } from '../db.js';

export const diseaseInfoRouter = Router();
diseaseInfoRouter.use(requireAuth);

diseaseInfoRouter.get('/', async (req, res) => {
  const { rows } = await query('select * from disease_info order by published_at desc');
  res.json(
    rows.map((row) => ({
      id: row.id,
      scope: row.scope,
      species: row.species ?? '',
      title: row.title,
      source: row.source,
      publishedAt: row.published_at,
    })),
  );
});
