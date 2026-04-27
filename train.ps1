# Train model và lưu kết quả vào AI_ENGINE/data/results/
# Run: .\train.ps1 [-dataset C-dataset] [-model base|fuzzy|ablation|both]
param(
    [string]$dataset  = "C-dataset",
    [string]$model    = "fuzzy",
    [string]$variants = "all",
    [int]$epochs      = 300
)

$root   = $PSScriptRoot

# Resolve Python: prefer project .venv, then system python
$python = "$root\.venv\Scripts\python.exe"
if (-not (Test-Path $python)) {
    $python = (Get-Command python -ErrorAction SilentlyContinue).Source
    if (-not $python) {
        Write-Error "Python not found. Activate your venv or install Python."
        exit 1
    }
    Write-Host "Using system Python: $python" -ForegroundColor DarkYellow
}

if ($model -eq "base" -or $model -eq "both") {
    Write-Host "Training AMNTDDA (base) on $dataset ..." -ForegroundColor Cyan
    & $python "$root\AI_ENGINE\src\train_DDA_base.py" --dataset $dataset
    Write-Host "Done [base]. Results saved to AI_ENGINE/data/results/" -ForegroundColor Green
}

if ($model -eq "fuzzy" -or $model -eq "both") {
    Write-Host "Training AMNTDDA_Fuzzy on $dataset ..." -ForegroundColor Cyan
    & $python "$root\AI_ENGINE\src\train_DDA_fuzzy.py" --dataset $dataset
    Write-Host "Done [fuzzy]. Results saved to AI_ENGINE/data/results/" -ForegroundColor Green
}

if ($model -eq "ablation") {
    Write-Host "Training Ablation Study ($variants) on $dataset ..." -ForegroundColor Cyan
    & $python "$root\AI_ENGINE\src\train_DDA_ablation.py" `
        --dataset $dataset --variants $variants --epochs $epochs
    Write-Host "Done [ablation]. Results saved to AI_ENGINE/data/results/" -ForegroundColor Green
}
