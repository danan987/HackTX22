from kivy.app import App
from kivy.uix.gridlayout import GridLayout
from kivy.uix.label import Label
from kivy.uix.image import Image
from kivy.uix.button import Button
from kivy.uix.textinput import TextInput
from datetime import datetime
from kivy.uix.label import Label
from kivy.core.window import Window

class createDate(App):
    def build(self):
        self.window = GridLayout()
        self.window.cols = 1
        self.window.size_hint = (0.6, 0.7)
        self.window.pos_hint = {"center_x": 0.5, "center_y": 0.5 }
        self.window.add_widget(Image(source = "Safenet.png"))
        Window.clearcolor = (0.9803921569, 0.768627451, 0.0274509804, 1)


        self.dateDateRequest = Label(
            text = "where is your next date?", 
            font_size = 25,
            color = "#ffffff",
            bold = True
        )
        self.window.add_widget(self.dateDateRequest)
        
        self.enterDateDate = TextInput(
            multiline=False,
            padding_y = (10, 10),
            size_hint = (1, 0.4),
            font_size = 20
        )
        self.window.add_widget(self.enterDateDate)

        self.dateTimeRequest = Label(
            text = "when is your next date?",
            font_size = 25,
            color = "#ffffff",
            bold = True
        )
        self.window.add_widget(self.dateTimeRequest)

        self.enterDateTime = TextInput(
            multiline = False,
            padding_y = (10, 10),
            size_hint = (1, 0.4),
            font_size = 20
        )
        self.window.add_widget(self.enterDateTime)
        
        self.button = Button(
            text = "enter information",
            size_hint = (1, 0.4),
            bold = True,
            font_size = 30
        )
        self.button.bind(on_press = self.confirm)

        
        self.window.add_widget(self.button)
        self.thankYou = Label(
            text = "thank you!",
            font_size = 25,
            color = "#ffffff",
            bold = True
        )

        return self.window

    def confirm(self, event): 
        self.window.remove_widget(self.dateDateRequest)
        self.window.remove_widget(self.enterDateDate)
        self.window.remove_widget(self.dateTimeRequest)
        self.window.remove_widget(self.enterDateTime)
        self.window.remove_widget(self.button)
        self.window.add_widget(self.thankYou)

        
if __name__ == "__main__":
    createDate().run()
