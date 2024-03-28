FROM ubuntu:latest

RUN mkdir /dev-env

WORKDIR /dev-env

RUN apt update && apt upgrade -y

RUN apt install -y tmux ruby php-common libapache2-mod-php php-cli luarocks curl \
    python3 python3-pip default-jre ripgrep fd-find git

RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz \
    && tar -C /opt -xzf nvim-linux64.tar.gz \
    && rm nvim-linux64.tar.gz

RUN curl -LO https://go.dev/dl/go1.22.1.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go1.22.1.linux-amd64.tar.gz \
    && rm go1.22.1.linux-amd64.tar.gz

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

RUN nvm install node

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

RUN apt install python3.10-venv

RUN ln -s $(which fdfind) ~/.local/bin/fd

RUN git clone https://github.com/JulesVerne22/JulianSmith.nvim.git ~/.config/nvim

RUN echo 'export PATH="$PATH:/opt/nvim-linux64/bin:/usr/local/bin/go:/usr/local/bin/julia/bin:$HOME/.local/share/nvim/mason/bin:$HOME/.local/bin"' >> /root/.bashrc

CMD /bin/bash 
