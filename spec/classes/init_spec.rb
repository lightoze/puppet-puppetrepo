require 'spec_helper'
describe 'puppetrepo' do

  context 'with defaults for all parameters' do
    it { should contain_class('puppetrepo') }
  end
end
