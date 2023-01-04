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
		nano \
		go \
		hydra \
		build-base \
		zsh \
		perl \
		openssl-dev \
		p7zip


# tzdata
RUN cp /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

# rust + cargo
RUN cd /tmp && \
	curl https://sh.rustup.rs -o rustup.sh && \
	chmod +x rustup.sh && \
	./rustup.sh -y

ENV CARGOPATH /root/.cargo
ENV PATH ${CARGOPATH}/bin:${PATH}

# Oh-My-Zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# seclists
RUN cd ${HOME}/wordlists && \
    git clone --depth 1 https://github.com/danielmiessler/SecLists.git 

# go
ENV GOPATH /root/go
ENV PATH ${GOPATH}/bin:${PATH}

# gobuster
RUN go install github.com/OJ/gobuster/v3@latest

# rustscan
RUN cd ${HOME}/toolkit && \
	git clone https://github.com/RustScan/RustScan.git && \
	cd RustScan && \
	cargo build && \
	ln -sf $('pwd')/target/debug/rustscan /usr/bin/rustscan

# amass
RUN go install -v github.com/OWASP/Amass/v3/...@master

# nikto
RUN cd ${HOME}/toolkit && \
	git clone https://github.com/sullo/nikto && \
	ln -sf $('pwd')/nikto/program/nikto.pl /usr/bin/nikto

# john
RUN cd ${HOME}/toolkit && \
	git clone https://github.com/openwall/john.git && \
	cd john/src && \
	./configure && make && \
	echo "alias john='/root/toolkit/john/run/john'" >> ${HOME}/.zshrc

# ffuf
RUN go install github.com/ffuf/ffuf@latest

# anew
RUN go install -v github.com/tomnomnom/anew@latest

# httpx
RUN go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest

# nuclei
RUN go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest

# nuclei-templates
RUN mkdir ${HOME}/toolkit/nuclei-templates && \
	nuclei -ud /root/toolkit/nuclei-templates

# subfinder
RUN go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest

# naabu
RUN go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest

# interactsh
RUN go install -v github.com/projectdiscovery/interactsh/cmd/interactsh-client@latest

# notify
RUN go install -v github.com/projectdiscovery/notify/cmd/notify@latest

# openrisk
RUN go install -v github.com/projectdiscovery/openrisk@latest

# katana
RUN go install github.com/projectdiscovery/katana/cmd/katana@latest

# uncover
RUN go install -v github.com/projectdiscovery/uncover/cmd/uncover@latest