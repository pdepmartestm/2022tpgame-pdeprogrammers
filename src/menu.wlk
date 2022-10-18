import wollok.game.*
import jugador.*
import boton.*
import modoDeJuego.*
import secuencia.*
import reloj.*
import powerUp.*

object gameOver {
	method position() = game.at(4,7)
	method image() = "gameover.png"
	method activar(){
		game.clear()
		game.sound("loser.mp3").play()
		game.addVisual(self)		
		keyboard.enter().onPressDo({
			game.clear()
			menuInicial.eleccion()
			reloj.tiempo(60)
			secuencia.reiniciar()
		})
	}
}

object menuInicial{
	const opcionesMenu=[iniciarJuego,controls]
	var indexI=0
	var actual=iniciarJuego
	
	method eleccion(){
		keyboard.up().onPressDo({if(indexI!=0){self.cambiarI(-1)}})
		keyboard.down().onPressDo({if(indexI!=1){self.cambiarI(1)}})
		game.boardGround("black.png")
        game.width(20)
        game.height(20)
        game.addVisual(iniciarJuego)
        game.addVisual(controls)
        game.addVisual(puntero)
        keyboard.enter().onPressDo({if(indexI==0){actual.iniciarJuego()}})
        keyboard.enter().onPressDo({if(indexI==1){actual.controless()}})
		
	}
	
	method cambiarI(cant){
		indexI = indexI + cant
		game.sound("cambiarmenu.mp3").play()
		actual=opcionesMenu.get(indexI)
		puntero.y(actual.y())
		
	}
}

object elegirDificultad{
	const opciones=[easy,medium]
	var index=0
	var actual=easy
	
	method dificultades(){
		keyboard.up().onPressDo({if(index!=0){self.cambiar(-1)}})
		keyboard.down().onPressDo({if(index!=1){self.cambiar(1)}})

		game.title("Simon P de Programmers")
        game.boardGround("black.png")
        game.width(20)
        game.height(20)
        game.addVisual(medium)
        game.addVisual(easy)
        game.addVisual(puntero)
        keyboard.enter().onPressDo({actual.jugar()})
	}
	method cambiar(cant){
		index+=cant
		game.sound("cambiarmenu.mp3").play()
		actual=opciones.get(index)
		puntero.y(actual.y())
	}
}

const medium=new Opcion(nombre="medium",y=6,modo=modoMedio)
const easy=new Opcion(nombre="easy",y=8,modo=modoFacil)
const iniciarJuego=new Opcion(nombre="iniciarJuego", y=8, modo=modoFacil)
const controls=new Opcion(nombre="controls", y=6, modo=modoFacil)

object puntero{
	const x=3
	var property y=8
	method image()="pointer.png"
	method position()=game.at(x,y)
}

object settings{
	method position() = game.at(2,3)
	method image() = "settings.png"
}

object difficulty{
	method position() = game.at(3,13)
	method image() = "difficulty.png"
}

class Opcion{
	const nombre
	var modo
	var property y
	var property x = 5
	
	method image()=nombre+".png"
	
	method position()=game.at(x,y)
	
	method iniciarJuego(){
		game.clear()
		game.addVisual(difficulty)
		elegirDificultad.dificultades()
	}
	
	method controless(){
		game.clear()
		game.addVisual(settings)
		keyboard.backspace().onPressDo({menuInicial.eleccion()})
		keyboard.backspace().onPressDo({game.removeVisual(settings)})
	}
	
	method jugar(){
		game.clear()
		modo.jugar()
	}
}
