module Jekyll

  # https://gist.github.com/mildred/1472645
  class Layout

    alias old_initialize initialize

    def initialize(*args)
      old_initialize(*args)
      self.content = self.transform
      self.content
    end

  end

end
