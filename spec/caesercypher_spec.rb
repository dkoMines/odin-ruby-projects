# spec/caesercypher_spec.rb

require './caesercypher.rb'

describe "#caeser_cypher" do
  it "Shifts a character by 1" do
    expect(caeser_cypher('a', 1)).to eq 'b'
  end
  it "Wraps around z" do
    expect(caeser_cypher('y', 4)).to eq 'c'
  end
  it "Maintain capitals" do
    expect(caeser_cypher('aBcD', 1)).to eq 'bCdE'
  end
  it "Keeps punctuation" do
    expect(caeser_cypher('hello!', 1)).to eq 'ifmmp!'
  end
end