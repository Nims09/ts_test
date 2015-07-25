class Simulator

  # Feeds in seating arrangment and gets initial counts
  def initialize(seating_arrangement)
    @keys = [:soft, :hard, :none]
    @opinions = Hash[ @keys.map { |key| [key, 0] } ]
    @seating_arrangement = seating_arrangement

    @seating_arrangement.each do |row| 
      row.each do |opinion|
        if @opinions.has_key? opinion
          @opinions[opinion] += 1
        else
          raise ArgumentError, ":opinion must be one of: #{@keys.to_s}, recieved: #{opinion}"
        end 
      end 
    end
  end

  # Checks counts to get a current verdict 
  def verdict
    if @opinions[:hard] > @opinions[:soft]
      return :hard
    elsif @opinions[:soft] > @opinions[:hard]
      return :soft
    else
      return :push
    end
  end

  # Returns our current state
  def state
    return @seating_arrangement
  end

  # Updates the arrangment state, rechecks counts as it goes
  def next
    # Create a duplicate array to change value by value
    new_seating_arrangement = @seating_arrangement.dup
    @opinions = Hash[ @keys.map { |key| [key, 0] } ]

    # Iterate over array 
    @seating_arrangement.each_with_index do |array, y_index|
      array.each_with_index do |opinion, x_index|
        new_seating_arrangement[y_index][x_index] = update_opinion_for x_index, y_index
        if not @opinions[new_seating_arrangement[y_index][x_index]].nil?
          @opinions[new_seating_arrangement[y_index][x_index]] += 1
        end
      end
    end

    @seating_arrangement = new_seating_arrangement
  end

  private 

  # Checks to see if a position is in arrangment bounds
  def in_array_range?(x, y)
    return (x >= 0 and y >= 0 and x < @seating_arrangement[0].size and y < @seating_arrangement.size)
  end

  # Scans neighbors and passes back a decided opinion
  def update_opinion_for(x, y)
    local_opinions = Hash[ @keys.map { |key| [key, 0] } ]

    # For each position in range, check if it's valid, and consider
    for y_pos in (y-1)..(y+1)
      for x_pos in (x-1)..(x+1)
        if in_array_range? x_pos, y_pos and not local_opinions[@seating_arrangement[y_pos][x_pos]].nil? 
          local_opinions[@seating_arrangement[y_pos][x_pos]] += 1
        end
      end
    end

    # Evaluate based on considerations and set rules
    puts " -- "
    puts "is x: #{x}, y: #{y} has counts: soft #{local_opinions[:soft]}, hard #{local_opinions[:hard]}, neutral: #{local_opinions[:none]}, the TOT is #{local_opinions[:hard] + local_opinions[:soft]}"
    if (local_opinions[:hard] + local_opinions[:soft]) == 2
      puts "returns orig"
      return @seating_arrangement[y][x]
    elsif (local_opinions[:hard] + local_opinions[:soft]) != 3
      puts "returns none "
      return :none
    elsif local_opinions[:hard] > local_opinions[:soft]
      puts "returns hard"
      return :hard
    elsif local_opinions[:soft] > local_opinions[:hard]
      puts "returns soft"
      return :soft
    else
      puts "problem "
    end
  end

end
