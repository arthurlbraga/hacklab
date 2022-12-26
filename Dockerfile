FROM alpine

LABEL maintainer="Arthur Braga"

# Environment Variables
ENV HOME /root

# Working Directory
WORKDIR /root
RUN mkdir ${HOME}/toolkit && \
    mkdir ${HOME}/wordlists

# Install Essentials
RUN apk update && \
	apk add git \
		python3 \
		curl \
		tzdata \
		nmap \
		py3-pip \
		nikto \
		nano \
		go \
		hydra \
		build-base


# tzdata
RUN cp /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

# rust + cargo
RUN cd /tmp && \
	curl https://sh.rustup.rs -o rustup.sh && \
	chmod +x rustup.sh && \
	./rustup.sh -y && \
	source ~/.profile

# Oh-My-Zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# seclists
RUN cd ${HOME}/wordlists && \
    git clone --depth 1 https://github.com/danielmiessler/SecLists.git 

# go
ENV GOPATH /root/go
ENV PATH ${GOPATH}/bin:${PATH}

# zsh
RUN git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh &&\
    cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc &&\
    chsh -s /bin/zsh && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.zsh-syntax-highlighting" --depth 1 && \
    echo "source $HOME/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> "$HOME/.zshrc"

# gobuster
go install github.com/OJ/gobuster/v3@latest

# rustscan
RUN cd ${HOME}/toolkit && \
	git clone https://github.com/RustScan/RustScan.git && \
	cd RustScan && \
	cargo build && \
	ln -sf target/debug/rustscan /usr/bin/rustscan

# amass
RUN go install -v github.com/OWASP/Amass/v3/...@master