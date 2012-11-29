# encoding: utf-8
require 'spec_helper'

describe 'Spectrum::Engines::Solr' do
  describe 'for searches with diacritics' do
    it 'should find an author with diacritics' do

      eng = Spectrum::Engines::Solr.new(:source => 'catalog', :q => 'turk edebiyatinda', :search_field => 'author').search
      eng.results.should_not be_empty
      eng.results.first.get('author_display').should include("Edebiyat\u0131nda")

    end
  end
end