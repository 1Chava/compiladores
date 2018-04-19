#practica2.py

class Automata:
    def __init__(self, estados, lenguaje, inicial, final, transiciones):
        self.estados = estados
        self.lenguaje = lenguaje
        self.inicial = inicial
        self.final = final
        self.transiciones = transiciones
        self.contieneSolucion = 0
        self.rutas = [Nodo(0, inicial)]

    def buscarTransiciones(self, estado, char):
        tValidas = []
        for sublist in self.transiciones:
            if (sublist[0] == estado.estadoActual) and (sublist[1] == char or sublist[1] == "E"):
                tValidas.append(sublist)
        return tValidas

    def nuevoNodo(self, i, lista):
        for nAnterior in self.rutas:
            if nAnterior.estadoActual is lista[0]:
                nodo = Nodo(i+1, lista[2], nAnterior, lista[1])
                nAnterior.siguientes.append(nodo)
                return nodo 

    def getFinales(self, eFinal, lCadena):
        return self.rutas.getFinales(eFinal, lCadena)

    def imprimirCaminos(self, lCadena):
        flag = 0
        for i, x in enumerate(self.final):
            nodos = self.rutas.getFinales(x, lCadena)
            if len(nodos) > 0:
                flag = 1
                if i is 0:
                    print("Si es aceptada")
                [print(nodo) for nodo in nodos]
        if flag is 0:
            print("La cadena no es aceptada")



class Nodo:
    def __init__(self, indice, estado, padre=None, caracter=None):
        self.padre = padre
        self.indice = indice
        self.estadoActual = estado
        self.caracter = caracter
        self.siguientes = []

    def getNodo(self, i, e):
        nodo = None
        if (self.indice == i) and (self.estadoActual == e):
            nodo = self
        else:
            for siguiente in self.siguientes:
                temp = siguiente.getNodo(i,e)
                if temp is not None:
                    nodo = temp
        return nodo

    def getFinales(self, eFinal, uNivel):
        result = []
        if self.indice == uNivel and self.estadoActual == eFinal:
            result.append(self)
        else:
            for nodo in self.siguientes:
                lista = nodo.getFinales(eFinal, uNivel)
                if(lista is not []):
                    [result.append(item) for item in lista]
        return result

    def getNodos(self, i):
        result = []
        if self.indice == i:
            result.append(self)
        else:
            for nodo in self.siguientes:
                lista = nodo.getNodos(i)
                if(lista is not []):
                    [result.append(item) for item in lista]
        return result

    def verAnterior(self, estadoActual, caracter):
        if type(self.padre) is not Nodo:
            return False
        else:
            if self.padre.estadoActual is estadoActual and self.padre.caracter is caracter:
                return True
            else:
                return self.padre.verAnterior(estadoActual, caracter)
    
    def __str__(self):
        if self.padre == None:
            return self.estadoActual
        return str(self.padre) + '->' + self.estadoActual
        #return "Nodo " + str(self.indice) + " con estado en " + str(self.estadoActual) + " hijo de " + str(self.padre)

#Leer automata y meterlo inicializar el automata
llaves = ['estados', 'lenguaje', 'inicial', 'final', 'transiciones']
with open('5.txt') as f:
    valores = f.read().splitlines()
transiciones = valores[4:]
del valores[4:]
estados, lenguaje, inicial, final = valores
automata = Automata(estados.split(','), lenguaje.split(','), inicial, final.split(','), [str.split(',') for str in transiciones])

#Recibir la cadena a evaluar
print("Ingersar cadena a evaluar")
cadena = input(">")

#Empezar a evaluar la cadena
cont = 0
siguientes = []
for i, c in enumerate(cadena):
    flag = True
    while flag:
        lista_iterable = set(automata.rutas) - set(siguientes) 
        for estado in lista_iterable:
            tValidas = automata.buscarTransiciones(estado, c)
            for transicion in tValidas:
                nodo = automata.nuevoNodo(cont, transicion)
                if type(nodo) is Nodo and nodo.verAnterior(nodo.estadoActual, c):
                    flag = False
                siguientes.append(nodo)
            if len(tValidas) is 0:
                if estado.estadoActual is c:
                    siguientes.append(estado)
            cont =+1
        automata.rutas.clear()
        for nodo in siguientes:
            if type(nodo) is Nodo:
                automata.rutas.append(nodo)
        siguientes.clear()
        [print(nodo, c) for nodo in automata.rutas]
        input("_____________________________________")
    print("/////////////////////////////////")

flag = False
for nodo in automata.rutas:
    if nodo.estadoActual in automata.final:
        if flag is False:
            print("Si es aceptada")
            flag = True
        print(nodo)
if flag is False:
    print("La cadena no es aceptada")
# automata.imprimirCaminos(cont)