#!/usr/bin/env ruby

require 'uri'

if ARGV.length != 1
  puts "Usage: #{$0} <URL>"
  exit 1
end

encoded_url = URI.escape(ARGV[0])
puts "Encoded URL: #{encoded_url}"
