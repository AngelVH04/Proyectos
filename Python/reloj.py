import tkinter as tk  
from time import strftime

# --- Función para actualizar ---
def actualizar_reloj():
    string_hora = strftime('%I:%M:%S %p')
    label_hora.config(text=string_hora)
    
    string_dia = strftime('%A, %d %B %Y')
    label_dia.config(text=string_dia)
    
    ventana.after(1000, actualizar_reloj)

# --- Configuración de la Ventana ---
ventana = tk.Tk()
ventana.title("Reloj")
ventana.attributes("-topmost", 1)
ventana.configure(background='black') # Fondo negro para toda la ventana

# --- Creación de Widgets (Labels) ---
label_hora = tk.Label(ventana, font=('calibri', 40, 'bold'),
                     background='black',
                     foreground='white')

label_dia = tk.Label(ventana, font=('calibri', 20, 'bold'),
                    background='black', 
                    foreground='white')

label_hora.pack(anchor='center', pady=(20, 0))
label_dia.pack(anchor='center', pady=(0, 20))

# --- Iniciar la App ---
actualizar_reloj() 
tk.mainloop()
