import { Router } from 'express';

import { fetchRealtimeObservations } from '../lib/nifs.js';

export const oceanRouter = Router();

// No auth: this just mirrors the public NIFS feed, and having it open makes
// it trivial to sanity-check the proxy is alive after a Railway deploy.
oceanRouter.get('/realtime', async (req, res) => {
  try {
    const observations = await fetchRealtimeObservations({ station: req.query.station });
    res.json(observations);
  } catch (err) {
    res.status(502).json({ error: err.message });
  }
});
