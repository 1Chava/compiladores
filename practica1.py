#practica1.py

class Automata:
    def __init__(self, estados, lenguaje, inicial, final, transiciones):
        self.estados = estados
        self.lenguaje = lenguaje
        self.inicial = inicial
        self.final = final
        self.transiciones = transiciones
        self.contieneSolucion = 0
        self.rutas = Nodo(0, inicial)

    def buscarTransiciones(self, c, i):
        tValidas = []
        estadoActual = []
        nodos = self.rutas.getNodos(i)
        [estadoActual.append(nodo.estadoActual) for nodo in nodos]
        for sublist in self.transiciones:
            if (sublist[0] in estadoActual and sublist[1] in c):
                tValidas.append(sublist)
        return tValidas

    def nuevoNodo(self, i, eAnterior, eNuevo):
        nAnteriores = self.rutas.getFinales(eAnterior, i)
        for nAnterior in nAnteriores:
            nodo = Nodo(i+1, eNuevo, nAnterior)
            nAnterior.siguientes.append(nodo)

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
    def __init__(self, indice, estado, padre=None):
        self.padre = padre
        self.indice = indice
        self.estadoActual = estado
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
    
    def __str__(self):
        if self.padre == None:
            return self.estadoActual
        return str(self.padre) + '->' + self.estadoActual
        #return "Nodo " + str(self.indice) + " con estado en " + str(self.estadoActual) + " hijo de " + str(self.padre)

#Leer automata y meterlo inicializar el automata
llaves = ['estados', 'lenguaje', 'inicial', 'final', 'transiciones']
with open('4.txt') as f:
    valores = f.read().splitlines()
transiciones = valores[4:]
del valores[4:]
estados, lenguaje, inicial, final = valores
automata = Automata(estados.split(','), lenguaje.split(','), inicial, final.split(','), [str.split(',') for str in transiciones])

#Recibir la cadena a evaluar
print("Ingersar cadena a evaluar")
cadena = input(">")

#Empezar a evaluar la cadena
for i, c in enumerate(cadena):
    tValidas = automata.buscarTransiciones(c, i)
    for transicion in tValidas:
        automata.nuevoNodo(i, transicion[0], transicion[2])
automata.imprimirCaminos(len(cadena))
