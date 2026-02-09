class Rw < Formula
  desc "Documentation engine - CLI"
  homepage "https://github.com/yumike/rw"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/yumike/rw/releases/download/v0.1.2/rw-aarch64-apple-darwin.tar.xz"
      sha256 "87ae0555ec5670218454debafd9b14ff3d9fa1af9f61cbcf8959c6ad0348f026"
    end
    if Hardware::CPU.intel?
      url "https://github.com/yumike/rw/releases/download/v0.1.2/rw-x86_64-apple-darwin.tar.xz"
      sha256 "6c42dcb4c6a2be0ac30a69ddff5901995fc7833fc53f22021fb288499c364707"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/yumike/rw/releases/download/v0.1.2/rw-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bbbaff73992f7cbe257f72acbc06e1f59c0a9b56584cd41f4e94d88c20838ae5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/yumike/rw/releases/download/v0.1.2/rw-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7cc5dc309318d417ed8fdd2d46003469bdda44a36aee8cc780ccfb187f28f545"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
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
    bin.install "rw" if OS.mac? && Hardware::CPU.arm?
    bin.install "rw" if OS.mac? && Hardware::CPU.intel?
    bin.install "rw" if OS.linux? && Hardware::CPU.arm?
    bin.install "rw" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
