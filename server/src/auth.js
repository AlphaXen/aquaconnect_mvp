import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';

const JWT_SECRET = process.env.JWT_SECRET;
if (!JWT_SECRET) {
  throw new Error('JWT_SECRET is not set.');
}

const TOKEN_TTL = '30d';

export const hashPassword = (plain) => bcrypt.hash(plain, 10);
export const verifyPassword = (plain, hash) => bcrypt.compare(plain, hash);

export const signToken = (memberId) => jwt.sign({ sub: memberId }, JWT_SECRET, { expiresIn: TOKEN_TTL });

export function requireAuth(req, res, next) {
  const header = req.headers.authorization ?? '';
  const token = header.startsWith('Bearer ') ? header.slice(7) : null;
  if (!token) {
    return res.status(401).json({ error: '로그인이 필요합니다.' });
  }
  try {
    const payload = jwt.verify(token, JWT_SECRET);
    req.memberId = payload.sub;
    next();
  } catch {
    return res.status(401).json({ error: '세션이 만료되었습니다. 다시 로그인해주세요.' });
  }
}
