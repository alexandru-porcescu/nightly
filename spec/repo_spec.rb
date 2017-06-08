require_relative "../lib/repo"

RSpec.describe Repo do
  let(:repo) { Repo.new }

  describe "#classy_description" do
    it "does nothing if the description is already classy" do
      original = "<img src='/images/emoji/unicode/26a1.png'/> Lodash inspired JSDoc 3 template / theme"
      repo.description = original
      expect(repo.classy_description).to eq original
    end

    it "adds emojis and links where appropriate" do
      repo.description = ":shipit: to http://example.com"
      expect(repo.classy_description).to eq "<img alt='shipit' src='/images/emoji/shipit.png' style='vertical-align:middle' width='20' height='20' /> to <a href='http://example.com'>http://example.com</a>"
    end
  end

  describe "#language_class" do
    it "downcases" do
      repo.language = "JavaScript"
      expect(repo.language_class).to eq "javascript"
    end

    it "converts spaces to hypens" do
      repo.language = "Objective C"
      expect(repo.language_class).to eq "objective-c"
    end

    it "handles the C# special case" do
      repo.language = "c#"
      expect(repo.language_class).to eq "csharp"
    end
  end

  describe "#no_description?" do
    it "is true when description is nil, empty, or blank" do
      [nil, "", "   "].each do |bad|
        repo.description = bad
        expect(repo.no_description?).to be true
      end
    end

    it "is false when descripton has contents" do
      repo.description = "ohai"
      expect(repo.no_description?).to be false
    end
  end

  describe "#obscene?" do
    before do
      repo.owner = double login: ""
    end

    it "is true when descriptoin has an obscenity in it" do
      repo.description = "This is great, AssFace"
      expect(repo).to be_obscene
    end

    it "is true when the owner login has an obscenity in it" do
      repo.owner = double login: "NiggerFoundation"
      expect(repo).to be_obscene
    end

    it "is true when the name as an obscenity in it" do
      repo.name = "Apparently poopstain is an obscenity..."
      expect(repo).to be_obscene
    end

    it "is false when none of those things have obscenities in them" do
      repo.name = "proximityhash"
      repo.description = "Geohashes in proximity"
      expect(repo).to_not be_obscene
    end
  end
end
