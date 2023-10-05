class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https://github.com/opentofu/opentofu"
  url "https://github.com/opentofu/opentofu/archive/refs/tags/v1.6.0-alpha2.tar.gz"
  sha256 "929105faff706c780acb89c2bbaa040a6110f9acba21e8b69751c848d64b521d"
  license "MPL-2.0"
  head "https://github.com/opentofu/opentofu.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:[._-]alpha\d)?)$/i)
  end

  depends_on "go" => :build

  # Needs libraries at runtime:
  # /usr/lib/x86_64-linux-gnu/libstdc++.so.6: version `GLIBCXX_3.4.29' not found (required by node)
  fails_with gcc: "5"

  def install
    system "go", "build", *std_go_args(output: bin/"tofu", ldflags: "-s -w"), "./cmd/tofu"
  end

  test do
    minimal = testpath/"minimal.tf"
    minimal.write <<~EOS
      variable "aws_region" {
        default = "us-west-2"
      }

      variable "aws_amis" {
        default = {
          eu-west-1 = "ami-b1cf19c6"
          us-east-1 = "ami-de7ab6b6"
          us-west-1 = "ami-3f75767a"
          us-west-2 = "ami-21f78e11"
        }
      }

      # Specify the provider and access details
      provider "aws" {
        access_key = "this_is_a_fake_access"
        secret_key = "this_is_a_fake_secret"
        region     = var.aws_region
      }

      resource "aws_instance" "web" {
        instance_type = "m1.small"
        ami           = var.aws_amis[var.aws_region]
        count         = 4
      }
    EOS
    system "#{bin}/tofu", "init"
    system "#{bin}/tofu", "graph"
  end
end
