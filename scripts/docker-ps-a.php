<?php

/**
 * @return array{
 *     Command: string,
 *     CreatedAt: string,
 *     ID: string,
 *     Image: string,
 *     Labels: string,
 *     LocalVolumes: string,
 *     Mounts: string,
 *     Names: string,
 *     Networks: string,
 *     Platform: array{
 *       architecture: string,
 *       os: string,
 *     },
 *     Ports: string,
 *     RunningFor: string,
 *     Size: string,
 *     State: string,
 *     Status: string
 * }[]
 */
function getDockerProcesses() {
    $dockerReturn = shell_exec('docker ps -a --format json');

    $splitedDockerReturn = explode("\n", $dockerReturn);

    $processedDockerReturn = implode(",", array_filter($splitedDockerReturn, function ($line) {
        return trim($line) !== '';
    }));

    return json_decode("[{$processedDockerReturn}]", true);
}

$columns = [
    'Image',
    'Status',
    'Ports',
    'RunningFor',
    'Size',
    'State',
    'Status',
];

$dockerProcesses = getDockerProcesses();

// Calculate the max width for each column based on data and header
$colWidths = [];
foreach ($columns as $col) {
    $colWidths[$col] = mb_strlen($col);
}
foreach ($dockerProcesses as $process) {
    foreach ($columns as $col) {
        $length = isset($process[$col]) ? mb_strlen((string)$process[$col]) : 0;
        if ($length > $colWidths[$col]) {
            $colWidths[$col] = $length;
        }
    }
}

// Build table-like string
$print = '';

// Print header row
foreach ($columns as $col) {
    $print .= str_pad($col, $colWidths[$col] + 2);
}
$print .= PHP_EOL;

// Print separator row
foreach ($columns as $col) {
    $print .= str_repeat('-', $colWidths[$col]) . "  ";
}
$print .= PHP_EOL;

// Print data rows
foreach ($dockerProcesses as $process) {
    foreach ($columns as $col) {
        $value = isset($process[$col]) ? $process[$col] : '';
        $print .= str_pad($value, $colWidths[$col] + 2);
    }
    $print .= PHP_EOL;
}

echo $print;
