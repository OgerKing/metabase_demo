Param(
    [string]$ApiaryComposePath = "C:\Sites\Apiary\docker-compose.yml",
    [string]$SeedDir = "C:\Sites\metabase_demo\seed",
    [string]$DbName = "hub",
    [string]$DbUser = "apiary"
)

if (-not (Test-Path $SeedDir)) {
    New-Item -ItemType Directory -Path $SeedDir | Out-Null
}

Write-Host "Exporting Postgres '$DbName' from Apiary stack to $SeedDir\hub_analytics.sql ..."
# IMPORTANT: use UTF-8 so psql inside the container can read the dump without encoding errors.
docker compose -f $ApiaryComposePath exec -T postgres pg_dump -U $DbUser $DbName |
  Out-File -FilePath "$SeedDir\hub_analytics.sql" -Encoding utf8

Write-Host "Copying Metabase H2 metabase.db from Apiary volume into $SeedDir ..."
# Docker on Windows misparses "C:\..." in -v (colon = host:container). Use path Docker accepts.
$SeedDirDocker = (Resolve-Path -LiteralPath $SeedDir).Path -replace '\\', '/' -replace '^([A-Za-z]):', '//$1'
docker run --rm `
  -v apiary_metabase-data:/metabase-data `
  -v "${SeedDirDocker}:/dest" `
  alpine:latest /bin/sh -c "cp /metabase-data/metabase.db /dest/metabase.db"

Write-Host "Done. Seed files should now exist in $SeedDir."

