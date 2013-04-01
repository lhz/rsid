class RSID

  attr_accessor :file

  def self.load(filename)
    content = File.open(filename, 'rb') { |f| f.read }
    %w[PSID RSID].include?(content[0,4]) or
      raise "Not a PSID/RSID file: #{filename}"
    rsid = RSID.new
    rsid.instance_eval do
      @file  = filename
      @data  = content
      @bytes = @data.bytes.to_a
    end
    rsid
  end

  strings = {
    magic:        0x00, name:         0x16,
    author:       0x36, released:     0x56
  }
  words = {
    version:      0x04, data_offset:  0x06,
    load_address: 0x08, init_address: 0x0A,
    play_address: 0x0C, songs:        0x0E,
    flags:        0x76
  }

  strings.each do |name, offset|
    define_method(name) { string_at(offset) }
  end

  words.each do |name, offset|
    define_method(name) { word_at(offset) }
  end

  def model
    (flags & 0b110000) >> 4
  end

  def model_label
    %w(none 6581 8580 both)[model]
  end

  def authors
    author.split(/\s*&\s*/).map { |a|
      a.gsub!('<?>', '')
      a == '' ? nil : a
    }.compact
  end

  def year
    released[/^([\d\?\-]{4,})/] ? $1 : '????'
  end

  def groups
    released.sub(year, '').strip.split(/\s*\/\s*/).map { |g|
      g.gsub!('<?>', '')
      g == '' ? nil : g
    }.compact
  end

  def load
    if load_address == 0
      @bytes[data_offset] + 256 * @bytes[data_offset + 1]
    else
      load_address
    end
  end

  def ends
    @bytes.size - data_offset + load
  end

  private

  def string_at(offset, maxlen = 32)
    term = @data.index("\x00", offset)
    if term && term < (offset + maxlen)
      string = @data[offset...term]
    else
      string = @data[offset, maxlen]
    end
    string.encode('utf-8', 'iso-8859-1')
  end

  def word_at(offset)
    @bytes[offset] * 256 + @bytes[offset + 1]
  end

end

require 'rsid/version'
