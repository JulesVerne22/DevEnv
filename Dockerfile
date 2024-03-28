FROM ubuntu:latest

RUN mkdir /dev-env

WORKDIR /dev-env

ENV TZ=America/Chicago

ENV NODE_VERSION=21.7.1 

ENV HOME=/root

ENV PATH=$PATH:/opt/nvim-linux64/bin:/usr/local/go/bin:/usr/local/bin/julia/bin:$HOME/.local/share/nvim/mason/bin:$HOME/.local/bin:$HOME/.nvm/versions/node/v$NODE_VERSION/bin:$HOME/.cargo/bin

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt update && apt upgrade -y

RUN apt install -y tmux ruby php-common libapache2-mod-php php-cli luarocks curl \
    python3 python3-pip default-jre ripgrep fd-find git python3.10-venv locales

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen

ENV LANG=en_US.UTF-8

ENV LANGUAGE=en_US:en

ENV LC_ALL=en_US.UTF-8

RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz \
    && tar -C /opt -xzf nvim-linux64.tar.gz \
    && rm nvim-linux64.tar.gz

RUN curl -LO https://go.dev/dl/go1.22.1.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go1.22.1.linux-amd64.tar.gz \
    && rm go1.22.1.linux-amd64.tar.gz

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

ENV NVM_DIR="$HOME/.nvm"

RUN . $HOME/.nvm/nvm.sh && nvm install $NODE_VERSION && nvm alias default $NODE_VERSON \
    && nvm use default && . $HOME/.nvm/bash_completion

ENV NODE_PATH=$NVM_DIR/v$NODE_VERSION/lib/node_modules

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

RUN curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php \
    && php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && rm /tmp/composer-setup.php

RUN wget https://julialang-s3.julialang.org/bin/linux/x64/1.10/julia-1.10.2-linux-x86_64.tar.gz \
    && tar zxvf julia-1.10.2-linux-x86_64.tar.gz \
    && rm julia-1.10.2-linux-x86_64.tar.gz \
    && mv julia-1.10.2 /usr/local/bin/julia

RUN pip3 install pynvim==0.4.3

RUN npm install -g neovim

RUN go install github.com/jesseduffield/lazygit@latest

RUN cargo install tree-sitter-cli

RUN ln -s $(which fdfind) /usr/local/bin/fd

RUN git clone https://github.com/JulesVerne22/JulianSmith.nvim.git ~/.config/nvim

RUN npm install -g eslint_d

RUN nvim --headless "+Lazy! sync" +qa

RUN nvim --headless "+MasonInstall codelldb delve gopls clangd lua-language-server pyright rust-analyzer typescript-language-server eslint_d flake8 black gofumpt prettier stylua clang-format" +qa

COPY ./.tmux.conf /root/.tmux.conf

CMD /bin/bash 
