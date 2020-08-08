<?php include_once __DIR__ . '/vendor/autoload.php';
use phpseclib\Net\SSH2;

$dotenv = Dotenv\Dotenv::createImmutable(__DIR__);
$dotenv->load();

error_reporting(E_ALL); 
ini_set('display_errors', E_ALL);
session_start();

extract($_POST);

$dir = __DIR__ . "/apps/{$domain}";

if(!file_exists($dir)) {
  mkdir($dir, 0777, true);
}

# Pega a porta
if(!file_exists("{$dir}/port.txt")) {
  $port = (int) file_get_contents(__DIR__ . '/lastport.txt');
  file_put_contents(__DIR__ . '/lastport.txt', $port + 1);
  file_put_contents("{$dir}/port.txt", $port);
}

# Pega a key
if(!file_exists("{$dir}/key.txt")) {
  file_put_contents("{$dir}/key.txt", md5(time() . $app . $domain));
}

# Pega a app
if(!file_exists("{$dir}/app.txt")) {
  file_put_contents("{$dir}/app.txt", $app);
}

$port = file_get_contents("{$dir}/port.txt");
$key = file_get_contents("{$dir}/key.txt");
$app = file_get_contents("{$dir}/app.txt");

$keys   = ['{domain}', '{app}', '{port}', '{updatekey}', '{webroot}'];
$values = [$domain, $app, $port, $key, $dir];

$_SESSION['config'] = array_combine($keys, $values);

# Configurações do NGINX
if(!file_exists("/etc/nginx/sites-enabled/{$domain}.conf"))
  file_put_contents("/etc/nginx/sites-enabled/{$domain}.conf", str_replace($keys, $values, file_get_contents(__DIR__ . '/sample/nginx.conf')));

# Configurações NPM
if(!file_exists("{$dir}/package.json"))
  file_put_contents("{$dir}/package.json", str_replace($keys, $values, file_get_contents(__DIR__ . '/sample/package.json')));

# Configurações do servidor NodeJS
if(!file_exists("{$dir}/index.mjs"))
  file_put_contents("{$dir}/index.mjs", str_replace($keys, $values, file_get_contents(__DIR__ . '/sample/index.mjs')));

# Within a controller for example:
$ssh = new SSH2('127.0.0.1');
if (!$ssh->login($_ENV['USER_NAME'], $_ENV['USER_PASS'])) {
    # Login failed, do something
    exit('falha');
}
$root = new SSH2('127.0.0.1');
if (!$root->login($_ENV['ROOT_NAME'], $_ENV['ROOT_PASS'])) {
    # Login failed, do something
    exit('falha');
}
$root->exec("chmod 0777 $dir");
$root->exec("cd $dir && npm install");
$ssh->exec("pm2 delete '{$domain}:{$port}'");
$ssh->exec("pm2 start node --name='{$domain}:{$port}' -- $dir/index.mjs");
$root->exec("certbot --nginx --noninteractive --agree-tos -d $domain -m 'albreisdev@gmail.com'");
$root->exec("nginx -s reload");