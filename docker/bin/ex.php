<?php
require('/cafemaker/bin/json5/SyntaxError.php');
require('/cafemaker/bin/json5/Json5Decoder.php');
require('/cafemaker/bin/json5/global.php');

$schema = [];
$bom = "\xEF\xBB\xBF";
foreach (scandir('/vagrant/data/SaintCoinach.Cmd/Definitions') as $file) {
  $fileinfo = pathinfo($file);
  if ($fileinfo['extension'] === 'json') {
    $contents = file_get_contents('/vagrant/data/SaintCoinach.Cmd/Definitions/'. $file);
    $contents = preg_replace("/^$bom/", '', $contents);
    $table = json5_decode($contents, true);
    $schema[] = $table;
  }
}
$schema = array_values(array_filter($schema));
$version = trim(file_get_contents('/vagrant/data/SaintCoinach.Cmd/Definitions/game.ver'));
file_put_contents('/vagrant/data/SaintCoinach.Cmd/ex.json', json_encode([
  'version' => $version,
  'sheets' => $schema
], JSON_PRETTY_PRINT));
