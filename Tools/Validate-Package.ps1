$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$samplePath = "Samples~/Selection Demo"

$requiredDirectories = @(
    "Documentation~",
    $samplePath,
    "Tools",
    ".github/workflows"
)

$requiredFiles = @(
    "package.json",
    "README.md",
    "CHANGELOG.md",
    "LICENSE.md",
    "CONTRIBUTING.md",
    "Documentation~/index.md",
    "$samplePath/README.md",
    "$samplePath/JorisHoef.SelectionSuite.Samples.SelectionDemo.asmdef",
    "$samplePath/SelectionSuiteDemo.unity",
    "$samplePath/SelectionSuiteDemo.cs",
    "$samplePath/SelectionSuiteDemoData.cs",
    "$samplePath/SelectionSuiteDemoHighlighter.cs",
    "$samplePath/SelectionSuiteDemoItem.cs",
    "$samplePath/SelectionSuiteDemoRaycastController.cs"
)

foreach ($directory in $requiredDirectories) {
    $path = Join-Path $root $directory
    if (-not (Test-Path -LiteralPath $path -PathType Container)) {
        throw "Missing required directory: $directory"
    }
}

foreach ($file in $requiredFiles) {
    $path = Join-Path $root $file
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        throw "Missing required file: $file"
    }
}

$package = Get-Content -LiteralPath (Join-Path $root "package.json") -Raw | ConvertFrom-Json
if ($package.name -ne "com.jorishoef.selection-suite") {
    throw "Unexpected package name: $($package.name)"
}

if ($package.displayName -ne "JorisHoef Selection Suite") {
    throw "Unexpected package display name: $($package.displayName)"
}

if ($package.version -notmatch "^\d+\.\d+\.\d+$") {
    throw "Package version must be semver MAJOR.MINOR.PATCH: $($package.version)"
}

$expectedDependencies = @{
    "com.jorishoef.core.state" = "1.0.0"
    "com.jorishoef.generic-ui-items" = "1.0.0"
    "com.jorishoef.object-selection" = "1.0.0"
    "com.jorishoef.generic-ui-items.core-state-bridge" = "1.0.0"
    "com.jorishoef.objectselection-corestate-bridge" = "1.0.0"
}

$dependencies = $package.dependencies.PSObject.Properties
if (@($dependencies).Count -ne $expectedDependencies.Count) {
    throw "Expected $($expectedDependencies.Count) package dependencies, found $(@($dependencies).Count)."
}

foreach ($dependencyName in $expectedDependencies.Keys) {
    $property = $package.dependencies.PSObject.Properties[$dependencyName]
    if ($null -eq $property) {
        throw "Missing dependency: $dependencyName"
    }

    if ($property.Value -ne $expectedDependencies[$dependencyName]) {
        throw "Unexpected dependency version for $dependencyName`: $($property.Value)"
    }
}

if ($package.samples.Count -ne 1) {
    throw "Selection Suite should declare exactly one sample."
}

if ($package.samples[0].path -ne $samplePath) {
    throw "Unexpected sample path: $($package.samples[0].path)"
}

$sampleAsmdef = Get-Content -LiteralPath (Join-Path $root "$samplePath/JorisHoef.SelectionSuite.Samples.SelectionDemo.asmdef") -Raw | ConvertFrom-Json
$expectedReferences = @(
    "JorisHoef.Core.State",
    "GenericUIItems",
    "GenericUIItems.CoreState.Bridge",
    "JorisHoef.ObjectSelection",
    "JorisHoef.ObjectSelection.CoreState"
)

foreach ($reference in $expectedReferences) {
    if ($sampleAsmdef.references -notcontains $reference) {
        throw "Sample asmdef must reference $reference"
    }
}

$runtimePath = Join-Path $root "Runtime"
if (Test-Path -LiteralPath $runtimePath -PathType Container) {
    $runtimeScripts = Get-ChildItem -LiteralPath $runtimePath -Recurse -File -Filter "*.cs"
    if ($runtimeScripts.Count -gt 0) {
        throw "Selection Suite should not contain runtime scripts."
    }
}

$scene = Get-Content -LiteralPath (Join-Path $root "$samplePath/SelectionSuiteDemo.unity") -Raw
if ($scene -notmatch "m_AssemblyName: JorisHoef\.SelectionSuite\.Samples\.SelectionDemo") {
    throw "Sample scene does not reference the Selection Demo sample assembly."
}

$forbiddenProjectScaffolding = @("Assets", "Packages", "ProjectSettings")
foreach ($directory in $forbiddenProjectScaffolding) {
    $path = Join-Path $root $directory
    if (Test-Path -LiteralPath $path -PathType Container) {
        throw "Package repository should not contain Unity project scaffolding directory: $directory"
    }
}

$generatedArtifacts = Get-ChildItem -LiteralPath $root -Recurse -Force -File |
    Where-Object { $_.Name -match "\.(unitypackage|zip|tar|tgz)$" }
if ($generatedArtifacts.Count -gt 0) {
    throw "Generated artifacts are present in the package repository."
}

Write-Host "JorisHoef Selection Suite package validation passed."
