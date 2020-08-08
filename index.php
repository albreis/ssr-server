<?php session_start(); ?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>SSR Server para Aplicativos SPA</title>
  <style>
    body{position:absolute;width:100%;height:100%;display:flex;justify-content:center;align-items:center;}
    input{height: 30px;width:20vw;padding: 0 15px;}
  </style>
</head>
<body>
  <form method="post" action="/install.php">
    <label>Domínio do Site</label><br/>
    <input type="text" name="domain" /><br/><br/>
    <label>Domínio do APP</label><br/>
    <input type="text" name="app" /><br/><br/>
    <button>Enviar</button>
    <?php if(isset($_SESSION['config'])): ?>
    <h2>Dados do app</h2>
    <hr>
    <div>
      APP: <?php echo $_SESSION['config']['{app}']; ?><br/>
      Domínio: <?php echo $_SESSION['config']['{domain}']; ?><br/>
      Chave para limpeza de cache: <?php echo $_SESSION['config']['{updatekey}']; ?><br/>
    </div>
    <?php endif; ?>
  </form>
</body>
</html>