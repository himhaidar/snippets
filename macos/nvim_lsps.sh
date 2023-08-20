#!/bin/bash

# Rust
curl https://sh.rustup.rs -sSf | sh --profile complete -y

# Install the languages
brew install elixir go python node typescript

# Install the language servers
brew install \
      bash-language-server \
      shellcheck \
      vscode-langservers-extracted \
      pyright \
      terraform-ls \
      tailwindcss-language-server \
      typescript-language-server \
      yaml-language-server \
      grammarly-languageserver \
      elixir-ls
 
# Rust Analyzer
/Users/hey/Library/Cargo/bin/rustup component add rust-analyzer

# GraphQL
/usr/local/bin/npm install -g graphql-language-service-cli
/usr/local/bin/npm install -g vim-language-server

# Go
/usr/local/bin/go install golang.org/x/tools/cmd/goimports@latest
/usr/local/bin/go install golang.org/x/tools/cmd/gofmt@latest
/usr/local/bin/go install golang.org/x/tools/gopls@latest
