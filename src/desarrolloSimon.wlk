import wollok.game.*

object jugador{
	var property desbloqueado=true
	var property listajugador=[]
	var property vidas = 2
	const powers = [aumentarTiempo, reducirTiempo, aumentarVidas, reducirVidas, aumentarColores, reducirColores]
	var puntuacionMasAlta=0
	
	method enciendeColor(color){
		if(desbloqueado){
			desbloqueado=false
			color.encendido()
			listajugador.add(color)
			game.schedule(200,{desbloqueado=true})
			self.secuenciaCorrecta()
		}
	}
	
	method secuenciaCorrecta(){
		const listaSecuencia=secuencia.listaSecuencia()
		const tam=listajugador.size()
		if (listaSecuencia.take(tam)!=listajugador){
			if(vidas==1){
				listajugador=[]
				gameOver.activar()
			}
			else{
				vidas=vidas-1
				secuencia.encenderColores()
			}
		}
		else if(listaSecuencia==listajugador){
			if(tam%5==0){
				self.agregarPowerUp()
			}
			game.schedule(250,{desbloqueado=false})
			listajugador=[]
			secuencia.iniciarSecuencia()
		}
		puntuacionMasAlta=(tam).max(puntuacionMasAlta)
	}

	method sumarVida(){
		vidas=(vidas+1).min(3)
	}
	
	method restarVida(){
		vidas=(vidas-1).max(1)
	}

	method cantidadVidas()=vidas

	method agregarPowerUp(){
		powers.anyOne().aplicarPowerUp()
	}
}

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

class Controles{
	method controles(){
		keyboard.w().onPressDo({jugador.enciendeColor(rojo)})
        keyboard.e().onPressDo({jugador.enciendeColor(amarillo)})
        keyboard.s().onPressDo({jugador.enciendeColor(verde)})
        keyboard.d().onPressDo({jugador.enciendeColor(azul)})
	}
}

const controlesMF=new Controles()

object controlesMM inherits Controles{
	override method controles(){
		super()
		keyboard.q().onPressDo({jugador.enciendeColor(naranja)})
    	keyboard.r().onPressDo({jugador.enciendeColor(violeta)})
	}
}

const coloresMF=[azul,verde,amarillo,rojo]
const coloresMM=coloresMF+[violeta,naranja]

const modoFacil=new ModoDeJuego(colores=coloresMF,control=controlesMF)
const modoMedio=new ModoDeJuego(colores=coloresMM,control=controlesMM)

class ModoDeJuego{
	const property colores
	const control
	method jugar(){
		//game.addVisual(centro)
		control.controles()
		colores.forEach({unColor=>game.addVisual(unColor)})
		secuencia.coloresDisponibles(colores)
		secuencia.iniciarSecuencia()
	}
}

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

object reloj {
	
	var property tiempo = 60
	
	method text() = tiempo.toString()
	method position() = game.at(1, game.height()-1)
	
	method pasarTiempo() {
		if (tiempo==0){
			gameOver.activar()
			self.detener()
		}else{
			tiempo = tiempo - 1
		}
	}
	method iniciar(){
		game.onTick(1000,"tiempo",{self.pasarTiempo()})
	}
	method detener(){
		game.removeTickEvent("tiempo")
	}
	method sumarTiempo(cantidad){
		tiempo = tiempo + cantidad
	}
	method restarTiempo(cantidad){
		tiempo=(tiempo-cantidad).max(1)
	}
}

object gameOver {
	method position() = game.center()
	method text() = "GAME OVER"
	method activar(){
		game.clear()
		game.addVisual(self)
	}
}

// object settings{
// 	method position() = game.center()
// 	method text() = "Controls:
// SPACE: Add Visuals
// ENTER: Start Game
// Q: Red
// W: Yellow
// E: Green
// R: Blue
// T: Orange
// Y: Violet"
// }

object menuInicial{
	const opcionesMenu=[iniciarJuego,controls]
	var indexI=0
	var actual=iniciarJuego
	
	method eleccion(){
		keyboard.up().onPressDo({if(indexI!=0){self.cambiarI(-1)}})
		keyboard.down().onPressDo({if(indexI!=1){self.cambiarI(1)}})
		game.boardGround("fondoGalaxia.png")
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
		actual=opcionesMenu.get(indexI)
		puntero.y(actual.y())
	}
}

object elegirDificultad{
	const opciones=[easy,medium,hard]
	var index=0
	var actual=easy
	
	method dificultades(){
		keyboard.up().onPressDo({if(index!=0){self.cambiar(-1)}})
		keyboard.down().onPressDo({if(index!=2){self.cambiar(1)}})

		game.title("Simon P de Programmers")
        //game.boardGround("fondoGalaxia.png")
        game.width(20)
        game.height(20)
        game.addVisual(hard)
        game.addVisual(medium)
        game.addVisual(easy)
        game.addVisual(puntero)
        keyboard.enter().onPressDo({actual.jugar()})
	}
	method cambiar(cant){
		index+=cant
		actual=opciones.get(index)
		puntero.y(actual.y())
	}
}

const hard=new Opcion(nombre="hard",y=4,modo=modoFacil)
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

class Opcion{
	const nombre
	var modo
	var property y
	var property x = 5
	
	method image()=nombre+".png"
	
	method position()=game.at(x,y)
	
	method iniciarJuego(){
		game.clear()
		elegirDificultad.dificultades()
	}
	
	method controless(){
		game.clear()
		game.addVisual("settings.png")
		keyboard.backspace().onPressDo({menuInicial.eleccion()})
	}
	
	method jugar(){
		game.clear()
		modo.jugar()
	}
}

class PowerUp{

	method aplicarPowerUp(){}

}

object aumentarTiempo inherits PowerUp{
	const segundos=[5,10,15]
	override method aplicarPowerUp(){
		reloj.sumarTiempo(segundos.anyOne())
	}
}

object reducirTiempo inherits PowerUp{
	const segundos=[5,10,15]
	override method aplicarPowerUp(){
		reloj.restarTiempo(segundos.anyOne())
	}
}

object aumentarVidas inherits PowerUp{
	override method aplicarPowerUp(){
		jugador.sumarVida()
	}
}

object reducirVidas inherits PowerUp{ 
	override method aplicarPowerUp(){
		jugador.restarVida()
	}
}

object reducirColores inherits PowerUp{
	override method aplicarPowerUp(){
		secuencia.reducirSecuencia()
	}
}

object system32 inherits PowerUp{
	override method aplicarPowerUp(){
		gameOver.activar()
	}
}

object aumentarColores inherits PowerUp{
	override method aplicarPowerUp(){
		secuencia.aumentarSecuencia()
	}
}
