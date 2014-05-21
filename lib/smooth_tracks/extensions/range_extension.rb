module RangeExtension

  extend ActiveSupport::Concern

  # Splits the Range into 2 parts at the given position.
  #
  # Returns an Array with 2 new Ranges; the first going from start to position (exclusive),
  # the second going from position (inclusive) to end.
  # 
  # Examples
  #
  #  first_half, second_half = (1..6).split( 3.5 )
  #  first_half  #=> (1...3.5)
  #  second_half #=> (3.5..6)

  def split( position )
    [ ( self.begin ... position ), ( position .. self.end ) ]
  end


  # Slices the Range into consectuive parts of a given size.
  # Iterates over the slices if a block is given (best used with the alias #in_slices_of).
  # 
  # Returns an Array of new Ranges of the given size (the last slice can be smaller).
  #
  # Examples:
  #
  #   (0..5).slice( 1.5 ) #=> [ (0...1.5), (1.5...3), (3...4.5), (4.5..5) ]
  #   
  #   day  = ( DateTime.now .. DateTime.now + 1.day )
  #   noon = DateTime.now + 12.hours
  #   
  #   day.in_slices_of( 8.hours ) { |periode| puts periode.cover?( noon ) }
  #   #=> false
  #   #=> true
  #   #=> false

  def slices( size )
    slices = []
    range  = self

    step( size ) do |position|
      slice, range = range.split( pos ) unless position == self.begin || postion == self.end
      yield slice if slice && block_given?
      slices << slice
    end

    return slices
  end

  alias_method :in_slices_of, :slices


  # Iterates over steps of the Range of the given step size.
  # Extends step functionaly for Date and Time Ranges (use a duration as step size).
  #
  # Examples:
  #
  #   ( DateTime.now .. DateTime.now + 4.hours ).step( 1.hour ) { |time| puts time.strftime( '%H:%M' ) }
  #   #=> 07:14
  #   #=> 08:14
  #   #=> 09:14
  #   #=> 10:14
  #   #=> 11:14
  #
  # (Credit to CaptainPete[http://stackoverflow.com/questions/19093487/ruby-create-range-of-dates/19346914#19094504])

  def step_with_duration( step_size = 1, &block )
    return to_enum( :step, step_size ) unless block_given?
    return step_without_duration( step_size, &block ) unless step_size.kind_of?( ActiveSupport::Duration )

    parts = Hash[ step_size.parts ]
    time = self.begin

    while exclude_end? ? time < self.end : time <= self.end
      yield time
      time = time.advance parts
    end
  end

  included { alias_method_chain :step, :duration }

end
