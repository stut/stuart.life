<?php
	function l($msg, $error = false) {
		echo '<li style="color: '.($error ? 'red' : 'black').'; font-weight: '.($error ? 'bold' : 'normal').';">'.$msg.'</li>';
	}
	function e($msg) { l($msg, true); }

	define('BASEPATH', realpath(__DIR__.'/../src/_posts'));

	require __DIR__.'/header.html';
	register_shutdown_function(function() { require __DIR__.'/footer.html'; });

	if (!empty($_POST)) {
		echo '<p><ul>';

		$ts = strtotime($_POST['metadata']['date']);
		if (!$ts) {
			e('Invalid date!');
		} else {
			$dest = BASEPATH.DIRECTORY_SEPARATOR.date('Y-m-d-Hi', $ts).'.md';
			l('Dest: '.htmlspecialchars(substr($dest, strlen('/var/www/stuart.life'))));
			
			if (file_exists($dest)) {
				e('File already exists!');
			} else {
				$fp = fopen($dest, 'wt');
				fwrite($fp, '---'.PHP_EOL);
				foreach ($_POST['metadata'] as $key => $val) {
					if (!empty($val)) {
						fwrite($fp, $key.': '.$val.PHP_EOL);
					}
				}
				fwrite($fp, '---'.PHP_EOL);
				if (strlen(trim($_POST['content'])) > 0) {
					fwrite($fp, $_POST['content'].PHP_EOL);
				}
				fclose($fp);
				l('File written successfully.');
				
				$cmd = array();
				$cmd[] = 'PATH=/usr/local/bin:/usr/bin cd /var/www/stuart.life/src';
				$cmd[] = 'jekyll build';
				// Intentional repeat.
				$cmd[] = 'jekyll build';
				$cmd[] = 'cd /var/www/stuart.life';
				$cmd[] = 'git add --all .';
				$cmd[] = 'git commit -a -m "'.date('Y-m-d-Hi', $ts).'"';
				$cmd[] = 'git push';
				$cmd = implode($cmd, ' 2>&1 && ').' 2>&1';
				ob_start();
				passthru($cmd);
				echo '</ul>';
				echo '<pre style="white-space: nowrap;">'.ob_get_clean().'</pre>';
				echo '<ul>';
			}
		}
		
		echo '</ul></p>';
		
		exit;
	}
	
	require 'form.html';
