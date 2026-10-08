class Wsp < Formula
  desc "Multi-repo workspace manager using local git clones"
  homepage "https://github.com/jganoff/wsp"
  version "0.22.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/jganoff/wsp/releases/download/v0.22.0/wsp-aarch64-apple-darwin.tar.xz"
    sha256 "86ebad8674ae4f6b14ed78959c638840955b14fdc7f7e98faa4db2354547113d"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jganoff/wsp/releases/download/v0.22.0/wsp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4ad2bdbc038018fa2656229b1d09354fedbf679754755b63b6cef55e13e8d783"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jganoff/wsp/releases/download/v0.22.0/wsp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d94bc6612c457bf844f3a62b298b15f739e431b232f04bb3d42a286937cdf48d"
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
