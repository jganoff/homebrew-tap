class Wsp < Formula
  desc "Multi-repo workspace manager using local git clones"
  homepage "https://github.com/jganoff/wsp"
  version "0.16.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/jganoff/wsp/releases/download/v0.16.0/wsp-aarch64-apple-darwin.tar.xz"
    sha256 "a96f3a681367a323bea2edf36b59b09cf0a23f14a92e0ff3a4eb63781ef087a9"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jganoff/wsp/releases/download/v0.16.0/wsp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a3dd7ecd36e1e9ffb5dea3d02ce6addf6221480e5fbfdafa1ea4feb7c8a07d47"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jganoff/wsp/releases/download/v0.16.0/wsp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e64dd957ee74bfbf2e18f9fa48671ba11e4f467cf1841d751735eb00254aff2a"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-pc-windows-gnu":    {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "wsp" if OS.mac? && Hardware::CPU.arm?
    bin.install "wsp" if OS.linux? && Hardware::CPU.arm?
    bin.install "wsp" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
