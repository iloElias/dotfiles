# Repositório de backup de configurações

Este repositório guarda arquivos de configuração do meu usuário na distro Ubuntu.

## Como usar

Clone o repositório em `~/dotfiles`:

```bash
git clone <url-do-repo> ~/dotfiles
```

Execute o script de setup para instalar e configurar tudo automaticamente:

```bash
bash ~/dotfiles/setup.sh
```

O `setup.sh` instala e configura: Chrome, Composer, Docker, Node, VSCode (Insiders), Copilot, JetBrains Toolbox e o terminal (zsh + fontes).

Após o setup, as configurações de shell (`.bashrc`, `.zshrc`, `.inputrc`) são copiadas para `$HOME`. Abra um novo terminal para que as aliases e configurações entrem em vigor.

### Atualizar configurações do shell

Para replicar alterações feitas nos dotfiles para os arquivos de configuração do sistema:

```bash
update-rc
```
