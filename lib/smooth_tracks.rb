require 'smooth_tracks/version'

puts ActiveSupport

require 'smooth_tracks/extensions/range_extension'


module SmoothTracks

  # Include all extensions in their respective classes.

  Range.send :include, RangeExtension

end
