require_relative 'spec_helper'
require 'file_minifier'

FIXTURES = { 'css' => 'spec/fixtures/custom.css' }

RSpec.describe FileMinifier do

  let(:fm) { FileMinifier.new(file) }

  let(:source) { fm.source }
  let(:target) { fm.target }

  before { FileUtils.rm_f(target) }

  FileMinifier::SUPPORTED_EXTENSIONS.keys.map(&:to_s).each do |ext|
    context "when a file has extension [#{ext}], file #{FIXTURES[ext]}" do
      let(:extension) { ext }
      let(:file) { FIXTURES[ext] }

      context 'should minify it in the RAM' do
        subject { fm.minify; }
        its(:length) { should be < File.stat(file).size }
        its(:length) { should be > 0 }
      end

      context 'should minify it in the file' do
        it 'should create a minified file' do
          expect(File.exist?(target)).to be(false)
          expect(fm.minify!).to be(true)
          expect(File.exist?(target)).to be(true)
        end
        it 'should minify into a file' do
          expect(File.exist?(target)).to be(false)
          expect(fm.minify!).to be(true)
          expect(::File.stat(target).size).to be < ::File.stat(source).size
        end
      end
    end
  end
end



