class Rw < Formula
  desc "Documentation engine - CLI"
  homepage "https://github.com/rwdocs/rw"
  version "0.1.25"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rwdocs/rw/releases/download/v0.1.25/rw-aarch64-apple-darwin.tar.xz"
      sha256 "7c3018e1217f400317ed0e96a3b5cf8cfd8f13c9d3a8570c5861c6d4150da090"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rwdocs/rw/releases/download/v0.1.25/rw-x86_64-apple-darwin.tar.xz"
      sha256 "0bf4648328706444a013e05f8894bf58d76560d8f971ac7c4def4a7fef6f78d9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rwdocs/rw/releases/download/v0.1.25/rw-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b764c33d7093adc8adb69f64b0efb2de6c310a3aa6709243d2ffbe1f52ed89e9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rwdocs/rw/releases/download/v0.1.25/rw-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4cef3297759adca8948a258df8faede587a9b487297afd3fcf1e452ee64109db"
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
