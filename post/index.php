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
					fwrite($fp, $content.PHP_EOL);
				}
				fclose($fp);
				l('File written successfully.');
				
				$cmd = array();
				$cmd[] = 'cd /var/www/stuart.life';
				$cmd[] = '/usr/bin/git add .';
				$cmd[] = '/usr/bin/git commit -m "'.date('Y-m-d-Hi', $ts).'"';
				$cmd[] = '/usr/bin/git push';
				$cmd[] = 'cd /var/www/stuart.life/src';
				$cmd[] = '/usr/local/bin/jekyll build';
				// Intentional repeat.
				$cmd[] = '/usr/local/bin/jekyll build';
				$cmd = implode($cmd, ' 2>&1 && ').' 2>&1';
				$output = `$cmd`;
				foreach (explode($output, "\n") as $line) {
					l(rtrim($line));
				}
			}
		}
		
		echo '</ul></p>';
	}
	
	require 'form.html';
