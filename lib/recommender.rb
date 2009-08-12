require 'rubygems'
require 'just_enumerable_stats'
require 'facets/dictionary'
require 'ostruct'
require 'data_frame'

Dir.glob("#{File.dirname(__FILE__)}/recommender/ext/*.rb").each { |file| require file }

Dir.glob("#{File.dirname(__FILE__)}/recommender/*.rb").each { |file| require file }
