## MANUEL GUILLERMO GIL 14-10397
import os
import threading

count = 0
mutex = threading.Lock()

# Incrementa el contador dependiendo de la cantidad de archivos
# @param directory - Directorio
def incrementCount(directory):
    files = [file for file in os.listdir(directory) if os.path.isfile(os.path.join(directory, file))]
    global count
    count += len(files)

# Retorna los directorios encontrados
# @directory - Directorio nodo a considerar 
def selectDirectories(directory):
    return [entry for entry in os.listdir(directory) if os.path.isdir(os.path.join(directory,entry)) ]

## Crea nuevos hilos por cada nuevo subdirectorio dentro de cada subdirectorio
## @param directory - Path del directorio
def create_threads_sub(directory):
    mutex.acquire()
    incrementCount(directory)
    mutex.release()
    new_directories = selectDirectories(directory)
   
    for new_directory in new_directories:
        t = threading.Thread(target=create_threads_sub, args=(os.path.join(directory, new_directory), ))
        t.start()
        t.join()

def create_threads(directory):
    directories = selectDirectories(directory)
    mutex.acquire()
    incrementCount(directory)
    mutex.release()

    for entry in directories:
        t = threading.Thread(target=create_threads_sub, args= (os.path.join(directory, entry),))
        t.start()
        t.join()
        
if __name__=="__main__":
    directory = input("Por favor introduzca el directorio: ")
    create_threads(directory)

    print('Total de archivos encontrados: ' + str(count))
