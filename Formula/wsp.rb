class Wsp < Formula
  desc "Multi-repo workspace manager using local git clones"
  homepage "https://github.com/jganoff/wsp"
  version "0.18.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/jganoff/wsp/releases/download/v0.18.0/wsp-aarch64-apple-darwin.tar.xz"
    sha256 "e0046850bc450b8750d08517108c8959f841f24d7ee1c09793fa8d68325146cf"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jganoff/wsp/releases/download/v0.18.0/wsp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b9cc1d6b32ccafdc8e7306e7c5c782a965c15ca45a1de5911adbcf016da0c8e9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jganoff/wsp/releases/download/v0.18.0/wsp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4ff98dae7ff3322b7e2c170ed130e4bbba981fd2654c4c2c59f110b378fb4607"
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
