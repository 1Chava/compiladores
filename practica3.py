#practica3.py

class Automata:
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
        a = Automata({}, self.lenguaje, None, [], [])
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
with open('practica3.txt') as f:
    valores = f.read().splitlines()
transiciones = valores[4:]
del valores[4:]
estados, lenguaje, inicial, final = valores
NFA = Automata(estados.split(','), lenguaje.split(','), inicial, final.split(','), [str.split(',') for str in transiciones])

a = NFA.transformar()
print(a.estados, "estados")
print(a.lenguaje, "lenguaje")
print(a.inicial, "inicial")
print(a.final, "final")
print(a.transiciones, "transiciones")