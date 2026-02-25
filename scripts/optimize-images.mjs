import fs from "node:fs";
import path from "node:path";
import sharp from "sharp";

const inDir = "src/assets/img-original";
const outDir = "src/assets/img";

fs.mkdirSync(outDir, { recursive: true });

const files = fs.readdirSync(inDir).filter(f =>
  /\.(jpe?g|png)$/i.test(f)
);

files.sort(); // keeps a stable order (by filename)

let i = 1;

for (const file of files) {
  const inPath = path.join(inDir, file);
  const outName = `${String(i).padStart(2, "0")}.webp`;
  const outPath = path.join(outDir, outName);

  await sharp(inPath)
    .resize({ width: 3000, height: 3000, fit: "inside", withoutEnlargement: true })
    .webp({ quality: 82 })
    .toFile(outPath);

  console.log(`Wrote ${outPath}`);
  i++;
}
