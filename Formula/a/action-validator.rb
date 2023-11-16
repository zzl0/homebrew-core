class ActionValidator < Formula
  desc "Tool to validate GitHub Action and Workflow YAML files"
  homepage "https://github.com/mpalmer/action-validator"
  license "GPL-3.0-only"

  stable do
    url "https://github.com/mpalmer/action-validator/archive/refs/tags/v0.5.3.tar.gz"
    sha256 "9afc0e12ca04d5373b3788a36b0f174077f7411572877da85a4c92d187751f14"

    # always pull the HEAD commit hash
    resource "schemastore" do
      url "https://github.com/SchemaStore/schemastore.git",
          revision: "c0e78776f848b8ea866f379f159109adf4d62ad5"
    end
  end

  head do
    url "https://github.com/mpalmer/action-validator.git", branch: "main"

    resource "schemastore" do
      url "https://github.com/SchemaStore/schemastore.git", branch: "master"
    end
  end

  depends_on "rust" => :build

  def install
    (buildpath/"src/schemastore").install resource("schemastore")

    system "cargo", "install", *std_cargo_args
  end

  test do
    test_action = testpath/"action.yml"
    test_action.write <<~EOS
      name: "Brew Test Action"
      description: "Test Action"
      inputs:
        test:
          description: "test input"
          default: "brew"
      runs:
        using: "node20"
        main: "index.js"
    EOS

    test_workflow = testpath/"workflow.yml"
    test_workflow.write <<~EOS
      name: "Brew Test Workflow"
      on: [push111]
      jobs:
        build:
          runs-on: ubuntu-latest
          steps:
            - uses: actions/checkout@v4
    EOS

    output = shell_output("#{bin}/action-validator --verbose #{test_action}")
    assert_match "Treating action.yml as an Action definition", output

    output = shell_output("#{bin}/action-validator --verbose #{test_workflow} 2>&1", 1)
    assert_match "Fatal error validating #{test_workflow}", output
    assert_match "Type of the value is wrong", output
  end
end
