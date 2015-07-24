class Simulator

  # Keep a current running count of each opinion, initialized upon initialize 

  # Keep a tab of the current seating arrangment 

  def initialize(seating_arrangement)
    soft, hard = 0;

    keys = [:soft, :hard, :none]
    @opinions = Hash[ keys.map { |key| [key, 0] } ]
    @seating_arrangement = seating_arrangement

    seating_arrangement.each do |row| 
      row.each do |opinion|
        if @opinions.has_key? opinion
          @opinions[opinion] += 1
        else
          raise ArgumentError, ":opinion must be one of: #{keys.to_s}, recieved: #{opinion}"
        end 
      end 
    end
  end

  # If the majority hold opinion, return it else if equal return push
  # Takes any seating arrangment, returns a verdict
  #   Just checks counts and returns based on this
  def verdict
    raise NotImplementedError
  end

  def state
    raise NotImplementedError
  end

  # Updates the opinion of all people in the seating arrangment
  # Takes a seating arrangment and returns an updated one
  #   Runs keeps track of counts and updates at the end
  def next
    raise NotImplementedError
  end

end
