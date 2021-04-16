### MANUEL GUILLERMO GIL 14-10397 14-10397@usb.ve

import sys

class_list = []

class VTable:
    def __init__(self, table = None):
        self.table = table

    def print(self):
        for elem in self.table:
            print(elem[0] + "::" + elem[1])

    def appendTables(self, vtable, filtered_methods, name):
        new_table = []
        for table in vtable.table:
            if(not self.existMethod(table[1])):
                new_table.append(table)
            else:
                new_table.append([name, table[1]])

        for table in filtered_methods:
            new_table.append(table)

        self.table = new_table


    def existMethod(self, name = None):
        for elem in self.table:
            if elem[1].lower() == name.lower():
                return True
        return False


class Class:
    def __init__(self, name = None, father = None, methods = None):
        self.name = name
        self.father = father
        self.methods = methods
        self.vtable = self.createTable()

    def createTable(self):
        vtable = []
        for method in self.methods:
            if(method != ''):
                vtable.append([self.name, method])
        if not self.father:
            return VTable(vtable)
        else:
            filtered_methods = []
            for method in self.methods:
                if(method != ''):
                    if(not self.father.vtable.existMethod(method)):
                        filtered_methods.append([self.name, method])
            vtable_obj = VTable(vtable)
            vtable_obj.appendTables(self.father.vtable, filtered_methods, self.name)
            return vtable_obj        
        return None


def createClass(user_input):
    if checkClassName(user_input[0]):
        print("El nombre de la clase " + user_input[0] + " ya existe\n")
        return

    super_class = None
    if(user_input[1] == ':'):
        if checkClassName(user_input[2]):
            super_class = getClass(user_input[2])
        else:
            print("La clase padre " + user_input[2] + " no existe.\n")
            return
            
    if(super_class):
        class_list.append(Class(user_input[0], super_class, user_input[3:]))
    else:
        class_list.append(Class(user_input[0], None, user_input[1:]))
    

def checkClassName(name):
    if class_list:
        for class_obj in class_list:
            if class_obj.name.lower() == name.lower():
                return True
    return False
        
def getClass(name):
    if class_list:
        for class_obj in class_list:
            if class_obj.name.lower() == name.lower():
                return class_obj
    return None

def describe(name):
    if checkClassName(name):
        getClass(name).vtable.print()
    else:
        print("La clase con nombre " + name + " no existe")

## Función principal del programa
def main():
    print("------- BIENVENIDO AL MANEJADOR DE TABLAS VIRTUALES ----")
    option = [""]
    while(True):
        print("--------- Acciones posibles: ----------\n")
        print("SALIR - Salir del programa\n")
        print("CLASS <tipo> [<nombre>]\n")
        print("DESCRIBIR <nombre>\n")

        option = sys.stdin.readline()[:-1].split(' ')

        if option[0].lower() == "salir":
            break

        if(option[0].lower() == "class"):
            createClass(option[1:])

        if(option[0].lower() == "describir"):
            describe(option[1])


if __name__ == "__main__":
    main()