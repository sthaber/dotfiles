# Extensions

Nothing here installs automatically. VSCode holds its extension list per install, and the settings
and keybindings in this directory are reference copies — the editor reads its own copies on the
client machine.

## Client (Mac or Windows)

These run in the editor UI, so they must be installed locally, not on the remote host.

    code --install-extension ms-vscode-remote.remote-ssh
    code --install-extension tuttieee.emacs-mcx
    code --install-extension stkb.rewrap

Cursor ships Remote-SSH built in; VSCode does not. Without it nothing else here matters.

`emacs-mcx` and `rewrap` are the two extensions the keybindings assume: every `emacs-mcx.*` binding
and `ctrl+q` / `cmd+q` rewrap comes from them.

## Remote (this host)

Run these from a terminal inside a connected VSCode window, so `code` is the remote CLI:

    code --install-extension anthropic.claude-code
    code --install-extension charliermarsh.ruff
    code --install-extension davidsanders.search-under-cursor
    code --install-extension jtanx.ctagsx
    code --install-extension ms-python.python
    code --install-extension rust-lang.rust-analyzer
    code --install-extension xaver.clang-format

## Qumulo extensions

Not on the marketplace. Built from the repo and installed from the .vsix files:

    code --install-extension ~/src/tools/editors/vscode/qumulo-extension-0.2.1.vsix
    code --install-extension ~/src/tools/editors/vscode/qumulo-c-language/qumulo-c-language-1.1.0.vsix
    code --install-extension ~/src/tools/editors/vscode/qumulo-x-language/qumulo-x-language-1.1.0.vsix

`build_extension.sh` in that directory rebuilds them. `qumuloC.toggleHeaderSource` and
`qumuloC.openAffiliatedCFiles` in the keybindings come from qumulo-c-language.

## Python language server

Cursor used `anysphere.cursorpyright`, its own Pylance fork, which VSCode cannot install. The
workspace sets `python.languageServer` to `None`, so no language server ran anyway. To get Python
completion back, install `ms-python.vscode-pylance` and set `python.languageServer` to `Pylance`.
