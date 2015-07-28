class Simulator

  # Feeds in intial seating arrangment and gets initial counts
  ###
  def initialize(seating_arrangement)
    @keys = [:soft, :hard, :none]
    @opinions = Hash[ @keys.map { |key| [key, 0] } ]
    @seating_arrangement = seating_arrangement

    @seating_arrangement.each do |row| 
      row.each do |opinion|
        if @opinions.has_key? opinion
          @opinions[opinion] += 1
        else
          raise ArgumentError, "opinion must be one of: #{@keys.to_s}, recieved: #{opinion}."
        end 
      end 
    end
  end

  # Checks counts to get a current verdict
  ### 
  def verdict
    if @opinions[:hard] > @opinions[:soft]
      :hard
    elsif @opinions[:soft] > @opinions[:hard]
      :soft
    else
      :push
    end
  end

  # Returns our current state
  ###  
  def state
    @seating_arrangement
  end

  # Updates the arrangment state, rechecks counts as it goes
  ### 
  def next
    # Create a duplicate array to change value by value, allows 'simultaneous' transitions
    new_seating_arrangement = Array.new(@seating_arrangement.size) { |array| array = Array.new(@seating_arrangement[0].size) }
    @opinions = Hash[ @keys.map { |key| [key, 0] } ]

    # Iterate over array 
    @seating_arrangement.each_with_index do |array, y_index|
      array.each_with_index do |opinion, x_index|
        new_seating_arrangement[y_index][x_index] = update_opinion_for x_index, y_index
        @opinions[new_seating_arrangement[y_index][x_index]] += 1
      end
    end

    @seating_arrangement = new_seating_arrangement
  end

  private 

  # Checks to see if a position is in arrangment bounds
  ###
  def in_array_range?(x, y)
    ((x >= 0) and (y >= 0) and (x < @seating_arrangement[0].size) and (y < @seating_arrangement.size))
  end

  # Scans neighbours and passes back a decided opinion
  ###
  def update_opinion_for(x, y)
    local_opinions = Hash[ @keys.map { |key| [key, 0] } ]

    # For each position in range, if it's valid: consider
    for y_pos in (y-1)..(y+1)
      for x_pos in (x-1)..(x+1)
        if in_array_range? x_pos, y_pos and not(x == x_pos and y == y_pos)
          local_opinions[@seating_arrangement[y_pos][x_pos]] += 1
        end
      end
    end

    # Evaluate based on considerations and set rules
    opinion = @seating_arrangement[y][x]
    opinionated_neighbours_count = local_opinions[:hard] + local_opinions[:soft]

    if (opinion != :none) and (opinionated_neighbours_count < 2 or opinionated_neighbours_count > 3)
      opinion = :none    
    elsif opinion == :none and opinionated_neighbours_count == 3
      if local_opinions[:hard] > local_opinions[:soft]
        opinion = :hard
      elsif local_opinions[:soft] > local_opinions[:hard]
        opinion = :soft
      end 
    end 

    opinion
  end
end