## MANUEL GUILLERMO GIL 14-10397
import random
import threading

first_matrix = []
second_matrix = []
result_matrix = []
dimension = 2
num_threads = 1

# En esta función creamos un hilo según la cantidad de hilos introducida por el usuario, cada hilo se encargará de 
# sumar una parte de la matriz, que dependerá de las dimensiones y num de hilos
def create_thread():
    for j in range(0, num_threads):
        t = threading.Thread(target = sum_matrix, args=(int((dimension/num_threads) * j), int((dimension/num_threads) * (j+1))))
        t.start()  
        t.join() 

#La función de sumar matrices es llamada para cada hilo, el cual se va a encargar de sumar la sección que corresponde
## @param final - Valor final
def sum_matrix(start, final):
    for i in range(start, final):
        for j in range(dimension):
            result_matrix[i][j] = int(first_matrix[i][j] + second_matrix[i][j])
      
# Función para imprimir las matrices
def print_matrix(array):
    for elem in array:
        print(elem)
    print("\n")
  
            
if __name__=="__main__":
    dimension = int(input("Introduce el número que corresponderá con la dimensión de las matrices NxN : "))
    num_threads = int(input("Número de hilos : "))

    for i in range(dimension):
        first_matrix.append([random.randint(0,100) for numero in range(dimension)])
        second_matrix.append([random.randint(0,100) for numero in range(dimension)])
        result_matrix.append([0 for numero in range(dimension)])

    create_thread()
    
    print_matrix(first_matrix)
    print_matrix(second_matrix)
    print_matrix(result_matrix)