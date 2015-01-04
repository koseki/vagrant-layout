require 'vagrant-layout/target'

describe VagrantPlugins::Layout::Target do
  let(:default_target) { %w{user repo tree} }
  subject { VagrantPlugins::Layout::Target.new(target, default_target) }

  context 'with nil target' do
    subject { VagrantPlugins::Layout::Target.new(nil) }

    its(:type) { should eq :github }
    its(:url) { should eq 'https://github.com/koseki/vagrant-layout/archive/master.tar.gz' }
  end

  context 'with default_target argument' do
    let(:target) { nil }
    its(:type) { should eq :github }
    its(:url) { should eq 'https://github.com/user/repo/archive/tree.tar.gz' }
  end

  context 'with tree target' do
    let(:target) { 'php' }
    its(:type) { should eq :github }
    its(:url) { should eq 'https://github.com/user/repo/archive/php.tar.gz' }
  end

  context 'with user/tree target' do
    let(:target) { 'someone/php' }
    its(:type) { should eq :github }
    its(:url) { should eq 'https://github.com/someone/repo/archive/php.tar.gz' }
  end

  context 'with user/repo/tree target' do
    let(:target) { 'someone/layout/php' }
    its(:type) { should eq :github }
    its(:url) { should eq 'https://github.com/someone/layout/archive/php.tar.gz' }
  end

  context 'with user/repo/tree target' do
    let(:target) { 'someone/layout/php' }
    its(:type) { should eq :github }
    its(:url) { should eq 'https://github.com/someone/layout/archive/php.tar.gz' }
  end

  context 'with Gist URL' do
    let(:target) { 'https://gist.github.com/koseki/37f61d9a02b9a48e6651' }
    its(:type) { should eq :gist }
    its(:url) { should eq target + '/download' }
  end

  context 'with branch name tree URL' do
    let(:target) { 'https://github.com/koseki/vagrant-layout/tree/php' }
    its(:type) { should eq :github }
    its(:url) { should eq 'https://github.com/koseki/vagrant-layout/archive/php.tar.gz' }
  end

  context 'with hash tree URL' do
    let(:target) { 'https://github.com/koseki/vagrant-layout/tree/e09768d9' }
    its(:type) { should eq :github }
    its(:url) { should eq 'https://github.com/koseki/vagrant-layout/archive/e09768d9.tar.gz' }
  end

  context 'with commit URL' do
    let(:target) { 'https://github.com/koseki/vagrant-layout/commit/e09768d9' }
    its(:type) { should eq :github }
    its(:url) { should eq 'https://github.com/koseki/vagrant-layout/archive/e09768d9.tar.gz' }
  end
end
