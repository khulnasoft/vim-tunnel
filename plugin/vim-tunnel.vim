""
" @usage {}
" Run Tunnel against the current directory and populate the QuickFix list
command! Tunnel call s:Tunnel()

""
" @usage {}
" Install the latest version of Tunnel to %GOPATH/bin/Tunnel
command! TunnelInstall call s:TunnelInstall()


" Tunnel runs Tunnel and prints adds the results to the quick fix buffer
function! s:Tunnel() abort
  try
		" capture the current error format
		let errorformat = &g:errorformat

		let s:template = '"@' . expand('<sfile>:p:h:h') . '/vim-tunnel/csv.tpl"'
		let s:command = 'tunnel fs -q --security-checks vuln,config --exit-code 0 -f template --template ' . s:template . ' . | sort -u | sed -r "/^\s*$/d"'
		
 		" set the error format for use with Tunnel
		let &g:errorformat = '%f\,%l\,%m'
		" get the latest Tunnel comments and open the quick fix window with them
		cgetexpr system(s:command) | cw
		call setqflist([], 'a', {'title' : ':Tunnel'})
		copen
	finally
		" restore the errorformat value
		let &g:errorformat = errorformat
  endtry
endfunction

" TunnelInstall runs the go install command to get the latest version of Tunnel
function! s:TunnelInstall() abort
	try 
		echom "Downloading the latest version of Tunnel"
    let installResult = system('curl https://raw.githubusercontent.com/khulnasoft/tunnel/main/contrib/install.sh | bash')
		if v:shell_error != 0
    	echom installResult
		else
			echom "Tunnel downloaded successfully"
		endif
	endtry
endfunction
