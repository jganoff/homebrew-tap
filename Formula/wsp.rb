class Wsp < Formula
  desc "Multi-repo workspace manager using local git clones"
  homepage "https://github.com/jganoff/wsp"
  version "0.13.1"
  if OS.mac? && Hardware::CPU.arm?
      url "https://github.com/jganoff/wsp/releases/download/v0.13.1/wsp-aarch64-apple-darwin.tar.xz"
      sha256 "4efc93f38a3cc54245747816ce204e32da57517289bcaae418282ed678d46098"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jganoff/wsp/releases/download/v0.13.1/wsp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "560b93a0d67a15ac385c780ba010215ba81f7f701c8d7dc61f0fa348640421f0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jganoff/wsp/releases/download/v0.13.1/wsp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "35138f2f76e3c31d3ea2d76063ea5caef80f7d88ae87869ae2829cf1b6451bcc"
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
