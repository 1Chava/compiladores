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
        print(lista_estados, "CONJUNTO E")
        while(flag):
            lista_iterable = lista_estados - nueva_lista
            for estado in lista_iterable:
                lista_transiciones = self.buscarTransiciones(estado)
                for transicion in lista_transiciones:
                    print(str(transicion) + "para estado " + estado)
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
        print(lista_estados, "MOVER") 
        return lista_estados
    
    def ir_a(self, estados, caracter):
        return self.cerradura_epsilon(self.mover(estados, caracter))

    def transformar(self):
        flag = True
        a = Automata([], self.lenguaje, None, [], [])
        lista_usados = set()
        lista_nuevos = set()
        lista_cerradura = self.cerradura_epsilon(tuple(self.inicial))
        lista_nuevos.add(tuple(lista_cerradura))
        a.inicial = list(lista_cerradura)
        print("Para el estado inicial la cerradura epsilon es: " + str(lista_cerradura))
        while flag:
            lista_iterable = lista_nuevos - lista_usados
            for estado in lista_iterable:
                for c in self.lenguaje:
                    lista = self.ir_a(estado, c)
                    lista_nuevos.add(tuple(lista))
                    a.transiciones.append([list(estado), c, list(lista)])
                    print("Para el estado "+ str(estado) +" ir a del caracter "+ c +" es: " + str(lista))
                lista_usados.add(estado)
            if len(lista_iterable) is 0:
                flag = False
            else:
                print("____________________________")
        [a.estados.append(list(e)) for e in lista_nuevos]
        for x in a.estados:
            for y in self.final:
                if y in x and x not in a.final:
                    a.final.append(x)
        return a

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

#Recibir la cadena a evaluar
# print("Ingersar cadena a evaluar")
# cadena = input(">")

# #Empezar a evaluar la cadena
# cont = 0
# anterior = []
# for i, c in enumerate(cadena):
#     flag = True
#     while flag:
#         tValidas = automata.buscarTransiciones(c, cont)
#         for transicion in tValidas:
#             automata.nuevoNodo(cont, transicion[0], transicion[2])
#             if (transicion,c) in anterior:
#                 flag = False
#                 print("YA")
#             else:
#                 anterior.append((transicion,c))
#         cont += 1
# automata.imprimirCaminos(cont)