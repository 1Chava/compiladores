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
        for sublist in self.transiciones:
            nodos = self.rutas.getNodos(i)
            if ([sublist[0] == nodo.indice for nodo in nodos]) and (sublist[1] in c):
                tValidas.append(sublist)
        return tValidas

    def nuevoNodo(self, i, eAnterior, eNuevo):
        nAnterior = self.rutas.getNodo(i, eAnterior)
        if nAnterior is not None:
            nAnterior.siguientes.append(Nodo(i+1, eNuevo, nAnterior))
        
    def imprimirCaminos(self, i):
        nodos = self.rutas.getNodos(i)
        [print(nodo) for nodo in nodos]

    

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
with open('practica1.txt') as f:
    valores = f.read().splitlines()
transiciones = valores[4:]
del valores[4:]
estados, lenguaje, inicial, final = valores
automata = Automata(estados.split(','), lenguaje.split(','), inicial, final, [str.split(',') for str in transiciones])

#Recibir la cadena a evaluar
print("Ingersar cadena a evaluar")
cadena = input(">")

#Empezar a evaluar la cadena
for i, c in enumerate(cadena):
    tValidas = automata.buscarTransiciones(c, i)
    print(tValidas)
    for transicion in tValidas:
        automata.nuevoNodo(i, transicion[0], transicion[2])
print(len(cadena))
automata.imprimirCaminos(2)