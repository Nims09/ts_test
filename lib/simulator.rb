class Simulator

  def initialize(seating_arrangement)
    raise NotImplementedError
  end

  # If the majority hold opinion o, return o else if equal return push
  def verdict
    raise NotImplementedError
  end

  def state
    raise NotImplementedError
  end

  # Updates the opinion of all people in the seating arrangment
  def next
    raise NotImplementedError
  end

end
