# This file was generated by the Tkinter Designer by Parth Jadhav
# https://github.com/ParthJadhav/Tkinter-Designer

#only loads the first page

from pathlib import Path

# from tkinter import *
# Explicit imports to satisfy Flake8
from tkinter import Tk, Canvas, Entry, Text, Button, PhotoImage, Frame, Label
import tkinter.font as font
from PIL import ImageTk, Image


OUTPUT_PATH = Path(__file__).parent
ASSETS_PATH = OUTPUT_PATH / Path("./assets")


def relative_to_assets(path: str) -> Path:
    return ASSETS_PATH / Path(path)


window = Tk()

#sets the size of the app
window.geometry("390x844")
window.configure(bg = "#FDEFBB")


canvas = Canvas(
    window,
    bg = "#FDEFBB",
    height = 844,
    width = 390,
    bd = 0,
    highlightthickness = 0,
    relief = "ridge"
)

#title of the product
canvas.place(x = 100, y = 0)
canvas.create_text(
    30.0,
    118.0,
    anchor = "nw",
    text="SafeNet",
    fill="#000000",
    font=("Dense", 70 * -1)
)

#logo of product
frame = Frame(window, width=600, height=400)
frame.pack()
frame.place(anchor='center', relx=0.5, y=350)
img= (Image.open("logo.png"))
resized_image= img.resize((250,250), Image.ANTIALIAS)
new_image= ImageTk.PhotoImage(resized_image)

label = Label(frame, image = new_image)
label.pack()

#slogan of product
canvas.create_text(
    0,
    491.0,
    anchor="nw",
    width = 220,
    justify = "center",
    text="Your Digital Best Friend to Always Check on You <3",
    fill="#000000",
    font=("Dense", 32 * -1)
)

#button to press to log in (has no function as of now except to click for fun)
myfont = font.Font(family = "Dense", size = 30)

button = Button(
    window,
    text = "Login",
    width = 5,
    height = 1,
    bg = "white",
    fg = "black",
    bd = 2,
    highlightcolor = "black",
    font= myfont, 
)

button.place(x = 150, y = 600)
window.resizable(True, True)
window.mainloop()
