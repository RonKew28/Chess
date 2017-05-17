class Move
  include Comparable
  attr_accessor :start_pos, :end_pos, :piece, :value, :reasons

  def initialize(start_pos, end_pos, piece)
    @start_pos, @end_pos = start_pos, end_pos
    @piece = piece
    @value = 0
    @reasons = []
  end

end
