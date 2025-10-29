import tkinter as tk
from tkinter import filedialog, messagebox
from docx2pdf import convert


class convertidor:
    def __init__(self,root):
        self.root =root
        self.root.title("Convertidor Word a PDF")
        self.root.geometry("400x200")
        tk.Button(root,text="Seleccionar archivo Word",command=self.seleccionar_archivo).pack(pady=40)

    def seleccionar_archivo(self):
        archivo = filedialog.askopenfilename(
            title="Selecciona un archivo Word",
            filetypes=[("Documentos Word","*.docx")]
        )
        if archivo:
            try:
                convert(archivo)
                messagebox.showinfo("Éxito",f"Archivo convertido: \n{archivo.replace('.docx', '.pdf')}")
            except Exception as e:
                messagebox.showerror("Error", f"No se pudo convertir: \n{e}")

if __name__ =="__main__":
    root=tk.Tk()
    app=convertidor(root)
    root.mainloop()

