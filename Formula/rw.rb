class Rw < Formula
  desc "Documentation engine - CLI"
  homepage "https://github.com/rwdocs/rw"
  version "0.1.12"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rwdocs/rw/releases/download/v0.1.12/rw-aarch64-apple-darwin.tar.xz"
      sha256 "ff9fd8577af27ceeedc35e19fddf8a7ae302b34985e191de2d4a557fa72cb056"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rwdocs/rw/releases/download/v0.1.12/rw-x86_64-apple-darwin.tar.xz"
      sha256 "0460bda40a3149f7c941c2cae4e223483174fb5a23115ee26ab73cfb1fc68e64"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rwdocs/rw/releases/download/v0.1.12/rw-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "129517d75875fc09b27e8e99b45cdc078da6a3396a6c31731ae9e0972526b5c8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rwdocs/rw/releases/download/v0.1.12/rw-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "76ea47bfe76928839a149fd7dc14c480336d5e28f58f04ff935d445cca3dc7cc"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
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
