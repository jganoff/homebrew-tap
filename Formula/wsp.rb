class Wsp < Formula
  desc "Multi-repo workspace manager using local git clones"
  homepage "https://github.com/jganoff/wsp"
  version "0.19.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/jganoff/wsp/releases/download/v0.19.0/wsp-aarch64-apple-darwin.tar.xz"
    sha256 "d414e906c0464b75de786e7b76680ececb54501ac3f0a5fd7749ae3c0f3dcdd3"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jganoff/wsp/releases/download/v0.19.0/wsp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8000bd0f3257e097e577084f74ceced79f0c133b0bcc43969f6f209928269948"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jganoff/wsp/releases/download/v0.19.0/wsp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6692c9ed07618d0c1755a2eeb3ace8b9395af4bb38f396e746d7267f98d26e8f"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "wsp"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "wsp"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "wsp"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
