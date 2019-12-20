# 参数
$opt = $args[0];

# 要更新的路径
$paths = [System.Collections.ArrayList]@("path1", "path2");

function cleanPaths {
    <#
    .SYNOPSIS
        remove illegal path in list
    #>
    $wrongPath = New-Object -TypeName System.Collections.ArrayList;
    foreach ($path in $paths) {
        if (!(Test-Path -Path $path -PathType Container)) {
            Write-Output "'$path' is not a directory or does not exist!";
            # 路径不存在或不是目录
            $wrongPath.Add($path) | Out-Null;
        }
    }
    foreach ($path in $wrongPath) {
        $paths.Remove($path);
    }
}

function runCommand {
    <#
    .SYNOPSIS
        run command
    .PARAMETER message
        message string
    .PARAMETER command
        command string
    #>
    param([string]$message, [string]$command);
    Write-Output "`n********************************";
    Write-Host -ForegroundColor Red $message;
    Write-Output "********************************`n";
    foreach ($path in $paths) {
        Write-Output "--------------------------------";
        # 路径存在且是目录
        Set-Location $path;
        Write-Host -ForegroundColor Green (Get-Location).ToString();
        Invoke-Expression $command;
        Write-Output "--------------------------------";
    }
}

function branch {
    <#
    .SYNOPSIS
        git branch
    .DESCRIPTION
        run 'git branch -vv'
    #>
    $message = "barnch!";
    $command = "git branch -vv";
    runCommand -message $message -command $command;
}

function fetchAllPrune {
    <#
    .SYNOPSIS
        git fetch
    .DESCRIPTION
        run 'git fetch --all --prune'
    #>
    $message = "fetch!";
    $command = "git fetch --all --prune";
    runCommand -message $message -command $command;
}

function status {
    <#
    .SYNOPSIS
        git status
    .DESCRIPTION
        run 'git status --untracked-files --show-stash'
    #>
    $message = "status!";
    $command = "git status --untracked-files --show-stash";
    runCommand -message $message -command $command;
}

cleanPaths;
if ($opt -eq "fa") {
    fetchAllPrune;
} elseif ($opt -eq "st") {
    status;
} else {
    branch;
}
