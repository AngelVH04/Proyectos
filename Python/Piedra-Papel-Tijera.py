import tkinter as tk
from tkinter import ttk
import random

TEXTOS = [
    "Piedra",
    "Papel",
    "Tijera"
]

def obtener_texto_aleatorio():
    
    
    texto_comp = random.choice(TEXTOS)
    valorcomp=TEXTOS.index(texto_comp)
    etiqueta_resultados.config(text=texto_comp)
    
    seleccion_usuario_texto = escoger.get()
    
    valorus=TEXTOS.index(seleccion_usuario_texto)
    rest=valorus - valorcomp
    if rest == 0:
        resultado.config(text="Empate")
    elif rest == 1 or rest == -2:
        resultado.config(text="¡Ganaste! ")
    else:
        resultado.config(text="Perdiste")

ventana = tk.Tk()

ventana.title("Generador de Texto Aleatorio")

etiqueta_resultado = tk.Label(
    ventana, 
    text="Selecciona una opción", 
    font=("Arial", 14), 
    pady=20, 
    padx=20
)
etiqueta_resultado.pack()

escoger = ttk.Combobox(ventana, values=["Piedra", "Papel", "Tijera"])
escoger.current(0) 
escoger.pack()

etiqueta_resultados = tk.Label(
    ventana, 
    text="", 
    font=("Arial", 9), 
    pady=20, 
    padx=20
)
etiqueta_resultados.pack()

resultado = tk.Label(
    ventana, 
    text="", 
    font=("Arial", 12), 
    pady=20, 
    padx=20
)
resultado.pack()

boton_generar = tk.Button(
    ventana, 
    text="Presiona para jugar", 
    command=obtener_texto_aleatorio, 
    font=("Arial", 12), 
    bg="lightblue", 
    fg="black",    
    padx=10, 
    pady=5
)
boton_generar.pack(pady=10)

ventana.mainloop()
