import menu.*
import jugador.*
import boton.*
import modoDeJuego.*
import reloj.*
import powerUp.*
import wollok.game.*

object secuencia{
	const coloresDisponibles=[]
    const listaSecuencia = []
    var largoLista=0
    var posicion=0
	method iniciarSecuencia(){
		self.agregarColor()
		self.encenderColores()
	}
    method agregarColor(){
        const nuevoColor = coloresDisponibles.anyOne()
        listaSecuencia.add(nuevoColor)
        largoLista = largoLista + 1
    }
    
    method coloresDisponibles(lista){
    	coloresDisponibles.addAll(lista)
    }
    
	method listaSecuencia()=listaSecuencia
	
    method encenderColores(){
    	jugador.desbloqueado(false)
		game.onTick(1000,"a",{self.encender()})
		game.schedule(1000*(largoLista+1),{
			game.removeTickEvent("a")
			posicion=0
			jugador.desbloqueado(true)
		})
	}
	method encender(){
		listaSecuencia.get(posicion).encendido()
		posicion = posicion + 1
	}
	method reducirSecuencia(){
		listaSecuencia.take(largoLista.div(4))
		largoLista=listaSecuencia.size()
	}
	method aumentarSecuencia(){
		const cantidad=[3,4,5].anyOne()
		cantidad.times({_=>self.agregarColor()})
	}
}
