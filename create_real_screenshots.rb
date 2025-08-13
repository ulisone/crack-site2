#!/usr/bin/env ruby

require_relative 'config/environment'
require 'base64'

# Create a proper minimal PNG file (1x1 pixel black PNG)
def create_minimal_png
  # This is a valid 1x1 black PNG
  png_data = [
    0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A,  # PNG signature
    0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52,  # IHDR chunk
    0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,  # 1x1 dimensions
    0x08, 0x02, 0x00, 0x00, 0x00, 0x90, 0x77, 0x53,  # bit depth, color type, etc.
    0xDE, 0x00, 0x00, 0x00, 0x0C, 0x49, 0x44, 0x41,  # IDAT chunk
    0x54, 0x08, 0x99, 0x01, 0x01, 0x00, 0x00, 0x00,  # compressed data
    0x00, 0x00, 0x00, 0x02, 0x00, 0x01, 0xE5, 0x27,
    0xDE, 0xFC, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45,  # IEND chunk
    0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82
  ].pack('C*')
  
  png_data
end

# Create sample screenshots for the first software
software = Software.first
puts "Adding screenshots to: #{software.title}"

# Remove existing screenshots first
if software.screenshots.attached?
  software.screenshots.purge
  puts "Removed existing screenshots"
end

# Create 3 sample screenshots
3.times do |i|
  png_data = create_minimal_png
  
  # Create a temporary file
  temp_file = Tempfile.new(['screenshot', '.png'])
  temp_file.binmode
  temp_file.write(png_data)
  temp_file.rewind
  
  # Attach to software
  software.screenshots.attach(
    io: temp_file,
    filename: "screenshot_#{i + 1}.png",
    content_type: "image/png"
  )
  
  temp_file.close
  temp_file.unlink
  
  puts "Added screenshot_#{i + 1}.png"
end

software.reload
puts "Total screenshots attached: #{software.screenshots.count}"

# Verify each attachment
software.screenshots.each_with_index do |screenshot, i|
  puts "Screenshot #{i + 1}: #{screenshot.filename} (#{screenshot.byte_size} bytes)"
  puts "  Content type: #{screenshot.content_type}"
  puts "  Attached: #{screenshot.attached?}"
end

puts "Done!"