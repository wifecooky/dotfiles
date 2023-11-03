#!/bin/bash

# Tested on Macbook Air Apple M1 macOS Ventura 13.2
# Reference: https://github.com/renemarc/dotfiles/blob/master/executable_dotfiles.sh

# -e: exit on error
# -u: exit on unset variables
set -eu

command_exists() {
    command -v "$@" >/dev/null 2>&1
}

RED=$(printf '\033[31m')
BLUE=$(printf '\033[34m')
BOLD=$(printf '\033[1m')
RESET=$(printf '\033[m')

error() {
    printf -- "%sError: $*%s\n" >&2 "$RED" "$RESET"
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

    # chezmoi init with remote repo and apply
    if command_exists chezmoi; then
        printf -- "%sInitializing chezmoi...%s\n" "$BLUE" "$RESET"
        chezmoi -- init --apply wifecooky
    fi
}

# Entry point
main() {
    printf -- "Setting up your PC...\n"

    setup_dependencies
    setup_dev_tools
    apply_dotfiles
}

main "$@"
