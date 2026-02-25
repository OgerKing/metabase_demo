Param(
    [string]$ComposeDir = "C:\Sites\metabase_demo",
    [string]$SeedSqlPathInContainer = "/seed/hub_analytics.sql",
    [string]$DbName = "apiary",
    [string]$DbUser = "apiary"
)

Write-Host "Importing $SeedSqlPathInContainer into Postgres database '$DbName' ..."

Push-Location $ComposeDir
try {
    docker compose exec -T postgres bash -c "psql -U $DbUser -d $DbName -f $SeedSqlPathInContainer"
}
finally {
    Pop-Location
}

Write-Host "Import completed."

