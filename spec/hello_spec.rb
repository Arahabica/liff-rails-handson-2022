require 'rails_helper'

RSpec.describe 'hello' do
  context "world" do
    it 'rspec' do
      expect('hello').to eq 'hello'
    end
  end
end
