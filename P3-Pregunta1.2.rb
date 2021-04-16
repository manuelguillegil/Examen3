## MANUEL GUILLERMO GIL 14-10397

load 'Pregunta1i.rb'

class Grafo
    attr_accessor :grafo
    def initialize
        @grafo = Hash.new()
        self.insert(0,[1,6,8])
        self.insert(1,[0,4,6])
        self.insert(2,[4,6,3,5])
        self.insert(3,[4,5,8])
        self.insert(4,[1,2])
        self.insert(5,[3,4])
        self.insert(6,[0,1,2])
        self.insert(7,[8])
        self.insert(8,[0,3,7])
        self.insert(9,[])
    end

    def insert(clave, valor)
        @grafo[clave] = valor
    end
end

class Search
    def search(nodoInicial, nodoFinal)
        visited_init = Array.new() << nodoInicial
        if (nodoInicial == nodoFinal)
            return "Nodos recorridos 0"
        end
        return self.to_search(nodoInicial, nodoFinal, 0, visited_init, [])
    end
    
    def to_search(nodoInicial, nodoFinal, count, visited, nodes)
        array_elementos = $g.grafo[nodoInicial]
        
        stack = self.orden(array_elementos)
        if stack.elements.include? nodoFinal 
            nodes << count
        else
            while not(stack.empty)
                elem = stack.remove
                if not(visited.include? elem)
                    visited << elem
                    to_search(elem, nodoFinal , count + 1 , visited, nodes)
                end
            end
        end

        if nodes.empty?
            return -1
        end
        return "Nodos recorridos #{nodes[0]}"
    end
end

class DFS < Search
    def orden(elementos)
        return Pila.new(elementos)
    end
end

class BFS < Search
    def orden(elementos)
        return Cola.new(elementos)
    end
end

$g = Grafo.new        #Aqui creé un grafo de ejemplo

dfs = DFS.new()
bfs = BFS.new()

puts dfs.search(2,7)

puts bfs.search(2,7)

