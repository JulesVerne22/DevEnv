FROM registry.fedoraproject.org/fedora-toolbox:latest

ARG NAME=toolbox

LABEL name="$NAME" \
      summary="Fedora toolbox container" \
      maintainer="Julian Smith"

ENV EDITOR=nvim

ENV NODE_VERSION=21.7.1 

ENV PATH=$PATH:$HOME/go/bin:$HOME/.local/share/nvim/mason/bin

RUN dnf -y upgrade \
  && dnf -y install \
  tmux \
  ruby \
  php-common \
  php-cli \
  luarocks \
  curl \
  python3 \
  python3-pip \
  java-latest-openjdk-devel \
  ripgrep \
  fd-find \
  git \
  neovim \
  golang \
  cargo \
  composer \
  julia-devel \
  lua5.1 \
  && dnf clean all

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

ENV NVM_DIR="$HOME/.nvm"

RUN . $HOME/.nvm/nvm.sh && nvm install $NODE_VERSION && nvm alias default $NODE_VERSON \
    && nvm use default && . $HOME/.nvm/bash_completion

ENV NODE_PATH=$NVM_DIR/v$NODE_VERSION/lib/node_modules

RUN pip3 install pynvim

RUN npm install -g neovim

RUN go install github.com/jesseduffield/lazygit@latest

RUN cargo install tree-sitter-cli

RUN git clone https://github.com/JulesVerne22/JulianSmith.nvim.git ~/.config/nvim

RUN npm install -g eslint_d

RUN nvim --headless "+Lazy! sync" +qa

RUN nvim --headless "+MasonInstall codelldb delve gopls clangd lua-language-server pyright rust-analyzer typescript-language-server eslint_d flake8 black gofumpt prettier stylua clang-format" +qa

RUN cp -f /usr/bin/lua-5.1 /usr/bin/lua

COPY ./.tmux.conf /root/.tmux.conf

CMD /bin/bash 
