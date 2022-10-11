import wollok.game.*

object teclado{
	var property desbloqueado=true
	method metodo(color){
		if(desbloqueado){
			desbloqueado=false
			color.encendido()
			colores.colorCorrecto(color)
		}
		else{
			
		}
	}
}

object pantallaInicial {
	
    method iniciar(){   
    	game.title("Simon P de Programmers")
    	
       // game.boardGround("fondo.png")
        game.width(23)
        game.height(23)
        game.addVisual(controles)
        keyboard.q().onPressDo({teclado.metodo(rojo)})
        keyboard.w().onPressDo({teclado.metodo(amarillo)})
        keyboard.e().onPressDo({teclado.metodo(verde)}) 
        keyboard.r().onPressDo({teclado.metodo(azul)}) 
        keyboard.t().onPressDo({teclado.metodo(naranja)})
        keyboard.y().onPressDo({teclado.metodo(violeta)})  
        keyboard.space().onPressDo({self.jugar()})
        keyboard.enter().onPressDo({colores.encenderColores()})
        keyboard.enter().onPressDo({reloj.iniciar()})
    }
    
    method jugar(){
    	game.addVisual(azul)
        game.addVisual(amarillo)
        game.addVisual(verde)
        game.addVisual(rojo)
        game.addVisual(naranja)
        game.addVisual(violeta)
        game.addVisual(gameOver)
        game.addVisual(reloj)
        game.removeVisual(gameOver)
        //game.addVisual(gameOver)
        game.removeVisual(controles)
        //colores.encenderColores()    
        //reloj.iniciar()
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
		game.schedule(500,{imagenActual=imagen0})
		game.sound(sonido).play()
	} 
	method image(){
		return imagenActual
	}	

}

const rojo = new Boton(color="rojo",x=6,y=12)
const amarillo = new Boton(color="amarillo",x=12,y=12)
const verde = new Boton(color="verde",x=6,y=6)
const azul = new Boton(color="azul",x=12,y=6)
const violeta = new Boton(color="violeta", x=12, y=3)
const naranja = new Boton(color="naranja", x=2, y=3)



object colores{

    const listaColores = [rojo]
    var largoLista=1
    var posicion=1
    method agregarColor(){
        const nuevoColor = [azul,amarillo,rojo,verde,violeta,naranja].anyOne()
        listaColores.add(nuevoColor)
    }

    method encenderColores(){
    	teclado.desbloqueado(false)
		game.onTick(1000,"a",{self.encender()})
		game.schedule(1000*(largoLista+1),{
			game.removeTickEvent("a")
			posicion=1
			teclado.desbloqueado(true)
		})
		//reloj.iniciar()
	}
	method encender(){
		listaColores.get(posicion-1).encendido()
		posicion++
	}
	/*method secuenciaCorrecta(){
		
	}*/
	method colorCorrecto(color){
		if (listaColores.get(posicion-1)==color){
			posicion++
			if (posicion>largoLista){
				posicion=1
				largoLista++
				self.agregarColor()
				self.encenderColores()
			}
			game.schedule(300,{teclado.desbloqueado(true)})
		}
		else{
			game.removeVisual(azul)
			game.removeVisual(rojo)
			game.removeVisual(violeta)
			game.removeVisual(naranja)
			game.removeVisual(amarillo)
			game.removeVisual(verde)
			game.addVisual(gameOver)
			reloj.detener()
			game.schedule(1000,{game.removeVisual(gameOver)})
		}
	}
}

object reloj {
	
	var tiempo = 0
	
	method text() = tiempo.toString()
	method position() = game.at(1, game.height()-1)
	
	method pasarTiempo() {
		tiempo = tiempo +1
	}
	method iniciar(){
		tiempo = 0
		game.onTick(1000,"tiempo",{self.pasarTiempo()})
	}
	method detener(){
		game.removeTickEvent("tiempo")
	}
}

object gameOver {
	method position() = game.center()
	method text() = "GAME OVER"
	
}

object controles{
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