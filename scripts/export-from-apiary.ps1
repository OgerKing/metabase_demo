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
docker compose -f $ApiaryComposePath exec -T postgres pg_dump -U $DbUser $DbName > "$SeedDir\hub_analytics.sql"

Write-Host "Copying Metabase H2 metabase.db from Apiary volume into $SeedDir ..."
docker run --rm `
  -v apiary_metabase-data:/metabase-data `
  -v "$SeedDir":/dest `
  alpine:latest /bin/sh -c "cp /metabase-data/metabase.db /dest/metabase.db"

Write-Host "Done. Seed files should now exist in $SeedDir."

