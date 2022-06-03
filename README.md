# TP-Solidity
 
### Link de etherscan:


### Integrantes: 
Matias B. e Ilan R.

### Respuestas:
#### a. Como modificarias el Smart Contract para que acepte notas de 4 bimestres?
El mapping de _notas_materias que es (string => uint8), lo cambiariamos a un mapping de (string => mapping(uint8 => uint8)). La primera key seria la materia y adentro tendria un mapping que tiene una key de bimestre y el valor de nota. Tambien habria que modificar la funcion set_notas_materias, nota_materia, aprobo y promedio.
#### b. Como le permitirias al docente darle permiso a otros docentes de asignar notas
Agregariamos un mapping (address => bool) donde la key es la address de otra docente y el valor es true cuando tiene permiso y false cuando no. Agregariamos una funcion llamada set_permiso (recibe una address y un bool), donde la docente puede modificar el mapping permisos y poner true o false a la address ingresada.
#### c. Investigar sobre los eventos de Solidity, como incluirias un evento para registrar cuando el docente determina una nota.
Creariamos un evento (llamado SetNota) que reciba una address (docente que modifico), un string (materia) y un uint8 (nota). En la funcion set_nota_materia, hariamos un emit al evento pasando msg.sender, materia_ y nota_.