import wollok.game.*

class Boton{
	var property color
	const imagen0=color+".png"
	const imagen1=color+"1.png"
	var imagenActual=imagen0
	
	const sonido=color+".mp3"
	
	const x
	const y
	
	method position()=game.at(x,y)

	method encendido(){
		imagenActual=imagen1
		game.sound(sonido).play()
		game.schedule(500,{imagenActual=imagen0})
	} 
	method image()=imagenActual

}

const rojo = new Boton(color="rojo",x=5,y=10)
const amarillo = new Boton(color="amarillo",x=10,y=10)
const verde = new Boton(color="verde",x=5,y=5)
const azul = new Boton(color="azul",x=10,y=5)
const violeta = new Boton(color="violeta", x=10, y=2)
const naranja = new Boton(color="naranja", x=2, y=2)
