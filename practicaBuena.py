#practicaBuena.py

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

class Automata2:
    def __init__(self, estados, lenguaje, inicial, final, transiciones):
        self.estados = estados
        self.lenguaje = lenguaje
        self.inicial = inicial
        self.final = final
        self.transiciones = transiciones
        self.contieneSolucion = 0
        self.rutas = [Nodo2(0, inicial)]

    def buscarTransiciones(self, estado, char):
        tValidas = []
        for sublist in self.transiciones:
            if (int(sublist[0]) == int(estado.estadoActual)) and (sublist[1] == char or sublist[1] == "E"):
                tValidas.append(sublist)
        return tValidas

    def nuevoNodo(self, i, lista):
        for nAnterior in self.rutas:
            if int(nAnterior.estadoActual) == int(lista[0]):
                if lista[1] is "E":
                    nodo = Nodo2(nAnterior.indice, lista[2], nAnterior, lista[1])
                else:
                    nodo = Nodo2(nAnterior.indice+1, lista[2], nAnterior, lista[1])
                nAnterior.siguientes.append(nodo)
                return nodo 

class Nodo2:
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
        if type(self.padre) is not Nodo2:
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


class Automata3:
    def __init__(self, estados=None, lenguaje=None, inicial=None, final=None, transiciones=None):
        self.estados = estados
        self.lenguaje = lenguaje
        self.inicial = inicial
        self.final = final
        self.transiciones = transiciones
        self.contieneSolucion = 0

    def buscarTransiciones(self, c, e="E"):
        tValidas = []
        for sublist in self.transiciones:
            if (sublist[0] in c and sublist[1] is e):
                tValidas.append(sublist)
        return tValidas
    
    def cerradura_epsilon(self, e):
        if len(e) is 0:
            return set()
        flag = True
        lista_estados = set(e)
        nueva_lista = set()
        while(flag):
            lista_iterable = lista_estados - nueva_lista
            for estado in lista_iterable:
                lista_transiciones = self.buscarTransiciones(estado)
                for transicion in lista_transiciones:
                    lista_estados.add(transicion[2])
                nueva_lista.add(estado)
            if len(lista_iterable) is 0:
                flag = False
        return nueva_lista
    
    def mover(self, estados, caracter):
        lista_estados = set()
        for estado in estados:
            lista_transiciones = self.buscarTransiciones(estado, caracter)
            for transicion in lista_transiciones:
                lista_estados.add(transicion[2])
        return lista_estados
    
    def ir_a(self, estados, caracter):
        return self.cerradura_epsilon(self.mover(estados, caracter))

    def transformar(self):
        flag = True
        cont = "A"
        a = Automata3({}, self.lenguaje, None, [], [])
        lista_usados = set()
        lista_nuevos = set()
        lista_cerradura = self.cerradura_epsilon(tuple(self.inicial))
        lista_nuevos.add(tuple(lista_cerradura))
        a.estados[cont] = list(lista_cerradura)
        a.inicial = cont
        print("Para el estado inicial la cerradura epsilon es: " + str({cont: list(lista_cerradura)}))
        while flag:
            lista_iterable = lista_nuevos - lista_usados
            for estado in lista_iterable:
                llave_estado = a.getKeys(list(estado))
                for c in self.lenguaje:
                    lista = self.ir_a(estado, c)
                    llave = a.getKeys(list(lista))
                    if len(llave) is 0:
                        cont = chr(ord(cont)+1)
                        lista_nuevos.add(tuple(lista))
                        a.estados[cont] = list(lista)
                        a.transiciones.append([llave_estado, c, cont])
                    else:
                        a.transiciones.append([llave_estado, c, llave])
                    print("Para el estado "+ str(estado) +" ir a del caracter "+ c +" es: " + str(lista))
                lista_usados.add(estado)
            if len(lista_iterable) is 0:
                flag = False
            else:
                print("____________________________")
        for key, value in a.estados.items():
            for y in self.final:
                if y in value and key not in a.final:
                    a.final.append(key)
        return a

    def getKeys(self, estado):
        if estado in self.estados.values():
            return list(self.estados.keys())[list(self.estados.values()).index(estado)]
        else:
            return []

#Leer automata y meterlo inicializar el automata
llaves = ['estados', 'lenguaje', 'inicial', 'final', 'transiciones']
with open('Thompson2.txt') as f:
    valores = f.read().splitlines()
transiciones = valores[4:]
del valores[4:]
estados, lenguaje, inicial, final = valores
automata = Automata2(estados.split(','), lenguaje.split(','), inicial, final.split(','), [str.split(',') for str in transiciones])

#Recibir la cadena a evaluar
print("Ingersar cadena a evaluar")
cadena = input(">")

#Empezar a evaluar la cadena
siguientes = []
for i, c in enumerate(cadena):
    flag = True
    while flag:
        lista_iterable = set(automata.rutas) - set(siguientes) 
        for estado in lista_iterable:
            tValidas = automata.buscarTransiciones(estado, c)
            for transicion in tValidas:
                nodo = automata.nuevoNodo(i, transicion)
                if type(nodo) is Nodo2 and nodo.verAnterior(nodo.estadoActual, c):
                    if nodo.indice is not i+1:
                        flag = False
                siguientes.append(nodo)
            if len(tValidas) is 0:
                if estado.indice > i:
                    siguientes.append(estado)
                if estado.indice is i+1:
                    flag = False
        automata.rutas.clear()
        for nodo in siguientes:
            if type(nodo) is Nodo2:
                automata.rutas.append(nodo)
        siguientes.clear()

flag = False
nodos = set(automata.rutas)
for nodo in nodos:
    if nodo.estadoActual in automata.final and nodo.indice == len(cadena):
        if flag is False:
            print("Si es aceptada")
            flag = True
        print(nodo)
if flag is False:
    print("La cadena no es aceptada")

print("\n --------------INICIA TRANSFORMACIÔN--------------\n")
NFA = Automata3(automata.estados, automata.lenguaje, automata.inicial, automata.final, automata.transiciones)

a = NFA.transformar()
print(a.estados, "estados")
print(a.lenguaje, "lenguaje")
print(a.inicial, "inicial")
print(a.final, "final")
print(a.transiciones, "transiciones")

print(list(a.estados.keys()))

print("\n --------------INICIA DFA--------------\n")

automata = Automata(list(a.estados.keys()), a.lenguaje, a.inicial, a.final, a.transiciones)

for i, c in enumerate(cadena):
    tValidas = automata.buscarTransiciones(c, i)
    for transicion in tValidas:
        automata.nuevoNodo(i, transicion[0], transicion[2])
automata.imprimirCaminos(len(cadena))