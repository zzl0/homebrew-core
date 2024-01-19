class C7n < Formula
  include Language::Python::Virtualenv

  desc "Rules engine for cloud security, cost optimization, and governance"
  homepage "https://github.com/cloud-custodian/cloud-custodian"
  url "https://github.com/cloud-custodian/cloud-custodian/archive/refs/tags/0.9.34.0.tar.gz"
  sha256 "5896f438c329a1f3f6cedc1e842376445760cca4a4735024abbbf668cf006bac"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8808b5c8536b2fda7cd8f4520e50fee88927727ea4cbfbd6b12079b0d925291c"
    sha256 cellar: :any,                 arm64_ventura:  "21ccdab6a819cebedd54a2e993123410a8d099e276ada9286c67e4c3326085a8"
    sha256 cellar: :any,                 arm64_monterey: "9a7910a299c715081875de12e5ba9c6e1cb31bb0496086accb3be32a96adfacb"
    sha256 cellar: :any,                 sonoma:         "c0102a678da97052849fb7ff4950e5be2655c2023a529785ddf27e53766ccf96"
    sha256 cellar: :any,                 ventura:        "d507b2e710448194853c167dc7f9dab081777ba14a50eb0a7c41803bbb07d783"
    sha256 cellar: :any,                 monterey:       "427330c38be586c59f7813e1b10a1e5b514ac945ff99baec815e8ff990ae13ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7504dd1ea51197b6e03210f6a25597dc7cca42bc9d1b705044ef2789614f54ec"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "python-argcomplete"
  depends_on "python-setuptools"
  depends_on "python-tabulate"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/e3/fc/f800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650d/attrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/b0/6b/5a1aabd772b26537d7a347beec1318303f489fd75fbad57bf04057d64247/boto3-1.34.22.tar.gz"
    sha256 "a98c0b86f6044ff8314cc2361e1ef574d674318313ab5606ccb4a6651c7a3f8c"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/0c/91/82c3c17bb22ebb6291d8dc5b07b88c55d5cc55eeaf2ddaf755aa802d8a85/botocore-1.34.22.tar.gz"
    sha256 "c47ba4286c576150d1b6ca6df69a87b5deff3d23bd84da8bcf8431ebac3c40ba"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/57/b1/b880503681ea1b64df05106fc7e3c4e3801736cf63deffc6fa7fc5404cf5/docutils-0.18.1.tar.gz"
    sha256 "679987caf361a7539d76e584cbeddc311e3aee937877c87346f31debc63e9d06"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/ee/eb/58c2ab27ee628ad801f56d4017fe62afab0293116f6d0b08f1d5bd46e06f/importlib_metadata-6.11.0.tar.gz"
    sha256 "1231cf92d825c9e03cfc4da076a16de6422c863558229ea0b22b675657463443"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/44/cd/1d325d358d856da96a7c6cfc2af486b70587dc4c70594aa2a9e6c2d279ad/jsonschema-4.21.0.tar.gz"
    sha256 "3ba18e27f7491ea4a1b22edce00fb820eec968d397feb3f9cb61d5894bb38167"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/f8/b9/cc0cc592e7c195fb8a650c1d5990b10175cf13b4c97465c72ec841de9e4b/jsonschema_specifications-2023.12.1.tar.gz"
    sha256 "48a76787b3e70f5ed53f1160d2b81f586e4ca6d1548c5de7085d1682674764cc"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/80/ce/e99def6196f53af8de12a9c36968de32f80b7871084d677d0dfcd2762d0b/referencing-0.31.1.tar.gz"
    sha256 "81a1471c68c9d5e3831c30ad1dd9815c45b558e596653db751a2bfdd17b3b9ec"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/b7/0a/e3bdcc977e6db3bf32a3f42172f583adfa7c3604091a03d512333e0161fe/rpds_py-0.17.1.tar.gz"
    sha256 "0210b2668f24c078307260bf88bdac9d6f1093635df5123789bfee4d8d7fc8e7"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/a0/b5/4c570b08cb85fdcc65037b5229e00412583bb38d974efecb7ec3495f40ba/s3transfer-0.10.0.tar.gz"
    sha256 "d0c8bbf672d5eebbe4e57945e23b972d963f07d82f661cabf678a5c88831595b"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/0c/39/64487bf07df2ed854cc06078c27c0d0abc59bd27b32232876e403c333a08/urllib3-1.26.18.tar.gz"
    sha256 "f8ecc1bba5667413457c529ab955bf8c67b45db799d159066261719e328580a0"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/58/03/dd5ccf4e06dec9537ecba8fcc67bbd4ea48a2791773e469e73f94c3ba9a6/zipp-3.17.0.tar.gz"
    sha256 "84e64a1c28cf7e91ed2078bb8cc8c259cb19b76942096c8d7b84947690cabaf0"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # trim last decimal point version to match semver returned from version command
    assert_match version.major_minor_patch.to_s, shell_output("#{bin}/custodian version")

    (testpath/"good-policy.yml").write <<~EOF
      policies:
      - name: ec2-auto-tag-user
        resource: ec2
        mode:
          type: cloudtrail
          role: arn:aws:iam::{account_id}:role/custodian-auto-tagger
          # note {account_id} is optional. If you put that there instead of
          # your actual account number, when the policy is provisioned it
          # will automatically inherit the account_id properly
          events:
            - RunInstances
        filters:
          - tag:CreatorName: absent
        actions:
          - type: auto-tag-user
            tag: CreatorName
            principal_id_tag: CreatorId
    EOF
    output = shell_output("#{bin}/custodian validate --verbose #{testpath}/good-policy.yml 2>&1")
    assert_match "valid", output
    # has invalid "action" key instead of "actions"
    (testpath/"bad-policy.yml").write <<~EOF
      policies:
      - name: ec2-auto-tag-user
        resource: ec2
        filters:
          - tag:CreatorName: absent
        action:
          - type: auto-tag-user
            tag: CreatorName
            principal_id_tag: CreatorId
    EOF
    output = shell_output("#{bin}/custodian validate --verbose #{testpath}/bad-policy.yml 2>&1", 1)
    assert_match "invalid", output
  end
end
