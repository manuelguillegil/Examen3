## MANUEL GUILLERMO GIL 14-10397

class Secuencia
    def empty
        raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
    end
    def add
        raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
    end
    def remove
        raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
    end
end

class Pila < Secuencia
    attr_accessor :elements

    def initialize(elements)
        @elements = []
        elements.each {|element| self.add(element)}
    end

    def empty
        return @elements.empty?
    end
    def add(elemento)
        @elements << elemento
    end

    def remove
        return @elements.pop
    end
end

class Cola < Secuencia
    attr_accessor :elements

    def initialize(elements)
        @elements = []
        elements.each {|element| self.add(element)}
    end

    def empty
        return @elements.empty?
    end
    def add(elemento)
        @elements.insert(0,elemento)
    end
    def remove
        return @elements.pop
    end
end
