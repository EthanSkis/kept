// Assemble the native app bundle in www/ from the web app in app/ plus the shared icons.
// The web app reaches its icons at ../icons/; inside the bundle they sit next to it.
import { cpSync, readFileSync, rmSync, writeFileSync } from 'node:fs';

const out = 'www';
rmSync(out, { recursive: true, force: true });
cpSync('app', out, { recursive: true });
cpSync('icons', out + '/icons', { recursive: true });
for (const f of ['index.html', 'manifest.webmanifest', 'sw.js']) {
  const p = out + '/' + f;
  writeFileSync(p, readFileSync(p, 'utf8').replaceAll('../icons/', 'icons/'));
}
console.log('www/ built from app/');
