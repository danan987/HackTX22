from kivy.app import App
from kivy.uix.gridlayout import GridLayout
from kivy.uix.label import Label
from kivy.uix.image import Image
from kivy.uix.button import Button
from kivy.uix.textinput import TextInput
from datetime import datetime
from kivy.uix.label import Label
from kivy.core.window import Window



class AgeCalculator(App):
    def build(self):
        self.window = GridLayout()
        self.window.cols = 1
        self.window.size_hint = (0.6, 0.7)
        self.window.pos_hint = {"center_x": 0.5, "center_y": 0.5 }
        self.window.add_widget(Image(source = "Safenet.png"))
        Window.clearcolor = (0.9803921569, 0.768627451, 0.0274509804, 1)


        self.nameRequest = Label(
            text = "hi! please enter your name below :)", 
            font_size = 25,
            color = "#ffffff",
            bold = True
        )
        self.window.add_widget(self.nameRequest)
        
        self.enterName = TextInput(
            multiline=False,
            padding_y = (10, 10),
            size_hint = (1, 0.4),
            font_size = 30
        )
        self.window.add_widget(self.enterName)

        self.button = Button(
            text = "Enter your name",
            size_hint = (1, 0.4),
            bold = True,
            font_size = 30
        )
        self.button.bind(on_press = self.getIntro)
        self.window.add_widget(self.button)


        return self.window

    def getIntro(self, event): 
        name = self.enterName.text
        self.nameRequest.text = "hi " + str(name) + "! welcome to Safenet:"\
                                "\n" + "your digital best friend to always check on you <3"\
                                + "\nbefore we get started, we'll need a few details"\
                                + " to get to know you better."
        self.window.remove_widget(self.enterName)
        self.window.remove_widget(self.button)

        
if __name__ == "__main__":
    AgeCalculator().run()
