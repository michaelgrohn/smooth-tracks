require 'smooth_tracks/version'

puts ActiveSupport

require 'smooth_tracks/extensions/range_extension'
require 'smooth_tracks/extensions/hash_extension'


module SmoothTracks

  # Include all extensions in their respective classes.

  Range.send :include, RangeExtension
  Hash.send  :include, HashExtension

end
