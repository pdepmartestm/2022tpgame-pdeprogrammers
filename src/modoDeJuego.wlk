import wollok.game.*
import secuencia.*
import reloj.*
import jugador.*
import boton.*

class Controles{
	method controles(){
		keyboard.w().onPressDo({jugador.enciendeColor(rojo)})
       		keyboard.e().onPressDo({jugador.enciendeColor(amarillo)})
       		keyboard.r().onPressDo({jugador.enciendeColor(verde)})
        	keyboard.t().onPressDo({jugador.enciendeColor(azul)})
	}
}

const controlesMF=new Controles()

object controlesMM inherits Controles{
	override method controles(){
		super()
		keyboard.q().onPressDo({jugador.enciendeColor(naranja)})
    		keyboard.y().onPressDo({jugador.enciendeColor(violeta)})
	}
}

const coloresMF=[azul,verde,amarillo,rojo]
const coloresMM=coloresMF+[violeta,naranja]

const modoFacil=new ModoDeJuego(colores=coloresMF,control=controlesMF)
const modoMedio=new ModoDeJuego(colores=coloresMM,control=controlesMM)

object centro{
	method position() = game.at(7,7)
	method image() = "simon.png"
}

class ModoDeJuego{
	const property colores
	const control
	method jugar(){
		game.addVisual(centro)
		game.addVisual(digito0)
		game.addVisual(digito1)
		reloj.iniciar()
		control.controles()
		colores.forEach({unColor=>game.addVisual(unColor)})
		game.addVisual(vidasDelJugador)
		secuencia.coloresDisponibles(colores)
		secuencia.iniciarSecuencia()
	}
}
