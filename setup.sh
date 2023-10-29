#!/bin/bash

# Tested on Macbook Air Apple M1 macOS Ventura 13.2
# Reference: https://github.com/renemarc/dotfiles/blob/master/executable_dotfiles.sh

# -e: exit on error
# -u: exit on unset variables
set -eu

command_exists() {
    command -v "$@" >/dev/null 2>&1
}

error() {
    printf -- "%sError: $*%s\n" >&2 "$RED" "$RESET"
}

setup_color() {
    # Only use colors if connected to a terminal
    if [ -t 1 ]; then
        RED=$(printf '\033[31m')
        BLUE=$(printf '\033[34m')
        BOLD=$(printf '\033[1m')
        RESET=$(printf '\033[m')
    else
        RED=""
        BLUE=""
        BOLD=""
        RESET=""
    fi
}

import_repo() {
    repo=$1
    destination=$2
    if uname | grep -Eq '^(cygwin|mingw|msys)'; then
        uuid=$(powershell -NoProfile -Command "[guid]::NewGuid().ToString()")
    else
        uuid=$(uuidgen)
    fi
    TMPFILE=$(mktemp /tmp/dotfiles."${uuid}".tar.gz) || exit 1
    curl -s -L -o "$TMPFILE" "$repo" || exit 1
    chezmoi import --strip-components 1 --destination "$destination" "$TMPFILE" || exit 1
    rm -f "$TMPFILE"
}

# Setup dependencies
setup_dependencies() {
    printf -- "\n%sSetting up dependencies:%s\n\n" "$BOLD" "$RESET"

    # Install Xcode command line tools if not already installed.
    if ! command_exists xcode-select; then
        printf -- "%sInstalling Xcode command line tools...%s\n" "$BLUE" "$RESET"
        xcode-select --install
    fi

    # Install Homebrew if not already installed.
    if ! command_exists brew; then
        printf -- "%sInstalling Homebrew...%s\n" "$BLUE" "$RESET"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    # Install chezmoi if not already installed.
    if ! command_exists chezmoi; then
        printf -- "%sInstalling chezmoi...%s\n" "$BLUE" "$RESET"
        if [ "$(command -v curl)" ]; then
            sh -c "$(curl -fsSL https://git.io/chezmoi)"
        elif [ "$(command -v wget)" ]; then
            sh -c "$(wget -qO- https://git.io/chezmoi)"
        else
            echo "Failed to install chezmoi, you must have curl or wget installed." >&2
            exit 1
        fi
    fi
}

# Setup shell prompt
setup_shell_prompt() {
    printf -- "\n%sSetting up shell prompt:%s\n\n" "$BOLD" "$RESET"

    # Install Oh My Zsh
    PACKAGE_NAME='Oh My Zsh'
    printf -- "%sInstalling/updating %s...%s\n" "$BLUE" "$PACKAGE_NAME" "$RESET"
    CHEZMOIPATH=$(chezmoi source-path)
    rm -rf "$CHEZMOIPATH"/dot_oh-my-zsh/plugins
    import_repo 'https://github.com/robbyrussell/oh-my-zsh/archive/master.tar.gz' "${HOME}/.oh-my-zsh" || {
        error "import of ${PACKAGE_NAME} failed"
        exit 1
    }

    # Install Zsh plugins
    PACKAGE_NAME='zsh-autosuggestions'
    printf -- "%sInstalling/updating Zsh plugin: %s...%s\n" "$BLUE" "$PACKAGE_NAME" "$RESET"
    import_repo 'https://github.com/zsh-users/zsh-autosuggestions/archive/master.tar.gz' "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" || {
        error "import of ${PACKAGE_NAME} failed"
        exit 1
    }

    PACKAGE_NAME='zsh-syntax-highlighting'
    printf -- "%sInstalling/updating Zsh plugin: %s...%s\n" "$BLUE" "$PACKAGE_NAME" "$RESET"
    import_repo 'https://github.com/zsh-users/zsh-syntax-highlighting/archive/master.tar.gz' "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" || {
        error "import of ${PACKAGE_NAME} failed"
        exit 1
    }

    # Install Zsh themes
    PACKAGE_NAME='Powerlevel9k'
    printf -- "%sInstalling/updating Zsh theme: %s...%s\n" "$BLUE" "$PACKAGE_NAME" "$RESET"
    import_repo 'https://github.com/Powerlevel9k/powerlevel9k/archive/master.tar.gz' "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/themes/powerlevel9k" || {
        error "import of ${PACKAGE_NAME} failed"
        exit 1
    }

    PACKAGE_NAME='Powerlevel10k'
    printf -- "%sInstalling/updating Zsh theme: %s...%s\n" "$BLUE" "$PACKAGE_NAME" "$RESET"
    import_repo 'https://github.com/romkatv/powerlevel10k/archive/master.tar.gz' "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/themes/powerlevel10k" || {
        error "import of ${PACKAGE_NAME} failed"
        exit 1
    }

}

# Setup development tools
setup_dev_tools() {
    printf -- "\n%sSetting up development tools:%s\n\n" "$BOLD" "$RESET"

    # Install Homebrew packages with `brew bundle` if the os is macOS.
    if [ "$(uname -s)" = "Darwin" ]; then
        printf -- "%sInstalling/updating Homebrew packages...%s\n" "$BLUE" "$RESET"
        brew bundle --file="./.Brewfile" || {
            error "brew bundle failed"
            exit 1
        }
    fi

    # Install asdf plugins
    if command_exists asdf; then
        printf -- "%sInstalling/updating asdf plugins...%s\n" "$BLUE" "$RESET"
        asdf plugin add nodejs || {
            error "asdf plugin add nodejs failed"
            exit 1
        }
        asdf plugin add python || {
            error "asdf plugin add python failed"
            exit 1
        }
        asdf plugin add ruby || {
            error "asdf plugin add ruby failed"
            exit 1
        }
        asdf plugin add golang || {
            error "asdf plugin add golang failed"
            exit 1
        }
        asdf plugin update --all || {
            error "asdf plugin update --all failed"
            exit 1
        }

        asdf install golang latest
        asdf install nodejs latest
    fi
}

apply_dotfiles() {
    printf -- "\n%sApplying dotfiles:%s\n\n" "$BOLD" "$RESET"

    # except repo org name as parameter

}

# Entry point
main() {
    printf -- "Setting up your dotfiles...\n"

    setup_dependencies
    setup_color
    setup_shell_prompt
    setup_dev_tools


    # Ask for the github user's name of the dotfiles repo.
    # https://github.com/$GITHUB_USERNAME/dotfiles.git
    read -rp "Enter the github user's name of the dotfiles repo: " wifecooky
    apply_dotfiles
}

main "$@"