class Wsp < Formula
  desc "Multi-repo workspace manager using local git clones"
  homepage "https://github.com/jganoff/wsp"
  version "0.5.1"
  if OS.mac? && Hardware::CPU.arm?
      url "https://github.com/jganoff/wsp/releases/download/v0.5.1/wsp-aarch64-apple-darwin.tar.xz"
      sha256 "ea389be3a651b8f3aea3fe3af81af8b359cc342dee85f6553c01d0d218315155"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jganoff/wsp/releases/download/v0.5.1/wsp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2f1733e3e61c1358fe160e7e134f67a286826be1789a9e7c866da97311ca019c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jganoff/wsp/releases/download/v0.5.1/wsp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c95f142354c02391b6bd5ea9366a09a53c15a7a7e8e863088be7314d909f22cb"
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
