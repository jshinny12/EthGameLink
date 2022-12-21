
# Install Base Languages
echo "Installing solc-select..."
pip install solc-select || exit 1

echo "Setup solidity..."
solc-select install 0.8.0 && \
solc-select use 0.8.0 || exit 1
echo "Installed Solidity $(solc --version | tail -n1)"

echo "Installing rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
. "$HOME/.cargo/env"
rustup default nightly

echo "Installing npm"
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y nodejs


# Install Security Tools
echo "Installing mythril..."
pip install mythril

echo "Installing slither..."
pip install slither-analyzer || exit 1

echo "Installing echidna..."
ECHIDNA_BASE="https://github.com/crytic/echidna/releases/download"
ECHIDNA_VERSION="2.0.3"
ECHIDNA_BIN="echidna-test-${ECHIDNA_VERSION}"
ECHIDNA_URL="${ECHIDNA_BASE}/v${ECHIDNA_VERSION}/${ECHIDNA_BIN}-Ubuntu-18.04.tar.gz"
curl -L "$ECHIDNA_URL" | sudo tar -xz -C /usr/bin

# curl -L "https://github.com/crytic/echidna/releases/download/v2.0.3/echidna-test-2.0.3-Ubuntu-18.04.tar.gz" | sudo tar -xz -C /usr/bin

echo "Installing Scribble"
sudo npm install -g eth-scribble


# Install Terminal Tools
echo "Installing fzf..."
git clone --depth 1 https://github.com/junegunn/fzf.git ~/fzf && \
~/fzf/install --all || :

echo "Setting up Shell..."
rm -f ~/.zsh_history && \
touch .devcontainer/zsh_history && \
ln -rs .devcontainer/zsh_history ~/.zsh_history

rm -f ~/.zshrc && \
ln -rs .devcontainer/zshrc ~/.zshrc

#add npm
sudo apt update
sudo apt install node.js npm