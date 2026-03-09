class Wsp < Formula
  desc "Multi-repo workspace manager using local git clones"
  homepage "https://github.com/jganoff/wsp"
  version "0.9.0"
  if OS.mac? && Hardware::CPU.arm?
      url "https://github.com/jganoff/wsp/releases/download/v0.9.0/wsp-aarch64-apple-darwin.tar.xz"
      sha256 "3986b4305069bcabcfb9b2b9bcbcf88d7d81b2b2eb970cac1d5fcf6b5044d096"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jganoff/wsp/releases/download/v0.9.0/wsp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1d097f5c7a0422e6d2cea9e3ac521e4e40dd3f0df04480b65b1774fd0b689607"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jganoff/wsp/releases/download/v0.9.0/wsp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d7f8d473c0d89736a7045cc47c56cfa01f29cfcea9181646295309823fa0b7d9"
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
