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
		perl


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