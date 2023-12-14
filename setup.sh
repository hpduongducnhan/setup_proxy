#!/bin/bash

PROXY_ADDR="http://username:password@proxy_server:port"
NO_PROXY="localhost,127.0.0.1"

DOCKER_PROXY_DROPIN_DIR="/etc/systemd/system/docker.service.d"
DOCKER_PROXY_CONFIG_FILE="${DOCKER_PROXY_DROPIN_DIR}/http-proxy.conf"

APT_PROXY_DROPIN_DIR="/etc/apt/apt.conf.d"
APT_PROXY_CONFIG_FILE="${APT_PROXY_DROPIN_DIR}/91proxy"

ENVIRONMENT_PROXY_FILE="/etc/environment"

BASHRC_PROXY_FILE="${HOME}/.bashrc"

configure-proxy-docker() {
    echo "Configuring Docker proxy settings..."
    if [ -f "${DOCKER_PROXY_CONFIG_FILE}" ]; then
        echo "http-proxy.conf already exists."
        if grep -qE "Environment=\"HTTP_PROXY=${PROXY_ADDR}\"" "${DOCKER_PROXY_CONFIG_FILE}" && \
            grep -qE "Environment=\"HTTPS_PROXY=${PROXY_ADDR}\"" "${DOCKER_PROXY_CONFIG_FILE}"; then
            echo "Proxy configurations in http-proxy.conf are already set."
        else
            echo "Appending proxy configurations to http-proxy.conf."
            echo "[Service]" > "${DOCKER_PROXY_CONFIG_FILE}"
            echo "Environment=\"HTTP_PROXY=${PROXY_ADDR}\"" >> "${DOCKER_PROXY_CONFIG_FILE}"
            echo "Environment=\"HTTPS_PROXY=${PROXY_ADDR}\"" >> "${DOCKER_PROXY_CONFIG_FILE}"
            echo "Environment=\"NO_PROXY=${NO_PROXY}\"" >> "${DOCKER_PROXY_CONFIG_FILE}"
            echo "Proxy configurations in http-proxy.conf have been updated."
            systemctl daemon-reload
            systemctl restart docker
            echo "Docker service restarted."
        fi
    else
        echo "create ${DOCKER_PROXY_DROPIN_DIR} directory"
        sudo mkdir -p "${DOCKER_PROXY_DROPIN_DIR}"
        echo "Creating http-proxy.conf with proxy configurations."
        echo "[Service]" > "${DOCKER_PROXY_CONFIG_FILE}"
        echo "Environment=\"HTTP_PROXY=${PROXY_ADDR}\"" >> "${DOCKER_PROXY_CONFIG_FILE}"
        echo "Environment=\"HTTPS_PROXY=${PROXY_ADDR}\"" >> "${DOCKER_PROXY_CONFIG_FILE}"
        echo "Environment=\"NO_PROXY=${NO_PROXY}\"" >> "${DOCKER_PROXY_CONFIG_FILE}"
        systemctl daemon-reload
        systemctl restart docker
        echo "Proxy settings for Docker configured successfully."
    fi
}

configure-proxy-apt() {
    echo "Configuring APT proxy settings..."
    if [ -f "${APT_PROXY_CONFIG_FILE}" ]; then
        echo "APT proxy configuration file already exists."
        if grep -qE "Acquire::http::Proxy \"${PROXY_ADDR}\";" "${APT_PROXY_CONFIG_FILE}" && \
            grep -qE "Acquire::https::Proxy \"${PROXY_ADDR}\";" "${APT_PROXY_CONFIG_FILE}" && \
            grep -qE "Acquire::ftp::Proxy \"${PROXY_ADDR}\";" "${APT_PROXY_CONFIG_FILE}"; then
            echo "Proxy configurations in apt.conf are already set."
        else
            echo "Updating proxy configurations in apt.conf..."
            echo "Acquire::http::Proxy \"${PROXY_ADDR}\";" >> "${APT_PROXY_CONFIG_FILE}"
            echo "Acquire::https::Proxy \"${PROXY_ADDR}\";" >> "${APT_PROXY_CONFIG_FILE}"
            echo "Acquire::ftp::Proxy \"${PROXY_ADDR}\";" >> "${APT_PROXY_CONFIG_FILE}"
            echo "Proxy configurations in apt.conf have been updated."
        fi
    else
        echo "Creating APT proxy configuration file..."
        sudo touch "${APT_PROXY_CONFIG_FILE}"
        echo "Add proxy config to file..."
        echo "Acquire::http::Proxy \"${PROXY_ADDR}\";" >> "${APT_PROXY_CONFIG_FILE}"
        echo "Acquire::https::Proxy \"${PROXY_ADDR}\";" >> "${APT_PROXY_CONFIG_FILE}"
        echo "Acquire::ftp::Proxy \"${PROXY_ADDR}\";" >> "${APT_PROXY_CONFIG_FILE}"
        echo "APT proxy configuration file created."
    fi
}

configure-proxy-environment() {
    echo "Configuring Environment proxy settings..."
    if [ -f "${ENVIRONMENT_PROXY_FILE}" ]; then
        echo "Environment proxy configuration file already exists."
        if grep -qE "export http_proxy=${PROXY_ADDR}" "${ENVIRONMENT_PROXY_FILE}" && \
            grep -qE "export https_proxy=${PROXY_ADDR}" "${ENVIRONMENT_PROXY_FILE}" && \
            grep -qE "export no_proxy=${NO_PROXY}" "${ENVIRONMENT_PROXY_FILE}" && \
            grep -qE "export HTTP_PROXY=${PROXY_ADDR}" "${ENVIRONMENT_PROXY_FILE}" && \
            grep -qE "export HTTPS_PROXY=${PROXY_ADDR}" "${ENVIRONMENT_PROXY_FILE}" && \
            grep -qE "export NO_PROXY=${NO_PROXY}" "${ENVIRONMENT_PROXY_FILE}"; then
            echo "Proxy configurations in ${ENVIRONMENT_PROXY_FILE} are already set."
        else
            echo "Updating proxy configurations in ${ENVIRONMENT_PROXY_FILE}..."
            echo "export http_proxy=${PROXY_ADDR}" >> "${ENVIRONMENT_PROXY_FILE}"
            echo "export https_proxy=${PROXY_ADDR}" >> "${ENVIRONMENT_PROXY_FILE}"
            echo "export no_proxy=${NO_PROXY}" >> "${ENVIRONMENT_PROXY_FILE}"
            echo "export HTTP_PROXY=${PROXY_ADDR}" >> "${ENVIRONMENT_PROXY_FILE}"
            echo "export HTTPS_PROXY=${PROXY_ADDR}" >> "${ENVIRONMENT_PROXY_FILE}"
            echo "export NO_PROXY=${NO_PROXY}" >> "${ENVIRONMENT_PROXY_FILE}"
            echo "Proxy configurations in ${ENVIRONMENT_PROXY_FILE} have been updated."
        fi
    fi
}

configure-proxy-bashrc() {
    echo "Configuring bashrc proxy settings..."
    if [ -f "${BASHRC_PROXY_FILE}" ]; then
        echo "bashrc proxy configuration file already exists."
        if grep -qE "export http_proxy=${PROXY_ADDR}" "${BASHRC_PROXY_FILE}" && \
            grep -qE "export https_proxy=${PROXY_ADDR}" "${BASHRC_PROXY_FILE}" && \
            grep -qE "export no_proxy=${NO_PROXY}" "${BASHRC_PROXY_FILE}" && \
            grep -qE "export HTTP_PROXY=${PROXY_ADDR}" "${BASHRC_PROXY_FILE}" && \
            grep -qE "export HTTPS_PROXY=${PROXY_ADDR}" "${BASHRC_PROXY_FILE}" && \
            grep -qE "export NO_PROXY=${NO_PROXY}" "${BASHRC_PROXY_FILE}"; then
            echo "Proxy configurations in ${BASHRC_PROXY_FILE} are already set."
        else
            echo "Updating proxy configurations in ${BASHRC_PROXY_FILE}..."
            echo "export http_proxy=${PROXY_ADDR}" >> "${BASHRC_PROXY_FILE}"
            echo "export https_proxy=${PROXY_ADDR}" >> "${BASHRC_PROXY_FILE}"
            echo "export no_proxy=${NO_PROXY}" >> "${BASHRC_PROXY_FILE}"
            echo "export HTTP_PROXY=${PROXY_ADDR}" >> "${BASHRC_PROXY_FILE}"
            echo "export HTTPS_PROXY=${PROXY_ADDR}" >> "${BASHRC_PROXY_FILE}"
            echo "export NO_PROXY=${NO_PROXY}" >> "${BASHRC_PROXY_FILE}"
            echo "Proxy configurations in ${BASHRC_PROXY_FILE} have been updated."
        fi
    fi
}

first-setup-ubuntu() {
    sudo apt-get update -y
    sudo apt-get upgrade -y
    configure-proxy-docker
    configure-proxy-apt
    configure-proxy-environment
    configure-proxy-bashrc
}

# Execute the first setup
#first-setup-ubuntu
configure-proxy-docker
configure-proxy-apt
configure-proxy-environment
configure-proxy-bashrc
