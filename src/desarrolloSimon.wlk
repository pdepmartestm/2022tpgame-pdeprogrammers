import wollok.game.*



object teclado{
	var property desbloqueado=true
	var property listaTeclado=[]
	method enciendeColor(color){
		if(desbloqueado){
			desbloqueado=false
			color.encendido()
			listaTeclado.add(color)
			game.schedule(200,{desbloqueado=true})
			self.secuenciaCorrecta()
		}
	}
	method secuenciaCorrecta(){
		const listaSecuencia=secuencia.listaSecuencia()
		const tam=listaTeclado.size()
		if (listaSecuencia.take(tam)!=listaTeclado){
			listaTeclado=[]
			gameOver.activar()
		}
		else if(listaSecuencia==listaTeclado){
			game.schedule(250,{desbloqueado=false})
			listaTeclado=[]
			secuencia.agregarColor()
		}
	}
}

class Boton{
	var property color
	const imagen0=color+"01.png"
	const imagen1=color+"11.png"
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

const controlesModoFacil=[
		keyboard.w().onPressDo({teclado.enciendeColor(rojo)}),
        keyboard.e().onPressDo({teclado.enciendeColor(amarillo)}),
        keyboard.s().onPressDo({teclado.enciendeColor(verde)}),
        keyboard.d().onPressDo({teclado.enciendeColor(azul)})
		]

const controlesModoMedio=[
	keyboard.q().onPressDo({teclado.enciendeColor(naranja)}),
    keyboard.r().onPressDo({teclado.enciendeColor(violeta)})
]

const modoVoid=new ModoDeJuego(colores=[],controles=[])
const modoFacil=new ModoDeJuego(colores=[azul,verde,amarillo,rojo],controles=controlesModoFacil)
const modoMedio=new ModoDeJuego(colores=[azul,verde,amarillo,rojo,naranja,violeta],controles=controlesModoFacil+controlesModoMedio)

class ModoDeJuego{
	const property colores
	const property controles
	method jugar(){
		self.controles()
		colores.forEach({unColor=>game.addVisual(unColor)})
		secuencia.coloresDisponibles(colores)
		secuencia.agregarColor()
	}
}

object secuencia{
	const coloresDisponibles=[]
    const listaSecuencia = []
    var largoLista=0
    var posicion=0
    method agregarColor(){
        const nuevoColor = coloresDisponibles.anyOne()
        listaSecuencia.add(nuevoColor)
        largoLista++
        self.encenderColores()
    }
    
    method coloresDisponibles(lista){
    	coloresDisponibles.addAll(lista)
    }
    
	method listaSecuencia()=listaSecuencia
	
    method encenderColores(){
    	teclado.desbloqueado(false)
		game.onTick(1000,"a",{self.encender()})
		game.schedule(1000*(largoLista+1),{
			game.removeTickEvent("a")
			posicion=0
			teclado.desbloqueado(true)
		})
	}
	method encender(){
		listaSecuencia.get(posicion).encendido()
		posicion++
	}
}

object reloj {
	
	var property tiempo =60
	
	method text() = tiempo.toString()
	method position() = game.at(1, game.height()-1)
	
	method pasarTiempo() {
		if (tiempo==0){
			gameOver.activar()
			self.detener()
			}
		else{
			tiempo-=1
			}
	}
	method iniciar(){
		game.onTick(1000,"tiempo",{self.pasarTiempo()})
	}
	method detener(){
		game.removeTickEvent("tiempo")
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

object settings{
	method position() = game.center()
	method text() = "Controls:
SPACE: Add Visuals
ENTER: Start Game
Q: Red
W: Yellow
E: Green
R: Blue
T: Orange
Y: Violet"
}



object menu{
	const opciones=[op2,op1,op0]
	var index=0
	var actual=op2
	method inicio(){
		keyboard.up().onPressDo({if(index!=0){self.cambiar(-1)}})
		keyboard.down().onPressDo({if(index!=2){self.cambiar(1)}})

		game.title("Simon P de Programmers")
       // game.boardGround("fondo.png")
        game.width(20)
        game.height(20)
        game.addVisual(op0)
        game.addVisual(op1)
        game.addVisual(op2)
        game.addVisual(puntero)
        keyboard.enter().onPressDo({actual.jugar()})
	}
	method cambiar(cant){
		index+=cant
		actual=opciones.get(index)
		puntero.y(actual.y())
	}
}

const op0=new Opcion(nombre="op0",y=4,modo=modoFacil)
const op1=new Opcion(nombre="op1",y=6,modo=modoFacil)
const op2=new Opcion(nombre="op2",y=8,modo=modoFacil)
const puntero=new Opcion(nombre="puntero",y=8,modo=modoVoid)

class Opcion{
	const nombre
	const modo
	var property y
	method image()=nombre+".png"
	method position()=game.at(5,y)
	method jugar(){
		game.clear()
		modo.jugar()
	}
}